# Galeria de Artistas Curitibanos — iOS App

Projeto desenvolvido para a disciplina de **Mobile Development: iOS**, com o objetivo de criar uma aplicação mobile (com UIKit) chamada Galeria de Artistas Curitibanos, utilizando UICollectionView, navegação entre telas e componentes nativos do iOS. O trabalho apresenta obras de artistas ligados à cidade de Curitiba, permitindo visualizar detalhes das obras, realizar pesquisas por artista ou título e compartilhar conteúdos, aplicando conceitos de UIKit, Swift, responsividade de interface e boas práticas de desenvolvimento mobile.

---

## Integrantes

- Adrian Antonio de Souza Gomes
- Edmund Soares de Sousa
- Lucas Azzolin Haubmann
- Vinicius Lima Teider

---

## Como abrir no Xcode

1. Abra o **Xcode**.
2. Escolha **File › New › Project…**
3. Selecione **App** (iOS) e configure:
   - **Product Name:** `GaleriaArtistas`
   - **Interface:** `Storyboard`
   - **Language:** `Swift`
4. Após criar o projeto, **exclua** o arquivo gerado automaticamente:
   - `Main.storyboard`
   - > `ViewController.swift` pode ser mantido — ele está presente no projeto mas não é utilizado, pois o `SceneDelegate` define a raiz da navegação.
5. **Copie** os arquivos Swift desta pasta para dentro do projeto:
   - `Models/ObraDeArte.swift`
   - `Controllers/GaleriaViewController.swift`
   - `Controllers/DetalhesViewController.swift`
   - `Views/ObraCelula.swift`
   - `AppDelegate.swift` *(substitui o gerado)*
   - `SceneDelegate.swift` *(substitui o gerado)*
6. Em **Info.plist**, remova (ou deixe vazia) a chave `UIMainStoryboardFile`.
7. Em **Build Settings**, confirme que `SWIFT_VERSION = 5.9` ou superior.

---

## Imagens do Projeto — Assets.xcassets

As imagens utilizadas estão disponíveis na pasta `Imagens`, prontas para uso. Para que o aplicativo carregue as imagens corretamente, copie os arquivos para o catálogo de assets (`Assets.xcassets`) no Xcode, usando exatamente os nomes listados abaixo.

O conjunto de imagens representa diferentes formas de expressão artística presentes em Curitiba, com foco em arte urbana, grafites e murais. As obras destacam a importância da arte de rua como forma de identidade cultural e valorização dos espaços públicos da cidade.

| Nome no catálogo  | Artista           | Obra                               |
|-------------------|-------------------|------------------------------------|
| `povo_livre`      | Michel Devis      | Marechal Floriano                  |
| `mafiosos`        | Gardpam           | Hospital Hélio Anjos Ortiz         |
| `cwbsiria`        | Cosmic Boys       | Damasco na Síria                   |
| `paulo_leminski`  | João Marcos       | Homenagem a Paulo Leminski         |
| `tec_puc`         | Neto Vetorello    | O mito da vida TECPUC              |
| `cataratas`       | Lycio Esmanhoto   | Praça Rio Iguaçu                   |
| `casa_hoffman`    | Rimon Guimarães   | Casa Hoffman                       |
| `indios`          | Wes Gama          | O povo brasileiro - Tingui         |

As imagens estão em formato `.jpg`. O app também aceita `.png`.

> **Sem imagens:** o app funciona normalmente, exibindo o ícone SF Symbol `photo` como placeholder em cada célula e na tela de detalhes.

---

## Estrutura de Arquivos

```
GaleriaArtistas/
├── AppDelegate.swift
├── SceneDelegate.swift          ← ponto de entrada; monta o UINavigationController
├── ViewController.swift         ← arquivo do template (presente, mas não utilizado)
├── Models/
│   └── ObraDeArte.swift         ← struct + static let acervo
├── Controllers/
│   ├── GaleriaViewController.swift   ← grade + busca
│   └── DetalhesViewController.swift  ← detalhes + compartilhamento
└── Views/
    └── ObraCelula.swift         ← célula customizada
```

---

## Funcionalidades

- **Grade responsiva:** 2 colunas (iPhone retrato) / 3 colunas (iPhone paisagem e iPad)
- **Busca em tempo real** por título ou nome do artista via `UISearchController`
- **Tela de detalhes** com imagem ampliada, todas as informações da obra (título, artista, ano, estilo e descrição) e botão de compartilhamento
- **Animação de toque:** escala suave ao pressionar uma célula via `isHighlighted`
- **Compartilhamento:** texto com título, artista e convite via `UIActivityViewController`
- **Dark Mode:** totalmente compatível via semantic colors

---

## Requisitos

- iOS 16+
- Xcode 15+
- Swift 5.9+
