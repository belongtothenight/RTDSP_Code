from configparser import ConfigParser
import numpy as np
import pandas as pd
import sklearn as sk
import sklearn.ensemble
import pickle
import time

# * Load config settings
configFilePath = r"./src/esc/configfile.ini"
config = ConfigParser()
config.read(configFilePath)

# * Load dataset
df = pd.read_csv(config["experiment"]["dataframe"])
df["fold"] = df["filename"].apply(lambda x: int(x.split("-")[0]))


# * Train model
def to_percentage(number):
    return int(number * 1000) / 10.0


def classify(
    cases,
    classifier="knn",
    features_start="MFCC_0 mean",
    features_end="CHROMA_127 std dev",
    foldNb=5,
    debug=False,
):
    results = []
    class_count = len(cases["category"].unique())
    confusion = np.zeros((class_count, class_count), dtype=int)
    trainT = []
    testT = []
    singleT = []

    for fold in range(1, foldNb + 1):
        train = cases[cases["fold"] != fold].copy()
        test = cases[cases["fold"] == fold].copy()
        classifier_name = ""
        train_X = train.loc[:, features_start:features_end]
        test_X = test.loc[:, features_start:features_end]

        if classifier == "knn":
            classifier_name = "k-NN"
            knn = sk.neighbors.KNeighborsClassifier(n_neighbors=8)
            t1 = time.time()
            knn.fit(train_X, train["category"])
            t2 = time.time()
            test.loc[:, "prediction"] = knn.predict(test_X)
            t3 = time.time()
            single_knn = knn.predict(test_X.head(1))
            t4 = time.time()

        if classifier == "rf":
            classifier_name = "Random Forest"
            rf = sk.ensemble.RandomForestClassifier(
                n_estimators=500, random_state=20150420
            )
            t1 = time.time()
            rf.fit(train_X, train["category"])
            t2 = time.time()
            test.loc[:, "prediction"] = rf.predict(test_X)
            t3 = time.time()
            single_rf = rf.predict(test_X.head(1))
            t4 = time.time()

        if classifier == "svm":
            classifier_name = "Support Vector Machine (SVM)"
            svm = sk.svm.SVC(C=0.1, kernel="linear", random_state=20150420)
            t1 = time.time()
            svm.fit(train_X, train["category"])
            t2 = time.time()
            test.loc[:, "prediction"] = svm.predict(test_X)
            t3 = time.time()
            single_svm = svm.predict(test_X.head(1))
            t4 = time.time()

        accuracy = np.sum(test["category"] == test["prediction"]) / float(
            len(test["category"])
        )
        results.append(accuracy)
        confusion_current = sk.metrics.confusion_matrix(
            test["category"], test["prediction"]
        )
        confusion = confusion + confusion_current

        print(
            "Classifying fold {0} with {1} classifier. Accuracy: {2}%".format(
                fold, classifier_name, to_percentage(accuracy)
            )
        )
        if classifier == "knn":
            k = pickle.dumps(knn)
            path = (
                config["path"]["model"]
                + "knn_"
                + str(fold)
                + "_"
                + str(to_percentage(np.mean(results)))
                + ".pkl"
            )
            with open(path, "wb") as f:
                f.write(k)
        if classifier == "rf":
            r = pickle.dumps(rf)
            path = (
                config["path"]["model"]
                + "rf_"
                + str(fold)
                + "_"
                + str(to_percentage(np.mean(results)))
                + ".pkl"
            )
            with open(path, "wb") as f:
                f.write(r)
        if classifier == "svm":
            s = pickle.dumps(svm)
            path = (
                config["path"]["model"]
                + "svm_"
                + str(fold)
                + "_"
                + str(to_percentage(np.mean(results)))
                + ".pkl"
            )
            with open(path, "wb") as f:
                f.write(s)
        if debug:
            print("Confusion matrix:\n", confusion_current, "\n")

        trainT.append(t2 - t1)
        testT.append(t3 - t2)
        singleT.append(t4 - t3)

    trainT.append(np.mean(trainT))
    testT.append(np.mean(testT))
    singleT.append(np.mean(singleT))

    Tdf = pd.DataFrame({"train": trainT, "test": testT, "single": singleT})
    Tdf.index = list(np.arange(1, foldNb + 1)) + ["mean"]
    print(Tdf)
    Tdf.to_csv(config["path"]["data"] + "time_" + classifier + ".csv")

    print("Average accuracy: {0}%\n".format(to_percentage(np.mean(results))))
    return confusion, results


confusion, accuracy = classify(df, classifier="rf")
