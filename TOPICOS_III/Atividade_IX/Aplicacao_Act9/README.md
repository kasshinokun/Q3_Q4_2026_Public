# PetCuida · entrega alfa Web + Flutter · revisão D4

Versão de apresentação do PetCuida com interface web Flask/Vue e aplicativo Flutter de referência. O web demo usa SQLite local; o projeto Flutter permanece no modo local por padrão.

## Logins de demonstração

- Tutor: `petcuida` / `meu pet`
- Organização/PJ: `clinica.petcuida` / `pet pj`

Use somente os dados fictícios seedados para apresentações.

## Roteiro curto de demonstração

1. Inicie a aplicação Flask conforme `flask/README.md` e entre como tutor.
2. Mostre o perfil do pet, a rede de serviços e o agendamento.
3. Saia e entre como organização; em tela estreita, use o menu mobile no cabeçalho.
4. Mostre a equipe; cadastre um profissional manualmente ou importe `examples/profissionais.json`.
5. Publique uma oferta atribuindo o profissional e um valor em reais.
6. Volte ao perfil de tutor, solicite a oferta e retorne ao painel PJ para aceitar a demanda e designar um profissional.
7. Confira no tutor que a agenda exibe organização, serviço, profissional e estado da solicitação.

## Executar a aplicação web

```bash
cd flask
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
python run.py
```

Acesse `http://127.0.0.1:5000`. Testes: `python -m pytest -q` dentro de `flask/`.

## Conteúdo

- `flask/`: aplicação Flask, API, painel Vue, CSS, testes e documentação do web alfa.
- `flutter/`: código-fonte do aplicativo Flutter de referência; configuração remota desligada por padrão.
- `examples/profissionais.json`: arquivo pequeno para testar a importação da equipe.

## Segurança e limites

**Este pacote é um protótipo alfa, não um sistema de produção.** O login web usa armazenamento de senha demonstrativo em SQLite, sem sessão autenticada nem autorização por recurso. Não exponha a aplicação em rede pública, não use dados pessoais/reais e não cadastre credenciais de produção. Antes de produção, implemente autenticação e autorização server-side, hash forte de senhas, proteção CSRF, validação legal dos documentos e regras de acesso em cada backend remoto.

A API permite seleção de Firestore/Supabase por configuração, mas esses adaptadores ainda não têm paridade integral com o fluxo de organizações e não foram testados contra projetos remotos nesta revisão. Não os ative para um piloto com dados reais sem completar a configuração e auditoria de segurança.

## Identificação da revisão

- Versão web: `1.5.2-alpha`
- Revisão: `D4`
- O changelog detalhado está em `flask/CHANGELOG.md`.
