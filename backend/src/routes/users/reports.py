""""
Handles reports/cases uploaded by citizens

"""
# from Logic_objects import file_server
from flask import Blueprint, request, make_response, jsonify

# from routes.users import token_required
from routes import API_required 
from routes.users import updateCattle
from Logic_objects import FileServer
from ML_workspace import Model

state_models =  {
    "cow" : "fcClassifier",
    "hen" : "chickenClassifier"
}


file = Blueprint('file', __name__)


@file.route("/upload-wave/<cattle_id>/<cattle_type>",  methods=['POST'])
@API_required
def new_report(cattle_id , cattle_type):
    try:
        if cattle_type not in state_models:
            return make_response(jsonify(uploaded="fail", file_id=None, error="Invalid cattle type"), 400)
        # file = request.files['file']
        
        if 'file' not in request.files:
            return make_response(jsonify(uploaded="fail", file_id=None, error="No file uploaded"), 400)
        
        file = request.files['file']
        # Check if the file has a valid WAV extension
        if file.filename == '' or not file.filename.endswith('.wav'):
            return make_response(jsonify(uploaded="fail", file_id=None, error="Invalid file"), 400)
        
        mutFile = FileServer("audio")
        savedFile = mutFile.save_file(file)
        if "error" in savedFile:
            return make_response(jsonify(uploaded="fail", file_id=None, error=str(savedFile["error"])), 403)
        model = Model(fileId=savedFile["file"] , classifierModel=state_models[cattle_type])
        
        predictions = model.predict()
        if "error" in predictions:
            return make_response(jsonify(uploaded="fail", file_id=None, error=predictions["error"]), 403)
        
        update_cattle = updateCattle(cattle_id, predictions["predictions"] , filePath=savedFile["file"])
        if "error" in update_cattle:
            return make_response(jsonify(uploaded="fail", file_id=None, error=str(update_cattle["error"])), 403)
        # return make_response(jsonify(test=update_cattle), 200)
        return make_response(jsonify(uploaded="success", file_id=str(savedFile["file"]) , external_url=update_cattle["url"] , cattleId=cattle_id , predictions=str(predictions["predictions"])), 200)
        

    except Exception as e:
        print(e,  e.__traceback__.tb_lineno)
        return make_response(jsonify(uploaded="fail", file_id=None, error=e), 403)


