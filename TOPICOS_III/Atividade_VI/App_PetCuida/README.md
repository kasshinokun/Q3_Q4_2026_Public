# PetCuida — versão alfa Android

Aplicativo Flutter demonstrativo para organizar cuidados acessíveis de pets, com dados genéricos locais e sem dependências de backend. Esta entrega cobre o fluxo completo do diagrama de telas: autenticação, onboarding, dashboard, área do pet (vacinas, prontuário, QR Code), triagem orientativa (por perguntas e por chat), rede solidária (clínicas, mapa, agendamento, check-out híbrido, mural) e perfil do tutor (saldo/extrato, agendamentos, configurações, suporte).
## Versões
- [Até a versão 3d(Possui .zip)](https://github.com/kasshinokun/Q3_Q4_2026_Public/tree/main/TOPICOS_III/Atividade_VI/App_PetCuida/Alpha_3c)
- 3e2 --> Arquivo .zip
- [3g2 e 3h2](https://github.com/kasshinokun/Q3_Q4_2026_Public/tree/main/TOPICOS_III/Atividade_VI/App_PetCuida/Alpha_3_G_H2)
- [3i](https://github.com/kasshinokun/Q3_Q4_2026_Public/tree/main/TOPICOS_III/Atividade_VI/App_PetCuida/Alpha_3_I) --> Preparação para próxima etapa
## Arquitetura

O projeto segue uma estrutura modular por *feature*, com o núcleo compartilhado isolado em `core/`:

```
lib/
  main.dart                    # Providers globais + MaterialApp.router
  core/
    theme/                     # Paleta de cores e ThemeData central
    models/                    # Pet, Servico, Pedido, Atividade, Perfil
    services/                  # AuthService e AppDataService (ChangeNotifier)
    widgets/                   # Componentes reutilizados entre telas
    routes/                    # GoRouter + redirects de login/onboarding
  features/
    auth/       home/       pet/       triagem/       rede_solidaria/       perfil/
```

**Decisões técnicas:**

- **Gerenciamento de estado:** `provider` (`ChangeNotifier`) para `AuthService` (login/cadastro/onboarding) e `AppDataService` (dados mockados: pet, serviços, pedidos, créditos). Evita duplicar estado mutável em cada tela.
- **Navegação:** `go_router`, com um `ShellRoute` mantendo a barra inferior fixa nas 4 abas principais e `redirect` cuidando de login -> onboarding -> dashboard automaticamente.
- **QR Code:** `qr_flutter` gera o QR exportável do prontuário do pet.
- **Sem `google_fonts`:** o tema usa apenas fontes do sistema, para manter o build leve e sem dependência de rede em tempo de execução — adequado ao estágio alfa.

## Compatibilidade Android

- **minSdk 29:** Android 10.
- **targetSdk 35:** Android 15, usando toolchain estável.
- O aplicativo pode ser instalado em Android 10 a 17, desde que o dispositivo aceite o APK e os requisitos do Flutter. Recursos específicos de Android 16/17 não são usados nesta versão.
- Quando o toolchain estável suportar API 37 de forma consolidada, `compileSdk`/`targetSdk` podem ser elevados sem alterar a arquitetura do app.

## Como executar

1. Instale Flutter stable e Android SDK.
2. Ajuste `android/local.properties` para os caminhos locais de Flutter e Android SDK.
3. Execute `flutter pub get`.
4. Valide com `flutter analyze`.
5. Execute em um dispositivo/emulador Android com `flutter run`.
6. Gere o APK alfa com `flutter build apk --debug` ou `flutter build apk --release`.

Login de demonstração: usuário `petcuida`, senha `meu pet` (não requer onboarding). Qualquer conta nova criada em "Criar conta" passa pelo Onboarding do Pet no primeiro acesso.

## Limitações conhecidas do alfa

O mapa é esquemático, os créditos e registros são demonstrativos, a triagem não realiza diagnóstico, e ações de backend, pagamentos reais, notificações push, GPS e compartilhamento externo ainda são pontos de integração para uma próxima etapa.
