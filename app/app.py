from flask import Flask
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time

app = Flask(__name__)

# Metrics
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP Requests",
    ["method", "endpoint", "status"]
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP Request Latency"
)

@app.route("/")
@REQUEST_LATENCY.time()
def home():
    REQUEST_COUNT.labels("GET", "/", "200").inc()
    return "Hello World!"

@app.route("/health")
def health():
    return "OK"

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {
        "Content-Type": CONTENT_TYPE_LATEST
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
