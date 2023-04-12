import os
import requests
from flask import Flask, send_file, request, abort

app = Flask(__name__)

# http://127.0.0.1:5000/github/mendix/cf-mendix-buildpack/releases/download/v4.30.17/cf-mendix-buildpack.zip
# https://github.com/mendix/cf-mendix-buildpack/releases/download/v4.30.17/cf-mendix-buildpack.zip

# http://127.0.0.1:5000/mendix/mx-buildpack/datadog/dd-java-agent-1.5.0.jar
# https://cdn.mendix.com/mx-buildpack/datadog/dd-java-agent-1.5.0.jar

# 配置本地文件目录
file_path = os.path.abspath(__file__)
LOCAL_DIR = os.path.dirname(file_path)
# 配置上游服务器
UPSTREAM_SERVER_MENDIX = "https://cdn.mendix.com"
UPSTREAM_SERVER_GITHUB = "https://cdn.mendix.com"

# 配置上游服务器
UPSTREAM_SERVERS = {
    "github": "https://github.com",
    "mendix": "https://cdn.mendix.com"
}


@app.route('/<path:path>')
def serve_file(path):
    # 根据路径前缀选择不同的上游服务器
    for prefix, upstream_server in UPSTREAM_SERVERS.items():
        if path.startswith(prefix):
            local_path = os.path.join(LOCAL_DIR, path)
            # 如果本地文件存在，则直接返回本地文件
            if os.path.exists(local_path):
                return send_file(local_path)
            # 否则从上游服务器下载文件
            upstream_url = upstream_server + path[len(prefix):]
            upstream_response = requests.get(upstream_url)
            if upstream_response.status_code == 200:
                # 保存文件到本地
                os.makedirs(os.path.dirname(local_path), exist_ok=True)
                with open(local_path, 'wb') as f:
                    f.write(upstream_response.content)
                # 返回文件给客户端
                return send_file(local_path)
            else:
                abort(404)
    # 如果路径不符合任何前缀，则返回 404
    abort(404)


if __name__ == '__main__':
    app.run()
