#!/bin/bash
set -e

REPO_URL="https://github.com/alacritty/alacritty.git"
REPO_DIR="alacritty"
BRANCH="master"  

build_and_install() {
  cd "$REPO_DIR"
  echo "Building"
  cargo build --release

  sudo cp target/release/alacritty /usr/local/bin/
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
    if [ -f "/usr/local/bin/alacritty" ]; then
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
