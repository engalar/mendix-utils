import yaml
import os
import requests
import shutil


required_version = 'latest'


current_path = os.path.dirname(os.path.abspath(__file__))
dependencies_path = os.path.join(current_path, 'Dependencies.yml')

# 读取清单文件
with open(dependencies_path, 'r') as file:
    resource_list = yaml.safe_load(file)


def isMatch(version_range, version):
    """
    判断给定的版本是否匹配版本范围。

    :param version_range: 版本范围字符串，例如 '10.0.0-latest'
    :param version: 具体版本字符串，例如 '10.3.1' 或 'latest'
    :return: 如果版本匹配版本范围，返回 True；否则返回 False
    """

    range_start, range_end = version_range.split('-')

    def version_to_tuple(version_str):
        if version_str == 'latest':
            return (9999, 9999, 9999)
        return tuple(map(int, version_str.split('.')))

    version_tuple = version_to_tuple(version)
    range_start_tuple = version_to_tuple(range_start)

    if range_end == 'latest':
        return version_tuple >= range_start_tuple

    range_end_tuple = version_to_tuple(range_end)

    return range_start_tuple <= version_tuple <= range_end_tuple


for category in resource_list:
    for version_range, items in resource_list[category].items():
        if isMatch(version_range, required_version):
            # items one is url, another is rename
            url, rename = items
            print(f"----------------------------------------")
            print(f"Category: {category}")
            print(f"Version: {version_range}")
            print(f"Download URL: {url}")
            print(f"Save as: {rename}")
            print()


def download(url, savePath):
    """
    下载文件。

    :param url: 下载地址
    :param savePath: 保存路径
    """

    response = requests.get(url, stream=True)
    with open(savePath, 'wb') as file:
        shutil.copyfileobj(response.raw, file)
    del response
