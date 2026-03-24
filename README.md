# CryptoExchangeIOS

Projeto iOS em SwiftUI criado a partir do app Android Compose enviado.

Stack:
- SwiftUI
- MVVM
- Clean Code
- async/await
- URLSession
- navegação nativa com NavigationStack
- sem dependências externas

## Requisitos
- Xcode 15 ou superior
- iOS 17.0+

## Como configurar a API key
1. Abra `CryptoExchangeIOS.xcodeproj` no Xcode.
2. No target `CryptoExchangeIOS`, adicione uma variável de ambiente `CMC_API_KEY` no Scheme, ou defina `CMC_API_KEY` em Build Settings / User-Defined.
3. Rode o app.

Sem API key, o app abre normalmente e mostra estado de erro amigável.

## Estrutura
- `App/`: entrada do app
- `Core/`: configuração, DI, networking e utilitários
- `Data/`: DTOs, serviços, mappers e repositórios
- `Domain/`: modelos, contratos e use cases
- `Presentation/`: telas, view models e componentes SwiftUI

## Funcionalidades implementadas
- Lista de exchanges com paginação
- Pull to refresh
- Tela de detalhe da exchange
- Carregamento paginado de market pairs
- Abertura do website no Safari
- Estados de loading, vazio e erro
- Debug screen para logs de imagem e API em builds DEBUG
