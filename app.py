from flask import Flask, jsonify
import time
import socket
import os
import redis  # Η νέα βιβλιοθήκη

app = Flask(__name__)

# Σύνδεση με Redis (Διαβάζει το host από Environment Variable ή παίρνει το 'localhost' για τοπικά)
redis_host = os.getenv('REDIS_HOST', 'localhost')
cache = redis.Redis(host=redis_host, port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route("/")
def home():
    count = get_hit_count() # Πάρε τον αριθμό επισκέψεων
    return jsonify({
        "message": "Hello from Real-World DevOps Project!",
        "hostname": socket.gethostname(),
        "visits": count  # Εμφάνισε τις επισκέψεις
    })

@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)