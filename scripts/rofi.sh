#!/bin/bash
set -e

sudo apt update
sudo apt install libpango1.0-dev \
  libcairo2-dev \
  libcairo2-dev \
  libglib2.0-dev \
  libgdk-pixbuf2.0-dev \
  libstartup-notification0-dev \
  libxkbcommon-dev \
  libxkbcommon-x11-dev \
  libxcb1-dev \
  libxcb-xkb-dev \
  libxcb-randr0-dev \
  libxcb-xinerama0-dev \
  libxcb-util-dev \
  libxcb-ewmh-dev \
  libxcb-icccm4-dev \
  libxcb-cursor-dev \
  libxcb-imdkit-dev

REPO_URL="https://github.com/davatorium/rofi.git"
REPO_DIR="rofi"
BRANCH="master"

build_and_install() {
  cd "$REPO_DIR"
  echo "Building"
  meson setup build --prefix=/usr/local
  ninja -C build
  sudo ninja -C build install
  cd ..
  echo "Done"
}

# Check if the repository already exists locally.
if [ -d "$REPO_DIR" ]; then
  echo "Checking for updates"
  cd "$REPO_DIR"
  git fetch origin
  LOCAL_COMMIT=$(git rev-parse HEAD)
  REMOTE_COMMIT=$(git rev-parse origin/"$BRANCH")

  if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    echo "Alles gut"
    if [ -x "/usr/local/bin/rofi" ]; then
      echo "Binary is already installed. Skipping build."
      exit 0
    else
      echo "Binary not found. Proceeding with build."
      cd ..
      build_and_install
    fi
  else
    echo "Outdated"
    git pull origin "$BRANCH"
    cd ..
    build_and_install
  fi
else
  echo "Cloning"
  git clone "$REPO_URL"
  build_and_install
fi
