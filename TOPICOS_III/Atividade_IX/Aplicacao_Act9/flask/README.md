# PetCuida Web · Flask + Vue · Alfa D4

Web app demonstrativo com Flask, SQLite e Vue 3 em módulos ES. Vue é servido localmente em `app/static/js/vendor/`, sem CDN. Versão da API: `1.5.2-alpha` (revisão `d4`).

## Requisitos

- Python 3.10 ou superior.
- As dependências web são instaladas pelo `requirements.txt`.
- Para processar `.xls`, a dependência `xlrd` precisa estar instalada, como já está declarada.

## Instalação e execução

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
python run.py
```

Abra `http://127.0.0.1:5000`.

### Contas fictícias

| Perfil | Usuário | Senha |
|---|---|---|
| Tutor | `petcuida` | `meu pet` |
| Organização | `clinica.petcuida` | `pet pj` |

Os dados são seedados em SQLite em `app/storage/petcuida.db`. Para usar outro caminho, defina `PETCUIDA_DB_PATH` antes de iniciar.

## Fluxo de apresentação

- Tutor: visualize o pet, consulte serviços e solicite uma oferta.
- Organização: navegue por visão geral, equipe, ofertas e demandas; cadastre/import uma equipe, publique serviço com profissional responsável e aceite uma solicitação atribuindo alguém.
- Mobile: o botão de menu do cabeçalho abre as mesmas áreas e a saída da conta.
- Importação: JSON, XLS ou XLSX, até 500 profissionais e até 2 MiB por upload. Exemplo: `../examples/profissionais.json`.

## Testes

```bash
python -m pytest -q
```

## Estrutura

- `app/routes.py`: endpoints JSON e tratamento dos payloads.
- `app/repository.py`: repositório SQLite, validações e importação da equipe.
- `app/db.py`: esquema e dados de demonstração.
- `app/static/js/components/`: componentes Vue do tutor, login e organização.
- `app/static/js/vendor/`: Vue 3 local.
- `app/data_backends/`: adaptadores opcionais ainda sem paridade integral com o fluxo PJ.
- `legacy_flutter/`: referência móvel antiga preservada nesta distribuição.

## Backends remotos

SQLite é o único backend validado ponta a ponta nesta revisão. Os adaptadores Firestore e Supabase são bases de integração e **não** cobrem ainda o mesmo contrato do painel de organizações. Para produção, conclua a paridade dos métodos, defina esquema/regras de acesso, use credenciais server-side apropriadas e execute testes de integração em projetos isolados antes de trocar `PETCUIDA_BACKEND`.

## Limites de segurança

O login web é intencionalmente demonstrativo. Senhas ficam em texto puro no SQLite; `user_id` e `organization_id` são enviados pelo frontend e não há sessão autenticada nem autorização por organização. Não publique este servidor, não use dados reais nem trate os logins demo como contas seguras. Antes de produção, implemente autenticação server-side, hash de senha, sessão/token, autorização por recurso, CSRF e limites operacionais apropriados.

Agenda, créditos e triagem são dados demonstrativos. A triagem não substitui avaliação veterinária.
