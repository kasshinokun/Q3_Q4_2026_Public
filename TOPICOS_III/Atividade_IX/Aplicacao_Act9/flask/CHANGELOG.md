# Changelog · PetCuida Web alfa

## 1.5.2-alpha · revisão D4

- Adicionada navegação mobile ao painel PJ, que agora continua acessível em telas pequenas apesar da sidebar desktop ser ocultada.
- Ações de equipe, oferta e aceite de demanda exibem erros acessíveis sem fechar formulários ou gerar rejeições não tratadas.
- Importação permanece disponível para adicionar integrantes a equipes já cadastradas; publicação sem profissional ativo orienta o parceiro a completar a equipe.
- O preço do serviço é preenchido em reais na interface e convertido para centavos no backend.
- Importação de profissionais valida JSON/XLS/XLSX, reconhece cabeçalhos em português com acentos, limita até 500 linhas, recusa linhas incompletas e grava o lote em uma transação SQLite.
- Validações adicionais para cadastro, valores, datas, IDs e referências de pets, serviços, ofertas e profissionais.
- Tratamento de erros HTTP mantém os códigos corretos e uploads acima de 2 MiB recebem resposta 413.
- Removidas solicitações de Google Fonts em runtime; tipografia usa fontes locais do sistema para que o alfa funcione sem internet.
- Testes ampliados para fluxos ponta a ponta, atribuição de organização/profissional, importação, valores inválidos e rotas desconhecidas.
- Versão da API identificada como `1.5.2-alpha`, revisão `d4`.

## 1.5.1-alpha · estabilidade da demonstração

- Corrigida expectativa dos testes para a oferta demo adicional.
- Implementado `runTriage` no bootstrap Vue.
- Falhas de carregamento após login retornam ao login com mensagem, sem loading infinito.
- Organizações inexistentes e payloads inválidos retornam erros controlados.
- Removido o README duplicado com capitalização conflitante no Flutter.
- Vue servido localmente em modo produção para apresentações sem rede.

## 1.5.0-alpha · rede de organizações

- Registro com escolha entre tutor e organização/PJ.
- Painel dedicado para clínicas, petshops, projetos sociais e faculdades.
- Cadastro manual e importação de profissionais em JSON, XLS e XLSX.
- Publicação de ofertas com profissional designado.
- Solicitação de ofertas pelo tutor e aceite pela organização com designação explícita.
- Identificação da organização e do profissional em ofertas, demandas e agenda.

## 1.4.0-alpha · apresentação para clientes

- Identidade visual alinhada ao Flutter: azul `#4F6997`, rosa, amarelo e lavanda.
- Dashboard de tutor responsivo, cadastro de pet, agendamento e triagem orientativa.
- Assets oficiais `petcuida-logo.png` e brasão da PUC Minas.
- API local SQLite e adaptadores remotos opcionais.

## Limites conhecidos do alfa

- A autenticação web ainda é demonstrativa: senhas em texto puro, usuário enviado pelo frontend e sem autorização por recurso. Não exponha a internet nem use dados reais.
- A conexão Firestore/Supabase requer configuração e credenciais próprias; estes adaptadores ainda não oferecem paridade integral com os fluxos de organizações do backend SQLite e não foram validados contra instâncias remotas nesta revisão.
- Agenda, créditos, mapa e triagem são demonstrativos. Não há pagamentos, push ou diagnóstico veterinário real.
- O código Flutter acompanha a entrega, mas o Flutter SDK não estava disponível no ambiente usado para validar a revisão D4; não foi executado `flutter analyze` nem um build mobile.
