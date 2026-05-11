// GaleriaViewController.swift
// GaleriaArtistas
//
// Controlador principal: exibe a grade de obras e gerencia a busca por título/artista.

import UIKit

final class GaleriaViewController: UIViewController {

    // MARK: - Estado

    /// Conjunto completo de obras carregado na inicialização.
    private var acervoCompleto: [ObraDeArte] = ObraDeArte.acervoInicial

    /// Subconjunto exibido na grade; pode ser filtrado pela busca.
    private var exibicaoAtual: [ObraDeArte] = []

    /// Inibe a animação de entrada das células durante atualizações da busca,
    /// evitando flicker a cada keystroke do usuário.
    private var suprimirAnimacaoEntrada = false

    // MARK: - Elementos de UI

    /// Grade principal que exibe as obras em layout de células.
    private lazy var galeriaView: UICollectionView = {
        let fluxo = UICollectionViewFlowLayout()
        fluxo.scrollDirection = .vertical
        fluxo.minimumLineSpacing = 16
        fluxo.minimumInteritemSpacing = 12
        fluxo.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 24, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: fluxo)
        cv.backgroundColor = .systemGroupedBackground
        cv.register(ObraCelula.self, forCellWithReuseIdentifier: ObraCelula.identificador)
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.keyboardDismissMode = .onDrag
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    /// Barra de pesquisa para filtrar obras por título ou artista.
    private lazy var campoBusca: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar por título ou artista…"
        sb.delegate = self
        sb.searchBarStyle = .minimal
        sb.showsCancelButton = false
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    /// View exibida quando a busca não retorna resultados.
    private lazy var avisoVazio: UILabel = {
        let lb = UILabel()
        lb.text = "Nenhuma obra encontrada."
        lb.textColor = .secondaryLabel
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.textAlignment = .center
        lb.isHidden = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    // MARK: - Ciclo de Vida

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarNavegacao()
        montarHierarquia()
        aplicarRestricoes()
        exibicaoAtual = acervoCompleto
    }

    /// Invalida o layout ao girar o dispositivo para recalcular o tamanho das células.
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.galeriaView.collectionViewLayout.invalidateLayout()
        }
    }

    // MARK: - Configuração

    private func configurarNavegacao() {
        title = "Arte Curitibana"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo

        let aparencia = UINavigationBarAppearance()
        aparencia.configureWithOpaqueBackground()
        aparencia.backgroundColor = .systemGroupedBackground
        aparencia.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = aparencia
        navigationController?.navigationBar.scrollEdgeAppearance = aparencia
    }

    private func montarHierarquia() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(campoBusca)
        view.addSubview(galeriaView)
        view.addSubview(avisoVazio)
    }

    private func aplicarRestricoes() {
        NSLayoutConstraint.activate([
            // Campo de busca ancorado ao topo da safe area
            campoBusca.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            campoBusca.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            campoBusca.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            // Grade ocupa o restante da tela
            galeriaView.topAnchor.constraint(equalTo: campoBusca.bottomAnchor, constant: 4),
            galeriaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galeriaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galeriaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Aviso de resultado vazio centralizado
            avisoVazio.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avisoVazio.centerYAnchor.constraint(equalTo: galeriaView.centerYAnchor),
        ])
    }

    // MARK: - Cálculo de Layout

    /**
     Calcula as dimensões das células de forma responsiva.

     - iPhone retrato: 2 colunas
     - iPhone paisagem / iPad: 3 colunas
     */
    private func dimensaoCelula(larguraTela: CGFloat) -> CGSize {
        let margens: CGFloat = 16 * 2          // insets laterais
        let espacamento: CGFloat = 12          // espaço entre células

        let ehPad = UIDevice.current.userInterfaceIdiom == .pad
        let ehLandscape = larguraTela > 600

        let qtdColunas: CGFloat = (ehPad || ehLandscape) ? 3 : 2

        let largura = (larguraTela - margens - espacamento * (qtdColunas - 1)) / qtdColunas
        let altura = largura * 1.48            // proporção ligeiramente retrato

        return CGSize(width: largura, height: altura)
    }

    // MARK: - Atualização da Grade

    private func atualizarExibicao(termo: String) {
        let termoBusca = termo.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if termoBusca.isEmpty {
            exibicaoAtual = acervoCompleto
        } else {
            exibicaoAtual = acervoCompleto.filter {
                $0.titulo.lowercased().contains(termoBusca) ||
                $0.artista.lowercased().contains(termoBusca)
            }
        }

        avisoVazio.isHidden = !exibicaoAtual.isEmpty

        // Suprime a animação de entrada durante atualizações da busca para evitar
        // flicker a cada caractere digitado — reativa logo após o reloadData.
        suprimirAnimacaoEntrada = true
        galeriaView.reloadData()
        suprimirAnimacaoEntrada = false
    }
}

// MARK: - UICollectionViewDataSource

extension GaleriaViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        exibicaoAtual.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let celula = collectionView.dequeueReusableCell(
            withReuseIdentifier: ObraCelula.identificador,
            for: indexPath
        ) as? ObraCelula else {
            return UICollectionViewCell()
        }
        celula.preencher(com: exibicaoAtual[indexPath.item])
        return celula
    }
}

// MARK: - UICollectionViewDelegate

extension GaleriaViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let obraEscolhida = exibicaoAtual[indexPath.item]
        let telaDetalhes = DetalhesViewController(obra: obraEscolhida)
        navigationController?.pushViewController(telaDetalhes, animated: true)
    }

    /// Anima o aparecimento das células conforme o scroll (fade + translação vertical).
    /// A animação é inibida durante atualizações da busca para evitar flicker constante.
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard !suprimirAnimacaoEntrada else { return }

        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 18)
        UIView.animate(
            withDuration: 0.38,
            delay: Double(indexPath.item % 6) * 0.04,
            options: [.curveEaseOut]
        ) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GaleriaViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        dimensaoCelula(larguraTela: collectionView.bounds.width)
    }
}

// MARK: - UISearchBarDelegate

extension GaleriaViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        atualizarExibicao(termo: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        atualizarExibicao(termo: "")
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true {
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
}
