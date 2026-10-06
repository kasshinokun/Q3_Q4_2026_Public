# Como levantar os custos reais

O enunciado pede: *custos fixos* (não variam com a venda) e *custos variáveis* (crescem com a venda), em tabela, **com valores estimados**.

## 1. Defina o cenário

Mantenha os dois cenários do protótipo, ou escolha um só e justifique:

- **Cenário A (enxuto):** só despesas em caixa. Sócios não recebem.
- **Cenário B (equipe remunerada):** inclui gestor de rede e pró-labore simbólico.

Registre também o **horizonte** (mês 12 de operação, em Belo Horizonte) e o **câmbio** usado nos itens em dólar.

## 2. Itens fixos e como confirmar cada um

| Item (protótipo) | Como confirmar | Onde registrar |
|---|---|---|
| Contabilidade e formalização | Pedir orçamento a 2 contadores; perguntar qual enquadramento no Simples Nacional se aplica à atividade de software e se há fator R | Cotação anexa |
| Infraestrutura de backend | Estimar leituras, escritas e usuários do piloto e usar a calculadora de preços do Firebase **ou** do provedor de VPS escolhido. Lembre que a versão Flask/Vue usa SQLite local (ver `06_alertas.md`) | Planilha de uso |
| Google Maps Platform | Conferir a cota gratuita mensal na tabela de preços oficial e estimar as buscas | Print da tabela oficial |
| Domínio, e-mail e ferramentas | Consultar o preço de domínio .br e dos planos gratuitos usados | Tabela simples |
| Consultoria veterinária | Pedir proposta a um veterinário; verificar parceria com faculdade de Medicina Veterinária (pode zerar o custo) | Proposta ou carta de intenção |
| Jurídico e LGPD | Orçamento de advogado para termos de uso, política de privacidade e parecer sobre a triagem (CFMV) | Cotação anexa |
| Materiais de divulgação | Orçamento de gráfica (cartazes A4, adesivos com QR) | Orçamento |
| Conta de desenvolvedor Google Play | Taxa única; confirmar o valor atual no Play Console | Print |

## 3. Itens variáveis e como confirmar cada um

| Item | Como confirmar |
|---|---|
| Taxa Pix e cartão | Consultar a tabela do gateway que será usado (Mercado Pago, Pagar.me, Stripe etc.) para **vendedor novo**; anotar a data da consulta |
| Imposto sobre receita | Perguntar ao contador qual alíquota efetiva usar; o protótipo usa 6% como caso base e cita 15,5% como pior caso |
| Taxa da loja sobre assinaturas | Ler a política de faturamento vigente do Google Play para assinaturas; o protótipo usa 15% e marca como [C] |
| Infraestrutura e suporte por usuário | Manter como hipótese, mas explique o raciocínio (ex.: horas de suporte por mês ÷ usuários) |
| Fundo de liquidação de créditos | Conversar com 2 ou 3 clínicas sobre quanto aceitariam receber por crédito; é o custo mais sensível |

## 4. Regras para registrar cada valor

- Cada linha precisa de **valor, unidade, origem e data de consulta**.
- Guarde prints ou PDFs das cotações em uma pasta `Entrega_Real/Evidencias/` (não vão no documento principal, mas servem se o professor perguntar).
- Se um valor for estimativa sua, diga isso no texto (hipótese) e mostre o raciocínio.

## 5. Verificações finais

- [ ] A soma dos fixos bate com o total da tabela.
- [ ] A tabela de variáveis tem unidade (R$/mês, %, R$/usuário) em todas as linhas.
- [ ] Os itens pontuais (jurídico, conta Google Play) estão diluídos de forma explícita.
- [ ] Os custos citados nas Atividades 3 e 4 (consultoria veterinária, LGPD, suporte, Firebase) aparecem aqui.
