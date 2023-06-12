class Config:
    def __init__(self) -> None:
        # * [experiment]
        # ! Options in [path] section
        self.dataset = "ESC-10"
        # ! Export dataframe location
        self.dataframe = "./src/esc/dataframe/ESC-10.csv"
        self.max_process = 6

        # * [multiDataset]
        self.level1 = True
        self.level2 = True
        self.level3 = False
        self.level4 = False
        self.level5 = False

        # * [feature]
        self.MFCC = True
        self.LBP = True
        self.LBP1D = True
        self.LPQ1D = True
        self.ELBP = True
        self.VAR = True
        self.STE = True
        self.ZCR = True
        self.GFCC = True
        self.CQT = True
        self.CHROMA = True

        # * [semgentation]
        self.RATE = 44100
        self.CHANNELS = 1
        self.FRAME = 2048
        self.HOP = 1024
        self.LBP_DIGITS = 4
        self.duration = 5000

        # ! ================================
        # ! Do not alter the following lines

        # * [path]
        self.ESC_10 = "./src/esc/dataset/ESC-10/"
        self.ESC_50 = "./src/esc/dataset/ESC-50/"
        self.level1 = "./src/esc/dataset/level1/"
        self.level2 = "./src/esc/dataset/level2/"
        self.level3 = "./src/esc/dataset/level3/"
        self.level4 = "./src/esc/dataset/level4/"
        self.level5 = "./src/esc/dataset/level5/"
        self.all = "./src/esc/dataset/"
        self.compressed = "./src/esc/dataset/compressed/"
        if self.dataset == "ESC-10":
            self.dataset = self.ESC_10
        elif self.dataset == "ESC-50":
            self.dataset = self.ESC_50
        elif self.dataset == "level1":
            self.dataset = self.level1
        elif self.dataset == "level2":
            self.dataset = self.level2
        elif self.dataset == "level3":
            self.dataset = self.level3
        elif self.dataset == "level4":
            self.dataset = self.level4
        elif self.dataset == "level5":
            self.dataset = self.level5
        elif self.dataset == "all":
            self.dataset = self.all
        else:
            raise ValueError("Dataset not found")

        # * [format]
        self.compressed_tar = ".tar.gz"
