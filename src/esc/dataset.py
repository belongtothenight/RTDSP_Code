import sys
import numpy as np
import librosa
import math
import gammatone.gtgram as gtgram
import multiprocessing as mp
from configparser import ConfigParser


class Dataset:
    def __init__(self, configFilePath) -> None:
        # * Load config settings
        self.config = ConfigParser()
        self.config.read(configFilePath)
        # * Load Audio Dataset

    def _processAudio(self, audioFileIndex):
        # todo : Make this function to perform audio segmentation and feature extraction for a single audio file
        # * Audio Segmentation
        print(self.config["feature"]["MFCC"])
        # * Feature Extraction
        pass

    def process(self):
        # todo : Multiprocess the "_processAudio" function
        # * Multiprocessing
        pass


if __name__ == "__main__":
    configFilePath = r"./src/esc/configfile.ini"
    dataset = Dataset(configFilePath)
    dataset._processAudio(0)
