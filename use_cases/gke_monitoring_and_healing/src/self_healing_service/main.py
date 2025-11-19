import os
import json
import base64
from flask import Flask, request

app = Flask(__name__)

@app.route("/", methods=["POST"])
def handle_alert():
    """Receives and processes Pub/Sub messages from Cloud Monitoring."""
    envelope = request.get_json()
    if not envelope:
        print("No Pub/Sub message received")
        return ("No Pub/Sub message received", 400)

    if not isinstance(envelope, dict) or "message" not in envelope:
        print("Invalid Pub/Sub message format")
        return ("Invalid Pub/Sub message format", 400)

    pubsub_message = envelope["message"]
    data = base64.b64decode(pubsub_message["data"]).decode("utf-8")
    notification = json.loads(data)

    print(f"Received notification: {notification}")

    # In a real scenario, you would parse the incident to get the affected pod
    # and trigger a healing action. For now, we just log a message.
    print("Healing action would be triggered for the affected pod.")

    return ("", 204)

if __name__ == "__main__":
    PORT = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=PORT)
