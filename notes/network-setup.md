# Configuracao de Rede do Laboratorio

## Objetivo

Isolar Kali Linux e Metasploitable 2 em uma rede de laboratorio para que os testes nao atinjam sistemas externos.

## VirtualBox

1. Desligue as duas VMs.
2. Abra as configuracoes de cada VM.
3. Va em `Network`.
4. Em `Adapter 1`, selecione `Host-only Adapter`.
5. Use o mesmo adaptador para Kali e Metasploitable.
6. Inicie as duas VMs.

## Descobrir IPs

No Kali:

```bash
ip addr
```

No Metasploitable:

```bash
ifconfig
```

Exemplo usado neste projeto:

```text
Kali:            192.168.56.10
Metasploitable: 192.168.56.101
```

## Validar Conectividade

No Kali:

```bash
ping -c 4 192.168.56.101
```

## Enumeracao Inicial

```bash
nmap -sV -p 21,80,139,445 192.168.56.101
```

Portas esperadas em Metasploitable 2:

- `21/tcp`: FTP;
- `80/tcp`: HTTP;
- `139/tcp` e `445/tcp`: SMB/Samba.

## Boas Praticas

- Mantenha a rede em modo host-only.
- Evite bridge com a rede principal durante os testes.
- Use IPs privados.
- Registre cada comando executado.
- Salve evidencias sem expor senhas reais de ambientes pessoais.
