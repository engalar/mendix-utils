# 01OfflineInstallStudioPro

离线安装包下载

- 运行

```cmd
01OfflineInstallStudioPro\runme.bat
```

![Alt text](img/offline.png)

- 选择要下载的版本（如想下载 9.9.3.49292 则输入 784 后按回车即可开始下载）

# 02BLOBSTORE

把在线的文件下载到本地做成镜像服务器

- 下载 listing.txt 文件中的文件（如果不想下载所有，你可以只保留需要的文件名）

```cmd
02BLOBSTORE\download.bat
```

- 启动 web 服务器

```cmd
02BLOBSTORE\serve.bat
```

- 设置环境变量 为 `http://{your ip}:8000/mendix/` 例如 `http://192.168.2.23:8000/mendix/`
参考文档[https://github.com/mendix/cf-mendix-buildpack#using-the-buildpack-without-an-internet-connection](https://github.com/mendix/cf-mendix-buildpack#using-the-buildpack-without-an-internet-connection)