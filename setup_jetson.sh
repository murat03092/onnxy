#!/bin/bash

# Hata durumunda betiği durdur (opsiyonel ama güvenli)
set -e

echo "==========================================================="
echo "[1/6] Sistem paketleri ve temel bağımlılıklar güncelleniyor..."
echo "==========================================================="
sudo apt-get update
sudo apt-get install -y python3-pip libopenblas-dev libjpeg-dev zlib1g-dev libgl1-mesa-glx libglib2.0-0 libomp-dev

echo "==========================================================="
echo "[2/6] Pip paket yöneticisi güncelleniyor..."
echo "==========================================================="
python3 -m pip install --upgrade pip

echo "==========================================================="
echo "[3/6] Ultralytics (YOLO) ve OpenCV kuruluyor..."
echo "==========================================================="
pip3 install ultralytics opencv-python

echo "==========================================================="
echo "[4/6] NumPy uyuşmazlığı düzeltiliyor (NumPy < 2.0 sürümüne çekiliyor)..."
echo "==========================================================="
pip3 install "numpy<2.0.0" --force-reinstall

echo "==========================================================="
echo "[5/6] Standart PyTorch siliniyor ve JetPack 6.0 Özel PyTorch kuruluyor..."
echo "==========================================================="
# Standart / CPU destekli PyTorch kalıntılarını temizle
pip3 uninstall -y torch torchvision || true
pip3 cache purge

# NVIDIA JetPack 6.0 (ARM64 / Python 3.10) Resmî PyTorch 2.3.0 Kurulumu
pip3 install --no-cache-dir https://developer.download.nvidia.com/compute/redist/jp/v60/pytorch/torch-2.3.0-cp310-cp310-linux_aarch64.whl

# Bağımlılıkları bozmadan uyumlu Torchvision Kurulumu
pip3 install torchvision==0.18.0 --no-deps

echo "==========================================================="
echo "[6/6] Kurulum tamamlandı! GPU & CUDA testi yapılıyor..."
echo "==========================================================="
python3 -c "
import torch
import ultralytics
print('-----------------------------------------------------------')
print('PyTorch Sürümü  :', torch.__version__)
print('CUDA Aktif mi   :', torch.cuda.is_available())
print('Ekran Kartı     :', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'BULUNAMADI!')
print('Ultralytics     :', ultralytics.__version__)
print('-----------------------------------------------------------')
"