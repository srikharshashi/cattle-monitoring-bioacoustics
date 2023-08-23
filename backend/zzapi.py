# workspace testing
import requests

urls = {
  "cow" : "http://127.0.0.1:3000/upload-wave/GDYRjPzwQmX4cxzrMPjk/cow",
  "hen" : "http://127.0.0.1:3000/upload-wave/Unq00NbzDk2Ip0IzzP17/hen"
}

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

# Open the file in binary mode and read its contents
# with open(file_path, 'rb') as file:
#     files = {'file': (file_name, file)}

#     # Send the request with the file
#     response = requests.post(url, files=files , headers=headers)

# print(response.text)

def upload_file(filename):
    with open(filename, 'rb') as f:
        files = {'file': (filename, f)}
        response = requests.post(urls['hen'], files=files , headers=headers)
        return response.text
      
if __name__ == '__main__':
    # filename = 'path/to/your/file.txt'  # Replace with the path to the file you want to upload
    result = upload_file(file_paths["hen"]["HEALTHY"])
    print(result)
    result = upload_file(file_paths["hen"]["UNHEALTHY"])
    print(result)
    result = upload_file(file_paths["hen"]["DISTRESS"])
    print(result)
