from enum import Enum
from ML_workspace import fcClassifier , ChickenClassifier

classifiers = {
    "fcClassifier": fcClassifier,
    "chickenClassifier" : ChickenClassifier
}

class Model(object):
    def __init__(self, fileId : str , classifierModel = "fcClassifier") -> None:
        self.fileId = fileId
        _model = classifiers[classifierModel]
        self.model = _model(self.fileId)
    
    def predict(self):
        resp = self.model.Predict()
        return resp

    def __repr__(self) -> str:
        return "ALL SET"