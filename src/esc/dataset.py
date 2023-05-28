import os
import numpy as np
import pandas as pd
import librosa
import pydub
import math
import sys
import gc
import logging
import gammatone.gtgram
import multiprocessing as mp
from configparser import ConfigParser


class Dataset:
    def __init__(self, configFilePath) -> None:
        """
        self.categoryList = ['category']
        self.fileList = [['file1', 'file2'], ['file1', 'file2']]
        self.audioData = [[np.array, np.array], [np.array, np.array]]
        self.featureData = DataFrame (index = [category], columns = [feature1, feature2, feature3, ...])
        """
        # * Load config settings
        self.config = ConfigParser()
        self.config.read(configFilePath)
        numba_logger = logging.getLogger("numba")
        numba_logger.setLevel(logging.WARNING)
        logging.info(f"Loaded config file.")
        # * Load Audio Dataset Path
        logging.info(f"Loading dataset.")
        datasetPath = self.config["path"][self.config["experiment"]["dataset"]]
        self.categoryList = []
        self.fileList = []
        for root, dirs, files in os.walk(datasetPath):
            self.categoryList += dirs
        for i, val in enumerate(self.categoryList):
            self.fileList.append([])
            for root, dirs, files in os.walk(os.path.join(datasetPath, val)):
                for file in files:
                    path = os.path.join(root, file)
                    path = os.path.normpath(path)
                    self.fileList[i].append(path)
        # * Setup Variables
        logging.info(f"Loading audio files.")
        self.audioData = np.empty(
            (len(self.categoryList), len(self.fileList[0])), dtype=object
        )
        self.cases = pd.DataFrame()

    def _processAudio(self, indexA, indexB):
        # todo : Make this function to perform audio segmentation and feature extraction for a single audio file
        # * trim/overlay to exactly duration seconds
        data = pydub.AudioSegment.silent(
            duration=int(self.config["segmentation"]["duration"])
        )
        data = data.overlay(
            (pydub.AudioSegment.from_file(self.fileList[indexA][indexB]))
            .set_frame_rate(int(self.config["segmentation"]["RATE"]))
            .set_channels(int(self.config["segmentation"]["CHANNELS"]))[
                0 : int(self.config["segmentation"]["duration"])
            ]
        )
        raw = (np.frombuffer(data._data, dtype="int16") + 0.5) / (0x7FFF + 0.5)
        S = np.abs(
            librosa.stft(
                y=raw,
                n_fft=int(self.config["segmentation"]["FRAME"]),
                hop_length=int(self.config["segmentation"]["HOP"]),
            )
        )
        case = pd.DataFrame(
            data={
                "filename": [os.path.basename(self.fileList[indexA][indexB])],
                "category": [self.categoryList[indexA]],
            }
        )

        # * Feature Extraction
        if self.config["feature"]["MFCC"] == "True":
            self._compute_mel_mfcc(raw, True)
            mfcc_mean = pd.DataFrame(np.mean(self.mfcc[:, :], axis=0)[0:]).T
            mfcc_mean.columns = list(
                "MFCC_{} mean".format(i) for i in range(np.shape(self.mfcc)[1])
            )[0:]
            mfcc_std = pd.DataFrame(np.std(self.mfcc[:, :], axis=0)[0:]).T
            mfcc_std.columns = list(
                "MFCC_{} std dev".format(i) for i in range(np.shape(self.mfcc)[1])
            )[0:]
            case = case.join(mfcc_mean)
            case = case.join(mfcc_std)
        if self.config["feature"]["LBP"] == "True":
            self._compute_lbp(raw, 2)
            lbp_mean = pd.DataFrame(np.mean(self.lbp[:, :], axis=0)[0:]).T
            lbp_mean.columns = list(
                "LBP_{} mean".format(i) for i in range(np.shape(self.lbp)[1])
            )[0:]
            lbp_std = pd.DataFrame(np.std(self.lbp[:, :], axis=0)[0:]).T
            lbp_std.columns = list(
                "LBP_{} std dev".format(i) for i in range(np.shape(self.lbp)[1])
            )[0:]
            case = case.join(lbp_mean)
            case = case.join(lbp_std)

        self.cases = pd.concat([self.cases, case], ignore_index=True)

        # * Save array to h5 file
        pass

    def _compute_mel_mfcc(self, audio, mfcc):
        # Compute Mel Spectogram with 2048 FFT window length, HOP Length 1024, 128 bands
        self.melspectrogram = librosa.feature.melspectrogram(
            y=audio,
            n_fft=int(self.config["segmentation"]["FRAME"]),
            sr=int(self.config["segmentation"]["RATE"]),
            hop_length=int(self.config["segmentation"]["HOP"]),
            n_mels=128,
        )
        # Compute MFCC
        logamplitude = librosa.amplitude_to_db(self.melspectrogram)
        if mfcc:
            self.mfcc = librosa.feature.mfcc(S=logamplitude, n_mfcc=128).transpose()
        self.melspectrogram = self.melspectrogram.transpose()

    def _compute_cqt(self, audio):
        # Compute constant-Q power spectrum with HOP Length 1024 and 128 bands
        C = librosa.cqt(
            y=audio.raw,
            sr=Dataset.RATE,
            hop_length=Dataset.HOP_LENGTH,
            n_bins=128,
            bins_per_octave=128,
        )
        self.cqt = librosa.amplitude_to_db(np.abs(C), ref=np.max).transpose()

    def _compute_chroma(self, spectre):
        # Compute a chromagram from power spectrogram with HOP Length 1024 and 128 bands
        c = librosa.feature.chroma_stft(
            S=spectre,
            n_fft=Dataset.FRAME,
            sr=Dataset.RATE,
            hop_length=Dataset.HOP_LENGTH,
            n_chroma=128,
        )
        self.chroma = c.transpose()

    def _compute_gfcc(self, audio):
        # Compute a gammatone filter bank from signal with HOP Length 1024 and 128 bands
        c = gammatone.gtgram.gtgram(
            audio.raw,
            fs=Dataset.RATE,
            window_time=Dataset.FRAME / Dataset.RATE,
            hop_time=Dataset.HOP_LENGTH / Dataset.RATE,
            channels=128,
            f_min=0,
        )
        nframes = int(
            np.ceil((len(audio.data) / 1000.0 * Dataset.RATE) / Dataset.HOP_LENGTH)
        )
        if c.shape[1] < nframes:  # pad first and last column
            c = np.insert(c, 0, 0, axis=1)
            c = np.insert(c, nframes - 1, 0, axis=1)
        self.gfcc = c.transpose()

    def _compute_lpq1d(self, audio, test64):
        # LPQ 1D
        self.lpq1d_64 = []
        self.lpq1d_256 = []
        szWind = 9
        midSzWind = int((szWind - 1) / 2)
        lgth = len(audio.data)
        histoBin64 = 64
        histoBin256 = 256
        frames = int(
            np.ceil(len(audio.data) / 1000.0 * Dataset.RATE / Dataset.HOP_LENGTH)
        )
        for f in range(0, frames):
            frame = Dataset._get_frame(audio, f)
            frLgth = len(frame)
            histo64 = []
            histo256 = []
            squWinTotal = []
            if test64:
                for j in range(histoBin64):
                    histo64.append(0)
            for j in range(histoBin256):
                histo256.append(0)
            # Compute LPQ for each point
            for i in range(midSzWind, frLgth - midSzWind):
                # Compute Square window
                squWin = []
                # Intialize array
                for j in range(szWind):
                    squWin.append(0)
                for k in range(szWind):
                    pos = i - midSzWind + k
                    squWin[k] = frame[pos]
                # Add gaussian noise
                for k in range(szWind):
                    squWin[k] *= Dataset._funcgauss1D(abs(k - midSzWind), 1.0 * szWind)
                # np.append(squWinTotal, squWin)
                squWinTotal.append(squWin)
            squWinTotal = np.asarray(squWinTotal)
            # print(np.shape(squWinTotal))
            squWinTotalRavel = squWinTotal.ravel()
            # Short FFT computation with midSzWind window length, szWind hop length
            audioFFT = librosa.stft(squWinTotalRavel, n_fft=szWind, hop_length=szWind)
            audioShape = np.shape(audioFFT)
            # print(audioShape)# should be (midSzWind,frLgth-szWind)
            for i in range(0, audioShape[1]):
                code = 0
                real = audioFFT[midSzWind, i].real
                imag = audioFFT[midSzWind, i].imag
                code = code + Dataset._sign_LPQ(real, imag) * pow(4, 0)

                real = audioFFT[midSzWind - 1, i].real
                imag = audioFFT[midSzWind - 1, i].imag
                code = code + Dataset._sign_LPQ(real, imag) * pow(4, 1)

                real = audioFFT[midSzWind - 2, i].real
                imag = audioFFT[midSzWind - 2, i].imag
                code = code + Dataset._sign_LPQ(real, imag) * pow(4, 2)

                if test64:
                    histo64[code] = histo64[code] + 1

                real = audioFFT[midSzWind - 3, i].real
                imag = audioFFT[midSzWind - 3, i].imag
                code = code + Dataset._sign_LPQ(real, imag) * pow(4, 3)

                histo256[code] = histo256[code] + 1
            if test64:
                self.lpq1d_64.append(histo64)
            self.lpq1d_256.append(histo256)
        if test64:
            self.lpq1d_64 = np.asarray(self.lpq1d_64)
        self.lpq1d_256 = np.asarray(self.lpq1d_256)

    def _compute_lbp1d(self, audio, test64):
        # LBP-1D
        self.lbp1d_64 = []
        self.lbp1d_256 = []
        r = 4  # radius 4 and points 8
        frames = int(
            np.ceil(len(audio.data) / 1000.0 * Dataset.RATE / Dataset.HOP_LENGTH)
        )
        for i in range(0, frames):
            frame = Dataset._get_frame(audio, i)
            histoBin64 = 64
            histoBin256 = 256
            histo64 = []
            histo256 = []
            if test64:
                for j in range(histoBin64):
                    histo64.append(0)
            for j in range(histoBin256):
                histo256.append(0)
            frLgth = len(frame)
            for j in range(r, frLgth - r):
                code = 0
                x = frame[j]
                code = code + Dataset._sign_LBP(frame[j + 1] - x) * pow(2, 0)
                code = code + Dataset._sign_LBP(frame[j - 1] - x) * pow(2, 1)
                code = code + Dataset._sign_LBP(frame[j + 2] - x) * pow(2, 2)
                code = code + Dataset._sign_LBP(frame[j - 2] - x) * pow(2, 3)
                code = code + Dataset._sign_LBP(frame[j + 3] - x) * pow(2, 4)
                code = code + Dataset._sign_LBP(frame[j - 3] - x) * pow(2, 5)
                if test64:
                    histo64[code] = histo64[code] + 1

                code = code + Dataset._sign_LBP(frame[j + 4] - x) * pow(2, 6)
                code = code + Dataset._sign_LBP(frame[j - 4] - x) * pow(2, 7)
                histo256[code] = histo256[code] + 1
            if test64:
                self.lbp1d_64.append(histo64)
            self.lbp1d_256.append(histo256)
        if test64:
            self.lbp1d_64 = np.asarray(self.lbp1d_64)
        self.lbp1d_256 = np.asarray(self.lbp1d_256)

    def _compute_lbp(self, audio, extract):
        self.lbp = []  # Histogram of the LBP
        self.lbpRaw = []  # Raw value of the LBP
        melShape = self.melspectrogram.shape
        histoBin = 256
        if extract == 0:
            self.lbpRaw = np.zeros(melShape)
        elif extract == 1:
            self.lbp = np.zeros((melShape[0], histoBin))
        else:
            self.lbpRaw = np.zeros(melShape)
            self.lbp = np.zeros((melShape[0], histoBin))
        for i in range(1, melShape[0] - 1):
            for j in range(1, melShape[1] - 1):
                code = 0
                x = self.melspectrogram[i][j]
                code = code + Dataset._sign_LBP(
                    self.melspectrogram[i - 1][j + 1] - x
                ) * pow(2, 0)
                code = code + Dataset._sign_LBP(
                    self.melspectrogram[i][j + 1] - x
                ) * pow(2, 1)
                code = code + Dataset._sign_LBP(
                    self.melspectrogram[i + 1][j + 1] - x
                ) * pow(2, 2)
                code = code + Dataset._sign_LBP(
                    self.melspectrogram[i + 1][j] - x
                ) * pow(2, 3)
                code = code + Dataset._sign_LBP(
                    self.melspectrogram[i + 1][j - 1] - x
                ) * pow(2, 4)
                code = code + Dataset._sign_LBP(
                    self.melspectrogram[i][j - 1] - x
                ) * pow(2, 5)
                code = code + Dataset._sign_LBP(
                    self.melspectrogram[i - 1][j - 1] - x
                ) * pow(2, 6)
                code = code + Dataset._sign_LBP(
                    self.melspectrogram[i - 1][j] - x
                ) * pow(2, 7)
                if extract > 0:
                    self.lbp[i][code] = self.lbp[i][code] + 1
                if extract == 0 or extract == 2:
                    self.lbpRaw[i][j] = code

    def _compute_elbp(self, audio, extract):
        self.elbp = []  # Histogram of the LBP
        self.elbpRaw = []  # Raw value of the LBP
        melShape = self.melspectrogram.shape
        radius = 1
        neighbors = 8
        rows = int(melShape[0])
        cols = int(melShape[1])
        histo = []  # Histogram of ELBP
        rawVal = np.zeros((rows, cols))  # ELBP raw value
        for n in range(neighbors):
            # sample points
            x = radius * math.cos(2.0 * math.pi * n / neighbors)
            y = -radius * math.sin(2.0 * math.pi * n / neighbors)
            # relative indices
            fx = int(np.floor(x))
            fy = int(np.floor(y))
            cx = int(np.ceil(x))
            cy = int(np.ceil(y))
            # fractional part
            ty = y - fy
            tx = x - fx
            # set interpolation weights
            w1 = (1 - tx) * (1 - ty)
            w2 = tx * (1 - ty)
            w3 = (1 - tx) * ty
            w4 = tx * ty
            # iterate through your data
            for i in range(radius, rows - radius):
                for j in range(radius, cols - radius):
                    t1 = (
                        w1 * self.melspectrogram[i + fy][j + fx]
                        + w2 * self.melspectrogram[i + fy][j + cx]
                    )
                    t2 = (
                        w3 * self.melspectrogram[i + cy][j + fx]
                        + w4 * self.melspectrogram[i + cy][j + cx]
                    )
                    t = t1 + t2
                    rawVal[i - radius][j - radius] += (
                        (t > self.melspectrogram[i][j])
                        and (
                            abs(t - self.melspectrogram[i][j]) > sys.float_info.epsilon
                        )
                    ) << n
        rawVal, histo = Dataset._limit_and_histo(rawVal)
        if extract == 0:
            self.elbpRaw = rawVal
        elif extract == 1:
            self.elbp = histo
        else:
            self.elbpRaw = rawVal
            self.elbp = histo

    def _compute_var(self, audio, extract):
        melShape = self.melspectrogram.shape
        radius = 1
        neighbors = 8
        rows = int(melShape[0])
        cols = int(melShape[1])
        self.varlbpRaw = []  # Raw value of the LBP
        self.varlbp = []  # Histogram of VARLBP
        rawVal = np.zeros((rows, cols))  # VARLBP raw value
        _mean = np.zeros(melShape)
        _delta = np.zeros(melShape)
        _m2 = np.zeros(melShape)
        for n in range(neighbors):
            # sample points
            x = radius * math.cos(2.0 * math.pi * n / neighbors)
            y = -radius * math.sin(2.0 * math.pi * n / neighbors)
            # relative indices
            fx = int(np.floor(x))
            fy = int(np.floor(y))
            cx = int(np.ceil(x))
            cy = int(np.ceil(y))
            # fractional part
            ty = y - fy
            tx = x - fx
            # set interpolation weights
            w1 = (1 - tx) * (1 - ty)
            w2 = tx * (1 - ty)
            w3 = (1 - tx) * ty
            w4 = tx * ty
            # iterate through your data
            for i in range(radius, rows - radius):
                for j in range(radius, cols - radius):
                    t1 = (
                        w1 * self.melspectrogram[i + fy][j + fx]
                        + w2 * self.melspectrogram[i + fy][j + cx]
                    )
                    t2 = (
                        w3 * self.melspectrogram[i + cy][j + fx]
                        + w4 * self.melspectrogram[i + cy][j + cx]
                    )
                    t = t1 + t2
                    _delta[i][j] = t - _mean[i][j]
                    _mean[i][j] = _mean[i][j] + (_delta[i][j] / (1.0 * (n + 1)))
                    _m2[i][j] = _m2[i][j] + _delta[i][j] * (t - _mean[i][j])
        # calculate result
        for i in range(radius, rows - radius):
            for j in range(radius, cols - radius):
                rawVal[i - radius][j - radius] = _m2[i][j] / (1.0 * (neighbors - 1))
        rawVal, histo = Dataset._limit_and_histo(rawVal)
        if extract == 0:
            self.varRaw = rawVal
        elif extract == 1:
            self.var = histo
        else:
            self.varRaw = rawVal
            self.var = histo

    def _compute_ste(self, spectre):
        # Short Time Energy
        self.ste = librosa.feature.rms(S=spectre)
        self.ste = self.ste.ravel()

    def _compute_zcr(self, audio):
        # Zero-crossing rate
        self.zcr = []
        frames = int(
            np.ceil((len(audio.data) / 1000.0 * Dataset.RATE) / Dataset.HOP_LENGTH)
        )

        for i in range(0, frames):
            frame = Dataset._get_frame(audio, i)
            self.zcr.append(np.mean(0.5 * np.abs(np.diff(np.sign(frame)))))
        self.zcr = np.asarray(self.zcr)

    @classmethod
    def _get_frame(cls, audio, index):
        if index < 0:
            return None
        return audio.raw[
            (index * Dataset.HOP_LENGTH) : (index * Dataset.HOP_LENGTH + Dataset.FRAME)
        ]

    @classmethod
    def _sign_LPQ(cls, re, im):
        ret = 0
        if re > 0:
            ret = ret + 1
        if im > 0:
            ret = ret + 2
        return ret

    @classmethod
    def _sign_LBP(cls, x):
        ret = 0
        if x > 0:
            ret = ret + 1
        return ret

    @classmethod
    def _funcgauss1D(cls, x, var):
        return math.exp(-(x * x) / (2 * var))

    @classmethod
    def _limit_and_histo(cls, img):
        imgShape = np.shape(img)
        rows = imgShape[0]
        cols = imgShape[1]
        histo = np.zeros((rows, 256))
        for i in range(rows):
            for j in range(cols):
                if img[i][j] < 0:
                    img[i][j] = 0
                elif img[i][j] > 255:
                    img[i][j] = 255
                histo[i][int(img[i][j])] += 1
        return img, histo

    def process(self):
        # todo : Multiprocess the "_processAudio" function
        # * Multiprocessing
        pass


if __name__ == "__main__":
    configFilePath = r"./src/esc/configfile.ini"
    dataset = Dataset(configFilePath)
    dataset._processAudio(0, 0)
    print(dataset.cases)
