# Alertas e pendências antes de entregar

## 1. Mudança de stack: Firebase × Flask/Vue

As Atividades 3 e 4 citam **Flutter + Firebase** (Firestore, Cloud Functions, Authentication). O pacote `Revisar projeto e gerar versão Vue_Flask com changelog` descreve uma nova versão com **Flask, Vue 3 e SQLite local**, e deixa Firestore e Supabase como adaptadores dormentes. O protótipo usa um custo genérico de "infraestrutura de backend" (Firebase Blaze **ou** VPS para Flask).

**Decidam qual é a arquitetura de referência** para a entrega e ajustem a linha de infraestrutura:

- Firebase: custo por uso, com cotas gratuitas; Cloud Functions exige o plano Blaze.
- Flask/Vue: custo de servidor (VPS/PaaS) e de banco de dados; SQLite local serve para demonstração, mas não para produção multiusuário.

## 2. Valores marcados [C]

Os valores abaixo precisam de confirmação: **alíquota do Simples**, **taxa de 15% da Google Play sobre assinaturas**, contabilidade, jurídico/LGPD e consultoria veterinária.

## 3. Preços de concorrentes vêm de intermediários

Os planos da Petlove foram obtidos em sites de corretores e guias, e o próprio resultado de busca mostra variação (por exemplo, o plano Leve aparece a R$ 14,90 e a R$ 17,90). **Confira no site oficial** e cite a data.

## 4. O PetCuida não é plano de saúde

Mantenha o texto deixando claro que não há cobertura, rede de seguro nem promessa de atendimento. Isso protege o grupo de questionamentos regulatórios e da concorrência direta com planos.

## 5. O custo mais sensível: liquidação de créditos

O fundo de liquidação consome cerca de 990 de 2.232 reais de margem no modelo. Se não houver convênio ou patrocínio, o equilíbrio do cenário A sobe de ~310 para ~2.880 usuários ativos. Se o grupo tiver uma ideia mais barata de remunerar as clínicas (por exemplo, só visibilidade e ocupação de horário ocioso), reflita isso na tabela.

## 6. Hipóteses de volume

1.500 usuários ativos no mês 12, 5% de assinantes e 10 clínicas são **hipóteses**. Se o grupo tiver outra expectativa, ajuste e recalcule.

## 7. Cenário B não fecha

No cenário com equipe remunerada, o ponto de equilíbrio fica em torno de 10 a 13 mil usuários ativos. Isso é uma informação útil: indica que, com a remuneração da equipe, o negócio depende de escala ou de financiamento. Decidam se querem mostrar isso explicitamente na entrega.

## 8. Câmbio

O dólar oscilou de ~R$ 5,22 para menos de R$ 5,00 na segunda-feira (05/10/2026) após o primeiro turno das eleições. O impacto nos itens em dólar é pequeno, mas anotem a data e a cotação usadas.

## 9. Metadados acadêmicos

O pacote do aplicativo (`creditos_projeto.dart`) tem TODOs com nomes de curso, equipe e orientadores. Não afeta esta atividade, mas vale corrigir antes de qualquer demonstração.
