# Medidas de Mitigacao

## FTP

- Desabilitar FTP quando nao for necessario.
- Preferir SFTP/SSH ou FTPS com configuracao adequada.
- Bloquear login anonimo.
- Aplicar senhas fortes e politicas de rotacao quando fizer sentido.
- Usar bloqueio temporario apos muitas falhas de login.
- Restringir acesso por IP ou VPN.
- Monitorar logs de autenticacao.

## Formularios Web

- Implementar rate limiting por IP, usuario e sessao.
- Adicionar MFA para contas sensiveis.
- Usar mensagens de erro genericas.
- Registrar tentativas falhas e alertar eventos suspeitos.
- Implementar bloqueio progressivo ou atraso incremental.
- Usar CAPTCHA somente como camada complementar, nao como unica defesa.
- Proteger sessoes com cookies seguros, `HttpOnly` e `SameSite`.
- Validar controles contra automacao em ambiente de homologacao.

## SMB

- Desabilitar SMBv1.
- Exigir senhas fortes e bloquear senhas comuns.
- Limitar tentativas falhas com politica de lockout.
- Restringir portas `139` e `445` a redes internas confiaveis.
- Remover compartilhamentos desnecessarios.
- Revisar usuarios locais e contas antigas.
- Monitorar eventos de autenticacao e enumeracao.

## Controles Gerais

- Principio do menor privilegio.
- Inventario de servicos expostos.
- Atualizacoes frequentes.
- Logs centralizados.
- Segmentacao de rede.
- Treinamento de usuarios sobre senhas e reuso de credenciais.

## Aprendizado Principal

Forca bruta e password spraying exploram principalmente senhas fracas, reuso de credenciais e ausencia de controles de tentativa. A mitigacao mais efetiva combina politica de credenciais, monitoramento, limitacao de tentativas e reducao da superficie exposta.
