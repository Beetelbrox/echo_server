from flask import Flask
from flask import request

app = Flask(__name__)

@app.route("/", methods=["post"])
def echo():
    return f"message: {request.data}"

@app.route('/health', methods=['GET'])
def health():
    return "Healthy: OK"