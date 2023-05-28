import os
import numpy as np
import librosa
import math
import gc
import logging
import gammatone.gtgram as gtgram
import multiprocessing as mp
from configparser import ConfigParser


class Dataset:
    def __init__(self, configFilePath) -> None:
        """
        self.categoryList = ['category']
        self.fileList = [['file1', 'file2'], ['file1', 'file2']]
        self.audioData = [[np.array, np.array], [np.array, np.array]]
        self.featureData = [[np.array, np.array], [np.array, np.array]]
        """
        # * Load config settings
        self.config = ConfigParser()
        self.config.read(configFilePath)
        logging.basicConfig(
            level=int(
                self.config["logging_option"][self.config["others"]["logging_level"]]
            )
        )
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
        # * Load Audio Data
        logging.info(f"Loading audio data.")
        self.audioData = np.empty(
            (len(self.categoryList), len(self.fileList[0])), dtype=object
        )
        for i, val in enumerate(self.categoryList):
            for j, val2 in enumerate(self.fileList[i]):
                print(val2)
                self.audioData[i][j] = librosa.load(val2)[0]
        logging.debug(f"Audio data shape: {self.audioData.shape}")

    def _processAudio(self, audioFileIndex):
        # todo : Make this function to perform audio segmentation and feature extraction for a single audio file
        # * Audio Segmentation
        # print(self.config["feature"]["MFCC"])
        # * Feature Extraction
        # * Save array to h5 file
        pass

    def process(self):
        # todo : Multiprocess the "_processAudio" function
        # * Multiprocessing
        pass


if __name__ == "__main__":
    configFilePath = r"./src/esc/configfile.ini"
    dataset = Dataset(configFilePath)
    dataset._processAudio(0)
