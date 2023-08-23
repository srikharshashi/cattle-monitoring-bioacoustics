from firebase_admin import messaging
from datetime import datetime
from functools import wraps
from firebase_admin import firestore
from config import db
import config
from flask import jsonify, make_response, request
import jwt , requests , json
from google.cloud import storage
import os
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./cattle-plus-firebase-adminsdk-zmtjr-dfc09a1c28.json"



#static values
DangerSet = ["HFC" , "UNHEALTHY" , "DISTRESS"]
sms_url = "https://sms.api.sinch.com/xms/v1/b6698e25c4a94e72b715359b673d0e70/batches"
# Decorators
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):

        token = None

        # jwt is passed in the request header
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        if not token:
            return make_response(jsonify({'message': 'Token is missing !!'}), 400)

        # jwt validation
        try:
            try:
                data = jwt.decode(
                    token, config.SECRET_KEY, algorithms=["HS256"])
            except Exception as e:
                return make_response(jsonify({
                    'message': 'Token invalid or tampered!! Access denied'
                }), 401)
            current_user = db.users.find_one({"_id": data["public_id"]})
            if not current_user:
                return make_response(jsonify({
                    'message': 'unable to find user '
                }), 404)
        except Exception as e:
            print(e,  e.__traceback__.tb_lineno)
            return make_response(jsonify({
                'message': 'unable to find user or token tampered!'
            }), 400)

        # returns the current logged in users context to the routes
        return f(current_user, *args, **kwargs)
    return decorated


#send pus notifications to user
def updateCattle(cattleId : str , predictionOut , filePath : str ):
    try:
        cattle_ref = db.collection('catteles').document(cattleId)
        cattle = cattle_ref.get()
  
        if cattle.exists:
            # Create a new history object
            cattle_ref.update({
            "history": firestore.ArrayUnion([{
                "createdAt": datetime.utcnow(),
                "predictionType": predictionOut.value
                }])
            })
            cattle_data = cattle_ref.get().to_dict()
            user_id = cattle_data["userId"]
            user_ref = db.collection("Users").document(user_id)
            user_data = user_ref.get().to_dict()
            device_token = user_data["deviceToken"]
            phno = user_data["phoneno"]
            cattleName = cattle_data["name"]
            
            # send_push_notification(device_token, "")
            print(str(predictionOut.value) , "Cureent prediction")
            if str(predictionOut.value) in DangerSet:
                print("Sending Notification to user .....")
                send_push_notification(device_token, f"{cattleName} is detected with some abnormalities")
                sendSms(phno , f"{cattleName} is detected with some abnormalities")
                StoreAudio(filePath)
            return {
                "cattleID" : cattleId
            }
        else:
            return {
                "error" : "Cattle not found"
            }
    except Exception as e:
        print(e,  e.__traceback__.tb_lineno)
        return {
            "error" : e
        }
        

def StoreAudio(filePath : str):
    absolute_path = "./FILES/audio/" + filePath
    client = storage.Client()
    bucket = client.bucket("cattle-plus.appspot.com")
    blob = bucket.blob(absolute_path[14:])
    blob.upload_from_filename(absolute_path)
    url = blob.public_url
    print("here is your url" , url)
    print(f"Success File uploaded to Firebase Storage: {absolute_path[14:]}")
    return 

def sendSms( phno ,  context):
    headers = {
        "Authorization": "Bearer 594230db5bd9489d8db3016f668edd56",
        "Content-Type": "application/json"
    }
    data = {
        "from": "447520650735",
        "to": [phno],
        "body": context
    }
    try:
        response = requests.post(sms_url ,  headers=headers, data=json.dumps(data))
        print("suucessfuly send SNS")
        return {
            "response" : response
        }
    except Exception as e:
        print("Encounterred error while sending sms" , e)
        return {
            "error" : str(e)
        }

def send_push_notification(device_token, message):
    # Create a message
    notification = messaging.Notification(
        title="ISSUE DETECTED ⚡",
        body=message
    )
    message = messaging.Message(
        notification=notification,
        token=device_token
    )

    # Send the message
    response = messaging.send(message)
    print("Push notification sent successfully:", response)




