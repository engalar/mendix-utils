# 01OfflineInstallStudioPro

离线安装包下载

- 运行

```cmd
01OfflineInstallStudioPro\runme.bat
```

![Alt text](img/offline.png)

- 选择要下载的版本（如想下载 9.9.3.49292 则输入 784 后按回车即可开始下载）

# 02BLOBSTORE

## 动机

由于国内网络的原因，在构建过程中会需要下载外网的https://cdn.mendix.com/和https://github.com/上的文件，经常网络不稳定，所以我们需要在本地建立一个镜像站点。

## 步骤

- 启动 web 服务器

```cmd
02BLOBSTORE\serve.bat
```

[参考文档 1 BLOBSTORE](https://github.com/mendix/cf-mendix-buildpack#using-the-buildpack-without-an-internet-connection)

[参考文档 2 CF_BUILDPACK_URL](https://github.com/mendix/docker-mendix-buildpack/blob/cfd29123e7579aaec96f163deafc8304e4b649e6/Dockerfile#L16)

- docker-mendix-buildpack\scripts\compilation 换行符改为 linux 换行标准
- docker-mendix-buildpack\scripts\startup 换行符改为 linux 换行标准
- 配置 docker build

```cmd
docker build --build-arg CF_BUILDPACK_URL=http://host.docker.internal:5000/github/mendix/cf-mendix-buildpack/releases/download/v4.30.14/cf-mendix-buildpack.zip --build-arg BLOBSTORE=http://host.docker.internal:5000/mendix/ --build-arg BUILD_PATH=DiscountAutomation-main -t discount .
```

- 在有合适的网络环境下构建一次，就会下载所有依赖于本地，之后就可以离线构建了。仅当项目的 mendix 版本发生变化时，才需要重复上述步骤。
