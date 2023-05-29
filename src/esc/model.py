from configparser import ConfigParser
import numpy as np
import pandas as pd
import sklearn as sk
import sklearn.ensemble

# * Load config settings
configFilePath = r"./src/esc/configfile.ini"
config = ConfigParser()
config.read(configFilePath)

# * Load dataset
df = pd.read_csv(config["experiment"]["dataframe"])


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

    for fold in range(1, foldNb + 1):
        train = cases[cases["fold"] != fold].copy()
        test = cases[cases["fold"] == fold].copy()
        classifier_name = ""
        train_X = train.loc[:, features_start:features_end]
        test_X = test.loc[:, features_start:features_end]

        if classifier == "knn":
            classifier_name = "k-NN"
            knn = sk.neighbors.KNeighborsClassifier(n_neighbors=8)
            knn.fit(train_X, train["category"])
            test.loc[:, "prediction"] = knn.predict(test_X)

        if classifier == "rf":
            classifier_name = "Random Forest"
            rf = sk.ensemble.RandomForestClassifier(
                n_estimators=500, random_state=20150420
            )
            rf.fit(train_X, train["category"])
            test.loc[:, "prediction"] = rf.predict(test_X)

        if classifier == "svm":
            classifier_name = "Support Vector Machine (SVM)"
            svm = sk.svm.SVC(C=0.1, kernel="linear", random_state=20150420)
            svm.fit(train_X, train["category"])
            test.loc[:, "prediction"] = svm.predict(test_X)

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
        if debug:
            print("Confusion matrix:\n", confusion_current, "\n")

    print("Average accuracy: {0}%\n".format(to_percentage(np.mean(results))))
    return confusion, results


confusion, accuracy = classify(df, classifier="rf")
