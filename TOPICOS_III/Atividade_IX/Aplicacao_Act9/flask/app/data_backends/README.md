# Persistência remota · status na revisão D4

O modo validado ponta a ponta é `SQLiteRepository`. Os arquivos `firestore_adapter.py` e `supabase_adapter.py` são **esboços parciais**, não backends alternativos prontos para uso: cobrem somente operações básicas de tutor, pets e agenda e não implementam o fluxo organizacional completo (cadastro PJ, profissionais, ofertas, importação, demandas e aceite).

Por isso, mantenha `PETCUIDA_BACKEND=sqlite` para demonstrações. Os adaptadores remotos não foram testados nesta revisão contra instâncias Firebase/Firestore ou Supabase, e não devem ser ativados com dados reais.

Antes de habilitar um backend remoto, a equipe deve concluir a paridade com o contrato de `app/repository.py`, definir esquema/índices (e transações quando necessário), implementar autenticação e autorização no servidor, configurar regras de segurança (Firestore/Supabase RLS), usar segredos somente em ambiente server-side, e adicionar testes de integração com projetos isolados. A chave pública `anon` do Supabase, por si só, não fornece autorização adequada para este app.

As dependências dos SDKs não são carregadas no fluxo SQLite; portanto, o demo local não requer credenciais nem conexão com esses serviços.
