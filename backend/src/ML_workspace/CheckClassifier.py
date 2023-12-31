from enum import Enum
from keras.models import load_model 
import librosa
import librosa.display
import numpy as np
from PIL import Image

class Predictions(Enum):
    HEALTHY = "HEALTHY"
    UNHEALTHY = "UNHEALTHY"
    DISTRESS = "DISTRESS"

class ChickenClassifier(object):
    Model = load_model(rf"src\ML_workspace\models\chicken_model.h5")
    def __init__(self, FileID: str) -> None:
        self.File = FileID
        self.PATH = rf"./FILES/audio/{self.File}"

    def Predict(self):
        try:
            prediction = ChickenClassifier.predict(self.PATH)
            return {
                "predictions": prediction
            }
        except Exception as e:
            print('Exception:', e , e.__traceback__.tb_lineno)
            return {"error" : e}

    
    def scale_melspec(mel_spec):
        target_size = (224, 224)  # Target size for mel spectrograms
        scaled_mel_spec = librosa.util.normalize(mel_spec)  # Normalize mel spectrogram
        scaled_mel_spec = (scaled_mel_spec * 255).astype(np.uint8)  # Convert to uint8
        scaled_mel_spec = Image.fromarray(scaled_mel_spec)  # Convert to PIL image
        scaled_mel_spec = scaled_mel_spec.resize(target_size, Image.Resampling.LANCZOS)  # Resize
        scaled_mel_spec = np.array(scaled_mel_spec)
        print(scaled_mel_spec.shape)
        return scaled_mel_spec
    
    def predict(WAV):
        scale,sr=librosa.load(WAV)
        mel_spec=librosa.feature.melspectrogram(y=scale,sr=sr,n_fft=2048,hop_length=512,n_mels=128)
        mel_spec=ChickenClassifier.scale_melspec(mel_spec)
        #print(mel_spec.shape)
        log_mel_spectrogram=librosa.power_to_db(mel_spec)
        log_mel_spectrogram=np.repeat(log_mel_spectrogram[...,np.newaxis],3,axis=-1)
        log_mel_spectrogram = np.expand_dims(log_mel_spectrogram, axis=0)
        #print(log_mel_spectrogram.shape)

        prediction=ChickenClassifier.Model.predict(log_mel_spectrogram)
        print(prediction , sum(abs(scale)) , "CHICKEN JI")
        classes={
            0:Predictions.HEALTHY,
            1:Predictions.UNHEALTHY,
            2:Predictions.DISTRESS
        }
        pred=classes[np.argmax(prediction)]
        return pred
    def __repr__(self) -> str:
        return "True"
