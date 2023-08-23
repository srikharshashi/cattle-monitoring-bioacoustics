""""
Handles reports/cases uploaded by citizens

"""
# from Logic_objects import file_server
from flask import Blueprint, request, make_response, jsonify

# from routes.users import token_required
from routes import API_required 
from Logic_objects import FileServer


file = Blueprint('file', __name__)


@file.route("/upload-wave/<cattle_id>/<cattle_type>",  methods=['POST'])
@API_required
def new_report(cattle_id , cattle_type):
    try:
        
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
        
        # TODO: HAD TO IMPLEMENT MODEL PREDICTION
        make_response(jsonify(uploaded="success", file_id=savedFile["file"]), 200)

    except Exception as e:
        print(e,  e.__traceback__.tb_lineno)
        return make_response(jsonify(uploaded="fail", file_id=None, error=e), 403)


