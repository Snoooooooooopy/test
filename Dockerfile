# 使用官方 devcontainer python 基础镜像（Debian/Ubuntu 系列）
FROM mcr.microsoft.com/vscode/devcontainers/python:3.10

# 使用清华 PyPI 镜像作为全局来源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 安装系统依赖（注意：不使用已废弃的 libgl1-mesa-glx）
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libsndfile1 \
    ffmpeg \
    libgl1 \
    libglx-mesa0 \
    libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

# 安装 CPU 版本 PyTorch（使用 PyTorch 官方 CPU wheel 源）
RUN pip install torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 \
    --extra-index-url https://download.pytorch.org/whl/cpu

# 安装 Python 依赖（不包含 flash-attn）
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# 创建工作目录
WORKDIR /workspace

# 默认命令（进入容器后可用 python app.py 启动服务）
CMD ["/bin/bash"]
