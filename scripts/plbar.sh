#!/bin/bash
set -e

REPO_URL="https://github.com/polybar/polybar.git"
REPO_DIR="polybar"
BRANCH="master"  
sudo apt update
sudo apt install -y \
	python3-sphinx \
    cmake \
    cmake-data \
    libcairo2-dev \
    libxcb1-dev \
    libxcb-util0-dev \
    libxcb-randr0-dev \
    libxcb-composite0-dev \
    python3-xcbgen \
    xcb-proto \
    libxcb-image0-dev \
    libxcb-ewmh-dev \
    libxcb-icccm4-dev \
    libcurl4-openssl-dev \
    libjsoncpp-dev \
    libasound2-dev \
    libmpdclient-dev \
    libiw-dev \
    libpulse-dev \
    libxcb-xrm-dev \
    libxcb-cursor-dev \
    libnl-genl-3-dev \
    libxcb-xkb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
	libuv1-dev
build_and_install() {
  cd "$REPO_DIR"

  # Ensure submodules are initialized.
  echo "Updating submodules..."
  git submodule update --init --recursive

  echo "Creating build directory..."
  mkdir -p build
  cd build
  
  echo "Running CMake with the following options:"
  echo "-- DENABLE_ALSA=ON"
  echo "-- DENABLE_I3=ON"
  echo "-- DENABLE_NETWORK=ON"
  echo "-- DENABLE_CURL=ON"
  echo "-- DENABLE_MPD=ON"
  echo "-- DENABLE_XKB=ON"
  
  cmake .. \
    -DENABLE_ALSA=ON \
    -DENABLE_I3=ON \
    -DENABLE_NETWORK=ON \
    -DENABLE_CURL=ON \
    -DENABLE_MPD=ON \
    -DENABLE_XKB=ON
  
  echo "Building Polybar..."
  make -j$(nproc)
  
  echo "Installing Polybar..."
  sudo make install
  
  cd ../..
  echo "Polybar installation complete!"
}

# Check if the repository already exists locally.
if [ -d "$REPO_DIR" ]; then
  echo "Repository exists. Checking for updates..."
  cd "$REPO_DIR"
  git fetch origin
  LOCAL_COMMIT=$(git rev-parse HEAD)
  REMOTE_COMMIT=$(git rev-parse origin/"$BRANCH")
  
  if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    echo "Repository is up to date."
    if [ -x "/usr/local/bin/polybar" ]; then
      echo "Polybar binary is already installed. Skipping build."
      exit 0
    else
      echo "Polybar binary not found. Proceeding with build."
      cd ..
      build_and_install
    fi
  else
    echo "Repository is outdated. Pulling latest changes..."
    git pull origin "$BRANCH"
    # Update submodules after pulling.
    git submodule update --init --recursive
    cd ..
    build_and_install
  fi
else
  echo "Cloning repository..."
  git clone --recursive "$REPO_URL"
  build_and_install
fi
