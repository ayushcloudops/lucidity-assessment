from flask import Flask, jsonify
import socket

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello World", 200

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "application": "hello-world",
        "hostname": socket.gethostname()
    }), 200
