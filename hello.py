from flask import Flask
from flask import render_template, request
import pyAesCrypt
import ipfsapi
from flask_pymongo import PyMongo

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://localhost:27017/local"
mongo = PyMongo(app)

@app.route('/')
def mainFun():
	return render_template("login.html", msg="Health Care Applications using Blockchain");


@app.route('/upload', methods=['GET', 'POST'])
def uploadfileAndEncrypt():
	if request.method == 'GET':
		return render_template("uploadFile.html");

	elif request.method == 'POST':
		f = request.files['file'];
		f.save(f.filename);
		print("code completed")	
		encryptFile(f.filename, request.form['password']);
		hashVal = ipfsUpload(f.filename+".aes")
		return render_template("displayHash.html", hash=hashVal);

def encryptFile(fileName, password):
	bufferSize=64*1024;
	pyAesCrypt.encryptFile(fileName, fileName+".aes", password, bufferSize);
	print("file saved sucessfully")
	return

def ipfsUpload(fileName):
	localhost = '127.0.0.1'
	portNumber = 5001
	api = ipfsapi.connect(localhost, portNumber)
	res = api.add(fileName)
	print(res)
	return res['Hash']
