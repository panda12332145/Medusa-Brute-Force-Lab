# Lessons Learned

## O que foi praticado

- Configuracao de duas VMs em rede isolada.
- Enumeracao de servicos com Nmap.
- Uso do Medusa em FTP e SMB.
- Ajuste do modulo `web-form` para formulario vulneravel.
- Criacao de wordlists pequenas e controladas.
- Registro de evidencias para portifolio tecnico.

## Pontos de Atencao

- O resultado de brute force depende da qualidade da wordlist.
- Formularios web exigem entender metodo, rota, parametros, cookies e texto de erro.
- Password spraying e diferente de brute force tradicional: testa uma senha comum contra varios usuarios para reduzir bloqueios.
- Ambientes vulneraveis sao otimos para estudo, mas nao representam uma configuracao segura de producao.

## Dificuldades Comuns

- IP da VM muda ao reiniciar.
- DVWA redireciona quando a sessao expira.
- O texto de falha no formulario nao bate com o `DENY-SIGNAL`.
- Firewall ou modo de rede impedem conectividade.
- O modulo SMB pode variar conforme versao e suporte do Medusa instalado.

## Como eu explicaria o projeto

Este projeto simula, em laboratorio isolado, como credenciais fracas podem ser descobertas em servicos como FTP, formularios web e SMB. Depois dos testes, o foco passa para a defesa: limitar tentativas, fortalecer senhas, monitorar logs, reduzir servicos expostos e aplicar boas praticas de autenticacao.

## Proximos Passos

- Adicionar prints reais na pasta `images/`.
- Registrar os resultados em `results/` localmente.
- Criar um pequeno relatorio final com data, IPs, comandos e evidencias.
- Testar bloqueio de tentativas e comparar antes/depois.
