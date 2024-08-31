import os
import requests
from flask import Flask, send_file, request, abort

app = Flask(__name__)

# http://127.0.0.1:5000/github/mendix/cf-mendix-buildpack/releases/download/v4.30.17/cf-mendix-buildpack.zip
# https://github.com/mendix/cf-mendix-buildpack/releases/download/v4.30.17/cf-mendix-buildpack.zip

# http://127.0.0.1:5000/mendix/mx-buildpack/datadog/dd-java-agent-1.5.0.jar
# https://cdn.mendix.com/mx-buildpack/datadog/dd-java-agent-1.5.0.jar

file_path = os.path.abspath(__file__)
LOCAL_DIR = os.path.dirname(file_path)
UPSTREAM_SERVER_MENDIX = "https://cdn.mendix.com"
UPSTREAM_SERVER_GITHUB = "https://cdn.mendix.com"

UPSTREAM_SERVERS = {
    "github": "https://github.com",
    "mendix": "https://cdn.mendix.com"
}


@app.route('/<path:path>')
def serve_file(path):
    for prefix, upstream_server in UPSTREAM_SERVERS.items():
        if path.startswith(prefix):
            local_path = os.path.join(LOCAL_DIR, path)
            if os.path.exists(local_path):
                print("file exist", local_path)
                return send_file(local_path)
            upstream_url = upstream_server + path[len(prefix):]
            print("downloading from", upstream_url)
            upstream_response = requests.get(upstream_url, verify=False)
            if upstream_response.status_code == 200:
                os.makedirs(os.path.dirname(local_path), exist_ok=True)
                with open(local_path, 'wb') as f:
                    f.write(upstream_response.content)
                return send_file(local_path)
            else:
                abort(404)
    abort(404)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
