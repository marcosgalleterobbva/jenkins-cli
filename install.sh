#!/usr/bin/env sh
set -eu

REPO="${JENKINS_CLI_REPO:-}"
REF="main"
BIN_DIR="${HOME}/.local/bin"
CMD_NAME="jenkins-cli"
SOURCE_URL=""

usage() {
  cat <<USAGE
Install jenkins-cli from GitHub.

Usage:
  sh install.sh [options]

Options:
  --repo <owner/repo>   GitHub repo to download from (or set JENKINS_CLI_REPO)
  --ref <git-ref>       Branch or tag to download from (default: main)
  --version <tag>       Alias for --ref
  --bin-dir <dir>       Installation directory (default: ~/.local/bin)
  --name <command-name> Installed command name (default: jenkins-cli)
  --source-url <url>    Full URL to jenkins-cli script (overrides repo/ref)
  -h, --help            Show this help message
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --repo)
      REPO="$2"
      shift 2
      ;;
    --ref)
      REF="$2"
      shift 2
      ;;
    --version)
      REF="$2"
      shift 2
      ;;
    --bin-dir)
      BIN_DIR="$2"
      shift 2
      ;;
    --name)
      CMD_NAME="$2"
      shift 2
      ;;
    --source-url)
      SOURCE_URL="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ -z "$SOURCE_URL" ]; then
  if [ -z "$REPO" ]; then
    echo "ERROR: Missing --repo <owner/repo> (or set JENKINS_CLI_REPO)." >&2
    echo "Example:" >&2
    echo "  curl -fsSL https://raw.githubusercontent.com/<org>/<repo>/main/install.sh | sh -s -- --repo <org>/<repo>" >&2
    exit 1
  fi

  case "$REPO" in
    */*)
      ;;
    *)
      echo "ERROR: Invalid repo '$REPO'. Expected format: owner/repo" >&2
      exit 1
      ;;
  esac

  SOURCE_URL="https://raw.githubusercontent.com/${REPO}/${REF}/jenkins-cli"
fi

TMP_FILE="$(mktemp "${TMPDIR:-/tmp}/jenkins-cli.XXXXXX")"
cleanup() {
  rm -f "$TMP_FILE"
}
trap cleanup EXIT INT TERM

echo "Downloading jenkins-cli from: $SOURCE_URL"
curl -fsSL "$SOURCE_URL" -o "$TMP_FILE"
chmod 0755 "$TMP_FILE"

mkdir -p "$BIN_DIR"
DEST="$BIN_DIR/$CMD_NAME"

if mv "$TMP_FILE" "$DEST" 2>/dev/null; then
  :
else
  cp "$TMP_FILE" "$DEST"
  chmod 0755 "$DEST"
fi

echo "Installed: $DEST"

case ":$PATH:" in
  *":$BIN_DIR:"*)
    ;;
  *)
    echo "Note: $BIN_DIR is not in PATH."
    echo "Add this line to your shell profile (~/.zshrc or ~/.bashrc):"
    echo "  export PATH=\"$BIN_DIR:\$PATH\""
    ;;
esac

echo "Done. Run '$CMD_NAME --help' to verify."
