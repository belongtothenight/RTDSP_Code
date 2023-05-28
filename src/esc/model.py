from configparser import ConfigParser
import os
import numpy

# * Load config settings
configFilePath = r"./src/esc/configfile.ini"
config = ConfigParser()
config.read(configFilePath)


print(config["path"]["dataset"])

# * Load dataset

# * Train model
