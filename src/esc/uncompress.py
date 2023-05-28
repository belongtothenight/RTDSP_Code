import os
import tarfile
from configparser import ConfigParser


def tar_extract(file_path):
    # read compressed tar file and extract to folder
    with tarfile.open(file_path, "r:gz") as _tar:
        for member in _tar:
            if member.isdir():
                continue
            fname = os.path.join(config["path"]["all"], member.name)
            os.makedirs(os.path.dirname(fname), exist_ok=True)
            _tar.makefile(member, fname)


def get_file_list(path):
    file_list = []
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith(config["format"]["compressed_tar"]):
                file_list.append(os.path.join(root, file))
    return file_list


if __name__ == "__main__":
    configFilePath = r"./src/esc/configfile.ini"
    config = ConfigParser()
    config.read(configFilePath)
    file_list = get_file_list(config["path"]["compressed"])
    for i, val in enumerate(file_list):
        tar_extract(val)
        print(f"Progress: {i+1}/{len(file_list)}: {val}   ", end="\r")
