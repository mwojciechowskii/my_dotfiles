#!/usr/bin/env bash
set -euo pipefail

# Configuration
INSTALL_DIR="/opt/nvim"
TMP_ARCHIVE="nvim-linux-x86_64.tar.gz"
API_URL="https://api.github.com/repos/neovim/neovim/releases/latest"

get_latest_tag() {
  curl -sSL "$API_URL" \
    | grep -Po '"tag_name": "\K.*?(?=")'
}

download_and_extract() {
  local tag=$1
  local download_url="https://github.com/neovim/neovim/releases/download/${tag}/${TMP_ARCHIVE}"

  echo "Downloading Neovim ${tag}..."
  curl -sSL -o "$TMP_ARCHIVE" "$download_url"

  echo "Cleaning up previous installations..."
  sudo rm -rf "/opt/nvim-linux-x86_64" "$INSTALL_DIR"

  echo "Extracting archive to /opt..."
  sudo tar -xzf "$TMP_ARCHIVE" -C /opt
  sudo rm -f "$TMP_ARCHIVE"

  echo "Renaming extracted folder to ${INSTALL_DIR}..."
  sudo mv /opt/nvim-linux-x86_64 "$INSTALL_DIR"

  echo "Creating/updating global symlink in /usr/local/bin..."
  sudo ln -sf "${INSTALL_DIR}/bin/nvim" /usr/local/bin/nvim

  echo "Neovim ${tag} installed to ${INSTALL_DIR}"
}

get_local_tag() {
  if [[ -x "${INSTALL_DIR}/bin/nvim" ]]; then
    "${INSTALL_DIR}/bin/nvim" --version \
      | head -n1 \
      | awk '{print $2}'
  else
    echo ""
  fi
}

main() {
  local latest_tag local_tag
  latest_tag=$(get_latest_tag)
  if [[ -z "$latest_tag" ]]; then
    echo "Error: unable to fetch the latest Neovim tag."
    exit 1
  fi

  local_tag=$(get_local_tag)
  # strip leading 'v' from latest_tag for comparison
  if [[ "${local_tag}" == "${latest_tag#v}" ]]; then
    echo "Neovim is already up-to-date (version $local_tag)."
    exit 0
  fi

  echo "Updating Neovim (local: $local_tag → latest: ${latest_tag#v})"
  download_and_extract "$latest_tag"
}

main "$@"
