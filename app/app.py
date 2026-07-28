from flask import Flask, jsonify
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from flask import Response
import socket

app = Flask(__name__)

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP Requests"
)

@app.route("/")
def home():
    REQUEST_COUNT.inc()

    return jsonify({
        "application": "hello-world",
        "status": "running",
        "hostname": socket.gethostname()
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy"
    }), 200


@app.route("/metrics")
def metrics():
    return Response(generate_latest(),
                    mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
