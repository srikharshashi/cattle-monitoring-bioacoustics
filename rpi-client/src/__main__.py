import sounddevice as sd
from scipy.io.wavfile import write
import time
from ML_workspace import Model
import config
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests , json

state_models =  {
    "cow" : "fcClassifier",
    "hen" : "chickenClassifier"
}
DangerSet = ["HFC" , "UNHEALTHY" , "DISTRESS"]

try:
    cred = credentials.Certificate(config.CERTIFICATE_PATH)
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    config.db = db

    # print(config.db)
    print(' >>> Established connection to Firebase')
except Exception as ex:
    print('Can not connect to DB=>'+str(ex))
    

class DeciveController:
    def __init__(self , cattle_type , cattleID) -> None:
        if cattle_type not in state_models:
            return None
        self.duration = 2
        self.sample_rate = 44100
        self.output_dir = "./FILES/audio"
        self.cattle_type  = cattle_type
        self.cattle_id = cattleID
        
        cattle_ref = db.collection('catteles').document(cattleID)
        cattle_data = cattle_ref.get().to_dict()
        user_id = cattle_data["userId"]
        self.name = cattle_data["name"]
        user_ref = db.collection("Users").document(user_id)
        user_data = user_ref.get().to_dict()
        
        self.ph_no = user_data["phoneno"]
        print(self.ph_no)
        self.sms_url = "https://sms.api.sinch.com/xms/v1/b6698e25c4a94e72b715359b673d0e70/batches"
        
    def Run(self):
        i = 0
        while True:
            print("Recording...")
            recording = sd.rec(int(self.duration * self.sample_rate), samplerate=self.sample_rate, channels=2)
            sd.wait()  
            write(f'{self.output_dir}/output{i}.wav', self.sample_rate, recording)
            print(f"Saved output{i}.wav")
            file_path = f'{self.output_dir}/output{i}.wav'
            model = Model(fileId=f"output{i}.wav" , classifierModel=state_models[self.cattle_type])
            
            predictions = model.predict()
            if "error" in predictions:
                print("Error" , predictions["error"])
                continue
            predOut = predictions["predictions"]
            print(predOut)
            if str(predOut.value) in DangerSet:
                resp = self.sendSms(f"Danger for cattle {self.name} recorded as {predOut.value}")
                if "error" in resp:
                    print("Error" , resp["error"])
                    continue 
            i += 1
            time.sleep(120)  
    
    def sendSms(self , context):
        headers = {
            "Authorization": "Bearer 594230db5bd9489d8db3016f668edd56",
            "Content-Type": "application/json"
        }
        data = {
            "from": "447520650735",
            "to": [self.ph_no],
            "body": context
        }
        try:
            response = requests.post(self.sms_url, headers=headers, data=json.dumps(data))
            return {
                "response" : response
            }
        except Exception as e:
            return {
                "error" : str(e)
            }

runner = DeciveController(cattle_type="cow" , cattleID="GDYRjPzwQmX4cxzrMPjk")
runner.Run()