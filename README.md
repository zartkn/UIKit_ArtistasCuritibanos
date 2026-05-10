# Galeria de Artistas Curitibanos — iOS App

Projeto desenvolvido para a disciplina de **Mobile Development: iOS**, com o objetivo de criar uma aplicação mobile (com UIKit) chamada Galeria de Artistas Curitibanos, utilizando UICollectionView, navegação entre telas e componentes nativos do iOS. O trabalho apresenta obras de artistas ligados à cidade de Curitiba, permitindo visualizar detalhes das obras, realizar pesquisas por artista ou título e compartilhar conteúdos, aplicando conceitos de UIKit, Swift, responsividade de interface e boas práticas de desenvolvimento mobile.

---

## Integrantes

- Adrian Antonio de Souza Gomes
- Edmund Soares de Sousa
- Lucas Azzolin Haubmann
- Vinicius Lima Teider


## Como abrir no Xcode

1. Abra o **Xcode** .
2. Escolha **File › New › Project…**
3. Selecione **App** (iOS) e configure:
   - **Product Name:** `GaleriaArtistas`
   - **Interface:** `Storyboard` *(o storyboard será removido em seguida)*
   - **Language:** `Swift`
4. Após criar o projeto, **exclua** os arquivos gerados automaticamente:
   - `Main.storyboard`
   - `ViewController.swift`
5. **Copie** os arquivos Swift desta pasta para dentro do projeto, mantendo a estrutura de grupos:
   - `Models/ObraDeArte.swift`
   - `Controllers/GaleriaViewController.swift`
   - `Controllers/DetalhesViewController.swift`
   - `Views/ObraCelula.swift`
   - `AppDelegate.swift` *(substitui o gerado)*
   - `SceneDelegate.swift` *(substitui o gerado)*
6. Em **Info.plist**, remova a chave `UIMainStoryboardFile`.
7. Em **Build Settings**, confirme que `SWIFT_VERSION = 5.9` ou superior.

---

## Imagens do Projeto - Adicionando as imagens ao Assets.xcassets

As imagens utilizadas no aplicativo estão disponíveis na pasta `Imagens`, já organizadas e prontas para utilização no projeto. Para que o aplicativo funcione corretamente, basta copiar os arquivos da pasta para o catálogo de assets (`Assets.xcassets`) no Xcode (o app referencia as seguintes imagens no catálogo de assets).
O conjunto de imagens foi pensado para representar diferentes formas de expressão artística presentes em Curitiba, com foco em artes urbanas, grafites e manifestações culturais de rua. Além de enriquecer visualmente o aplicativo, as obras ajudam a destacar a importância da arte urbana como forma de identidade cultural, comunicação social e valorização dos espaços públicos da cidade. 

| Nome no catálogo       | Artista              | Obra                              |
|------------------------|----------------------|-----------------------------------|
| `povo_livre`           | Michel Devis         | Marechal Floriano                 |
| `mafiosos`             | Gardpam              | Hospital Hélio Anjos Ortiz        |
| `cwbsiria`             | Cosmic Boys          | Damasco na Siria                  |
| `paulo_leminski`       | João Marcos          | Galeria Julio Moreira             |
| `tec_puc`              | Neto Vetorello       | O mito da vida TECPUC             |
| `cataratas`            | Lycio Esmanhoto      | Praça Rio Iguaçu                  |
| `casa_hoffman`         | Rimon Guimarães      | Fundação Cultural de Curitiba     |
| `indios`               | Wes Gama             | O povo brasileiro - Tingui        |

As imagens disponibilizadas estão em formato `.jpg`, porém o aplicativo também oferece suporte para arquivos `.png`, caso seja desejado utilizar outras obras futuramente.
> **Sem imagens:** o app funciona normalmente com o ícone SF Symbol `photo.artframe` como placeholder.

---

## Estrutura de arquivos

```
GaleriaArtistas/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Models/
│   └── ObraDeArte.swift          ← struct + acervo inicial
├── Controllers/
│   ├── GaleriaViewController.swift  ← grade + busca
│   └── DetalhesViewController.swift ← detalhes + compartilhamento
└── Views/
    └── ObraCelula.swift          ← célula customizada
```

---

## Funcionalidades

- **Grade responsiva:** 2 colunas (iPhone retrato) / 3 colunas (iPhone paisagem e iPad)
- **Busca em tempo real** por título ou nome do artista
- **Tela de detalhes** com imagem ampliada, fichas de Ano/Estilo, descrição e botão de compartilhamento
- **Animações:** escala ao tocar na célula + fade/translação ao rolar a grade
- **Compartilhamento:** texto com título, artista e convite via `UIActivityViewController`
- **Dark Mode:** totalmente compatível via semantic colors

---

## Requisitos

- iOS 16+
- Xcode 15+
- Swift 5.9+
