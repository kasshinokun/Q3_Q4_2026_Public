# Roteiro de execução (05/10 a 09/10/2026)

Hoje é segunda-feira (05/10). O prazo é sexta (09/10) às 23:59. Recomenda-se **terminar a entrega na quinta à noite** e usar sexta como folga.

## Divisão sugerida

| Integrante | Frente | Entregável |
|---|---|---|
| Gabriel | Custos de tecnologia (infraestrutura, loja, ferramentas) e compilação do LaTeX | Seção 1 (itens de tecnologia) e PDF final |
| Giovanna | Custos formais (contador, jurídico/LGPD, consultoria veterinária) | Seção 1 (itens formais), cotações anexas |
| Júlia | Concorrência e valor percebido | Seção 3 (concorrência e valor percebido) |
| Kathleen | Teste de aceitação (formulário, aplicação, resultados) | Seção 4, com dados reais |

A divisão é só uma proposta; troquem se fizer sentido para o grupo.

## Cronograma

| Dia | O que fazer | Pronto quando |
|---|---|---|
| **Seg 05/10** | Ler o enunciado e o protótipo. Distribuir as frentes. Criar o formulário da pesquisa (ver `04_teste_aceitacao.md`) e começar a divulgá-lo. Pedir as cotações (contador, advogado/LGPD, veterinário consultor). | Formulário publicado; 3 cotações pedidas |
| **Ter 06/10** | Substituir todos os valores [C] do protótipo por cotações ou confirmações. Conferir os preços de concorrentes nos **sites oficiais**. Confirmar a taxa de assinaturas da Google Play e a alíquota do Simples. | Nenhum [C] restante |
| **Qua 07/10** | Revisar as hipóteses [H]: manter, ajustar ou justificar cada uma. Reexecutar o modelo (ver `03_precificacao.md`) se algum valor mudar. Combinar com 2 ou 3 clínicas a conversa sobre o Plano Parceiro. | Tabelas de custo e preço atualizadas |
| **Qui 08/10** | Fechar a pesquisa, tabular os resultados, decidir se o preço se mantém. Escrever a seção 4 com **resultados**, não só a ideia de teste. Gerar o PDF. | PDF completo e revisado |
| **Sex 09/10** | Conferência final com `05_checklist_entrega.md`. Enviar antes das 23:59. | Upload confirmado |

## Como transformar o protótipo em entrega

1. Copie a pasta `Prototipo/` para a pasta de trabalho do grupo (por exemplo `Entrega_Real/Documento/`).
2. Edite apenas os arquivos de `partes/`; o `main_act9.tex` não precisa mudar.
3. Compile com `latexmk -pdf main_act9.tex` (ou no Overleaf, enviando a pasta).
4. Confira nomes, orientador e tutor em `partes/preambulo.tex`.
5. Na capa e na folha de rosto, **o título deve ser "Levantamento de custos e precificação"** e a Atividade 9; o enunciado original traz "(Orientações)", que **não** deve aparecer no trabalho final.
