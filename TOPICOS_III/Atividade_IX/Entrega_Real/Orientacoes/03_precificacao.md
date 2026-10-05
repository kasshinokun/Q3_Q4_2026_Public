# Como fechar a precificação

O enunciado pede: **definir um preço de venda** e justificá-lo por (1) margem de lucro desejada, (2) valor percebido pelo cliente e (3) análise da concorrência.

## 1. Decida o que é "o preço"

O PetCuida tem mais de uma fonte de receita. Na entrega, **diga com clareza qual é o preço de venda principal** e liste os demais. O protótipo adota:

| Oferta | Preço |
|---|---|
| PetCuida Básico (tutor) | Gratuito |
| PetCuida+ (tutor) | R$ 12,90/mês ou R$ 119,00/ano |
| Comissão | 10% sobre a parte paga em dinheiro |
| Plano Parceiro (clínica) | R$ 79,90/mês (3 meses grátis no piloto) |

Se o grupo quiser outros valores, as faixas da Atividade 3 são: assinatura de R$ 9,90 a R$ 14,90 e comissão de 8% a 12%.

## 2. Margem de lucro desejada

Fórmulas usadas no protótipo:

```
Margem de contribuição unitária = preço − custos variáveis por unidade
Margem de contribuição (%)      = margem de contribuição ÷ preço
Resultado mensal                = Σ margens de contribuição − custos fixos
Ponto de equilíbrio (usuários)  = custos fixos ÷ margem de contribuição por usuário ativo
Piso de preço (margem alvo m)   = custo variável unitário ÷ (1 − m − alíquotas%)
```

O grupo precisa **declarar a meta**: o protótipo usa margem de contribuição ≥ 50% e margem líquida de cerca de 15% no cenário enxuto. Mantenha, ajuste ou troque por uma meta que o grupo consiga defender.

## 3. Recalcular os números

O protótipo foi gerado por um modelo simples de premissas (volume, ticket, taxas). Se qualquer valor mudar, **recalcule toda a cadeia** (tabela de custos, economia unitária, ponto de equilíbrio, sensibilidade), caso contrário as tabelas ficam inconsistentes entre si. Qualquer planilha serve; o essencial é que o grupo consiga explicar de onde sai cada número.

Premissas a revisar com o grupo:

| Premissa | Valor no protótipo | Pergunta para validar |
|---|---|---|
| Usuários ativos no mês 12 | 1.500 | É realista para um bairro/região no primeiro ano? |
| Atendimentos por usuário/mês | 10% | Quantos tutores usam o serviço por mês? |
| Ticket médio | R$ 110 | Confere com a tabela social negociada com as clínicas? |
| Parte paga em dinheiro | 70% | O teto de créditos por atendimento será 30%? |
| Conversão em assinante | 5% | Resultado da pesquisa de aceitação |
| Atendimentos com crédito | 40% | Há créditos suficientes circulando? |
| Convênio/patrocínio | R$ 1.500/mês | Existe interessado real (prefeitura, ONG, empresa)? |

## 4. Valor percebido

Argumente a partir de dados do grupo, não só de opinião:

- Cite as **entrevistas da Atividade 6** (esquecimento de vacina, automedicação, adiar consulta).
- Compare o preço com o benefício concreto (custo anual da assinatura vs. custo de uma consulta ou vacina).
- Assuma o limite: **a disposição a pagar ainda não foi medida** até o teste de aceitação ser concluído.

## 5. Análise da concorrência

1. Liste **3 a 6 alternativas reais**: planos pet (ex.: Petlove Saúde), apps de registro e lembrete (ex.: Flockr), consulta e vacina no particular e campanhas públicas gratuitas.
2. Para cada uma, registre **preço, o que inclui e fonte com data**.
3. Confira os preços **nos sites oficiais**. O protótipo usou páginas de intermediários e guias de preço, e esses valores variam por cidade.
4. Escreva o **posicionamento**: onde o PetCuida fica em relação a elas e por quê (o protótipo diz que ele *não* é plano de saúde).
5. Adicione ao menos **uma clínica ou pet shop de BH** com preço de consulta e de vacina, obtido por telefone ou site.

## 6. Verificações finais

- [ ] O preço escolhido está explícito em uma tabela.
- [ ] As três justificativas (margem, valor, concorrência) aparecem **separadas** e com títulos próprios.
- [ ] Os números do ponto de equilíbrio e da sensibilidade foram recalculados.
- [ ] O texto não promete cobertura de saúde.
