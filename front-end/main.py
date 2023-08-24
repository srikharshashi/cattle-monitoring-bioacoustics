import sounddevice as sd
from scipy.io.wavfile import write
import time
import requests
import sys

if(len(sys.argv)!=3):
  print("Usage python main.py cattle_type id")
  sys.exit(1)

breed=sys.argv[1]
id=sys.argv[2]

print(breed,id)

url=  f"http://172.16.53.161:3000/upload-wave/{id}/{breed}"
  

file_paths = {
  "cow" : {
    "HFC" : rf"TestData\4.HFC_11_30.wav"
  },
  "hen" : {
    "HEALTHY" : rf"TestData\6.wav",
    "UNHEALTHY" : rf"TestData\4.wav",
    "DISTRESS" : rf"TestData\7.wav"
  }
}

headers = {
  'X-API-Key': 'DEFAULT_KEY',
}

state_models =  {
    "cow" : "fcClassifier",
    "hen" : "chickenClassifier"
}

DangerSet = ["HFC" , "UNHEALTHY" , "DISTRESS"]

    
def upload_file(filename):
    with open(filename, 'rb') as f:
        files = {'file': (filename, f)}
        response = requests.post(url, files=files , headers=headers)
        return response.text

class DeciveController:
    def __init__(self , cattle_type , cattleID) -> None:
        if cattle_type not in state_models:
            return None
        self.duration = 5
        self.sample_rate = 44100
        self.output_dir = "./FILES/audio"
        
      
    def Run(self):
        i = 0
        while True:
            print("Recording...")
            recording = sd.rec(int(self.duration * self.sample_rate), samplerate=self.sample_rate, channels=2)
            sd.wait()  
            write(f'{self.output_dir}/output{i}.wav', self.sample_rate, recording)
            print(f"Saved output{i}.wav")
            file_path = rf'{self.output_dir}/output{i}.wav'
            res=upload_file(file_path)
            print(res,end='\n')
            input("Enter to move : ")
    

runner = DeciveController(breed, id)
runner.Run()