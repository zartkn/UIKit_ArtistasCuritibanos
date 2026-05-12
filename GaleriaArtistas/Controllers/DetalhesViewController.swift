// DetalhesViewController.swift
// GaleriaArtistas
//
// Tela de detalhes de uma obra: imagem ampliada, metadados, descrição e compartilhamento.

import UIKit

final class DetalhesViewController: UIViewController {

    // MARK: - Dados

    /// Obra de arte exibida nesta tela.
    private let registro: ObraDeArte

    // MARK: - Elementos de UI

    private let rolagem: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never  // controlamos manualmente os insets
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    /// Imagem da obra em destaque, com fundo escuro para contraste.
    private let telaObra: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor(white: 0.07, alpha: 1)
        iv.clipsToBounds = true
        iv.tintColor = .systemGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    /// Painel branco com cantos arredondados que sobrepõe levemente a imagem.
    private let painelInfo: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 22
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let rotuloTituloObra: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 24, weight: .bold)
        lb.textColor = .label
        lb.numberOfLines = 0
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    private let rotuloNomeArtista: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 17, weight: .semibold)
        lb.textColor = .systemIndigo
        lb.numberOfLines = 0   // suporta nomes longos sem truncar
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    /// Linha separadora entre o cabeçalho e as fichas de metadados.
    private let linhaDiv: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    /// Stack horizontal com fichas de metadados (Ano e Estilo).
    private let pilhaMeta: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    /// Texto descritivo da obra/artista.
    private let rotuloDescricao: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.textColor = .label
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    /// Botão de compartilhamento via UIActivityViewController.
    private lazy var botaoCompartilhar: UIButton = {
        var cfg = UIButton.Configuration.filled()
        cfg.title = "Compartilhar obra"
        cfg.image = UIImage(systemName: "square.and.arrow.up")
        cfg.imagePadding = 8
        cfg.baseBackgroundColor = .systemIndigo
        cfg.baseForegroundColor = .white
        cfg.cornerStyle = .large
        cfg.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 0)

        let btn = UIButton(configuration: cfg)
        btn.addTarget(self, action: #selector(acionarCompartilhamento), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init

    init(obra: ObraDeArte) {
        self.registro = obra
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("DetalhesViewController não suporta inicialização via coder.")
    }

    // MARK: - Ciclo de Vida

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarNavegacao()
        montarHierarquia()
        aplicarRestricoes()
        preencherConteudo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Tint branco enquanto esta tela está visível (fundo escuro da imagem).
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Restaura o tint padrão ao sair, evitando que o botão de voltar
        // fique branco/invisível na tela da galeria após a navegação de volta.
        navigationController?.navigationBar.tintColor = .systemIndigo
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ajusta o inset inferior do scroll para que o botão de compartilhamento
        // fique sempre visível acima do home indicator.
        //
        // Por que aqui e não em viewDidLoad:
        //   view.safeAreaInsets ainda é zero durante viewDidLoad (view fora da janela).
        //   viewDidLayoutSubviews é chamado após a view entrar na janela, com insets reais.
        //
        // Por que contentInset e não uma constraint greaterThanOrEqual:
        //   painelInfo.bottom == rolagem.bottom == view.bottom (igualdade).
        //   A desigualdade nunca vence a igualdade que já a satisfaz — a única forma
        //   de empurrar o conteúdo acima do home indicator é via contentInset.bottom,
        //   que aumenta o espaço rolável sem deslocar nenhuma view.
        let insetNecessario = view.safeAreaInsets.bottom + 16
        guard rolagem.contentInset.bottom != insetNecessario else { return }
        rolagem.contentInset.bottom = insetNecessario
    }

    // MARK: - Configuração

    private func configurarNavegacao() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = UIColor(white: 0.07, alpha: 1)

        // Barra de navegação transparente escopada a esta tela via navigationItem.
        // Usar navigationItem (não navigationController) garante que a aparência
        // só se aplique aqui e não vaze para outras telas da pilha.
        let aparenciaTransp = UINavigationBarAppearance()
        aparenciaTransp.configureWithTransparentBackground()

        // Configura a cor do botão de voltar dentro desta aparência local
        let aparenciaBotao = UIBarButtonItemAppearance()
        aparenciaBotao.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        aparenciaTransp.buttonAppearance = aparenciaBotao
        aparenciaTransp.backButtonAppearance = aparenciaBotao

        navigationItem.standardAppearance = aparenciaTransp
        navigationItem.scrollEdgeAppearance = aparenciaTransp
    }

    private func montarHierarquia() {
        view.addSubview(rolagem)
        rolagem.addSubview(telaObra)
        rolagem.addSubview(painelInfo)

        painelInfo.addSubview(rotuloTituloObra)
        painelInfo.addSubview(rotuloNomeArtista)
        painelInfo.addSubview(linhaDiv)
        painelInfo.addSubview(pilhaMeta)
        painelInfo.addSubview(rotuloDescricao)
        painelInfo.addSubview(botaoCompartilhar)

        // Montagem das fichas de metadados
        let fichaAno    = montarFicha(icone: "calendar",   titulo: "Ano",   valor: "\(registro.ano)")
        let fichaEstilo = montarFicha(icone: "paintbrush", titulo: "Estilo", valor: registro.estilo)
        pilhaMeta.addArrangedSubview(fichaAno)
        pilhaMeta.addArrangedSubview(fichaEstilo)
    }

    private func aplicarRestricoes() {
        NSLayoutConstraint.activate([
            // ScrollView preenche a tela toda
            rolagem.topAnchor.constraint(equalTo: view.topAnchor),
            rolagem.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rolagem.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rolagem.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Imagem: 44% da altura da tela
            telaObra.topAnchor.constraint(equalTo: rolagem.topAnchor),
            telaObra.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            telaObra.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            telaObra.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.44),

            // Painel sobrepõe 22 pt da parte inferior da imagem
            painelInfo.topAnchor.constraint(equalTo: telaObra.bottomAnchor, constant: -22),
            painelInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            painelInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            painelInfo.bottomAnchor.constraint(equalTo: rolagem.bottomAnchor),

            // Título
            rotuloTituloObra.topAnchor.constraint(equalTo: painelInfo.topAnchor, constant: 28),
            rotuloTituloObra.leadingAnchor.constraint(equalTo: painelInfo.leadingAnchor, constant: 22),
            rotuloTituloObra.trailingAnchor.constraint(equalTo: painelInfo.trailingAnchor, constant: -22),

            // Artista
            rotuloNomeArtista.topAnchor.constraint(equalTo: rotuloTituloObra.bottomAnchor, constant: 5),
            rotuloNomeArtista.leadingAnchor.constraint(equalTo: painelInfo.leadingAnchor, constant: 22),
            rotuloNomeArtista.trailingAnchor.constraint(equalTo: painelInfo.trailingAnchor, constant: -22),

            // Linha separadora
            linhaDiv.topAnchor.constraint(equalTo: rotuloNomeArtista.bottomAnchor, constant: 18),
            linhaDiv.leadingAnchor.constraint(equalTo: painelInfo.leadingAnchor, constant: 22),
            linhaDiv.trailingAnchor.constraint(equalTo: painelInfo.trailingAnchor, constant: -22),
            linhaDiv.heightAnchor.constraint(equalToConstant: 0.5),

            // Fichas de metadados
            pilhaMeta.topAnchor.constraint(equalTo: linhaDiv.bottomAnchor, constant: 16),
            pilhaMeta.leadingAnchor.constraint(equalTo: painelInfo.leadingAnchor, constant: 22),
            pilhaMeta.trailingAnchor.constraint(equalTo: painelInfo.trailingAnchor, constant: -22),

            // Descrição
            rotuloDescricao.topAnchor.constraint(equalTo: pilhaMeta.bottomAnchor, constant: 20),
            rotuloDescricao.leadingAnchor.constraint(equalTo: painelInfo.leadingAnchor, constant: 22),
            rotuloDescricao.trailingAnchor.constraint(equalTo: painelInfo.trailingAnchor, constant: -22),

            // Botão de compartilhamento.
            // A margem inferior real (acima do home indicator) é garantida pelo
            // contentInset.bottom definido em viewDidLayoutSubviews.
            botaoCompartilhar.topAnchor.constraint(equalTo: rotuloDescricao.bottomAnchor, constant: 30),
            botaoCompartilhar.leadingAnchor.constraint(equalTo: painelInfo.leadingAnchor, constant: 22),
            botaoCompartilhar.trailingAnchor.constraint(equalTo: painelInfo.trailingAnchor, constant: -22),
            botaoCompartilhar.bottomAnchor.constraint(equalTo: painelInfo.bottomAnchor, constant: -16),
        ])
    }

    private func preencherConteudo() {
        rotuloTituloObra.text = registro.titulo
        rotuloNomeArtista.text = registro.artista
        rotuloDescricao.text = registro.descricao

        if let img = UIImage(named: registro.imagemNome) {
            telaObra.image = img
            telaObra.contentMode = .scaleAspectFit
        } else {
            telaObra.image = UIImage(systemName: "photo.artframe")
            telaObra.contentMode = .scaleAspectFit
        }
    }

    // MARK: - Ficha de Metadado

    /**
     Cria um card compacto com ícone SF Symbol, rótulo e valor.

     - Parameters:
       - icone: Nome do SF Symbol a usar.
       - titulo: Rótulo da ficha (ex.: "Ano").
       - valor: Valor da ficha (ex.: "2017").
     - Returns: `UIView` configurada e pronta para uso.
     */
    private func montarFicha(icone: String, titulo: String, valor: String) -> UIView {
        let caixa = UIView()
        caixa.backgroundColor = .secondarySystemBackground
        caixa.layer.cornerRadius = 12
        caixa.translatesAutoresizingMaskIntoConstraints = false

        let imgIcone = UIImageView(image: UIImage(systemName: icone))
        imgIcone.tintColor = .systemIndigo
        imgIcone.translatesAutoresizingMaskIntoConstraints = false

        let lbTitulo = UILabel()
        lbTitulo.text = titulo
        lbTitulo.font = .systemFont(ofSize: 11, weight: .medium)
        lbTitulo.textColor = .secondaryLabel
        lbTitulo.translatesAutoresizingMaskIntoConstraints = false

        let lbValor = UILabel()
        lbValor.text = valor
        lbValor.font = .systemFont(ofSize: 14, weight: .semibold)
        lbValor.textColor = .label
        lbValor.numberOfLines = 2
        lbValor.adjustsFontSizeToFitWidth = true
        lbValor.minimumScaleFactor = 0.75
        lbValor.translatesAutoresizingMaskIntoConstraints = false

        caixa.addSubview(imgIcone)
        caixa.addSubview(lbTitulo)
        caixa.addSubview(lbValor)

        NSLayoutConstraint.activate([
            imgIcone.topAnchor.constraint(equalTo: caixa.topAnchor, constant: 12),
            imgIcone.leadingAnchor.constraint(equalTo: caixa.leadingAnchor, constant: 12),
            imgIcone.widthAnchor.constraint(equalToConstant: 20),
            imgIcone.heightAnchor.constraint(equalToConstant: 20),

            lbTitulo.topAnchor.constraint(equalTo: imgIcone.bottomAnchor, constant: 6),
            lbTitulo.leadingAnchor.constraint(equalTo: caixa.leadingAnchor, constant: 12),
            lbTitulo.trailingAnchor.constraint(equalTo: caixa.trailingAnchor, constant: -12),

            lbValor.topAnchor.constraint(equalTo: lbTitulo.bottomAnchor, constant: 2),
            lbValor.leadingAnchor.constraint(equalTo: caixa.leadingAnchor, constant: 12),
            lbValor.trailingAnchor.constraint(equalTo: caixa.trailingAnchor, constant: -12),
            lbValor.bottomAnchor.constraint(equalTo: caixa.bottomAnchor, constant: -12),
        ])

        return caixa
    }

    // MARK: - Ações

    /// Abre o painel de compartilhamento nativo com título, artista e convite.
    @objc private func acionarCompartilhamento() {
        let conteudo = """
        🎨 "\(registro.titulo)" — \(registro.artista) (\(registro.ano))
        Venha conhecer mais artistas curitibanos e a rica produção cultural do Paraná!
        """

        let painel = UIActivityViewController(
            activityItems: [conteudo],
            applicationActivities: nil
        )

        // Em iPad, UIActivityViewController precisa de um popover anchor
        if let popover = painel.popoverPresentationController {
            popover.sourceView = botaoCompartilhar
            popover.sourceRect = botaoCompartilhar.bounds
        }

        present(painel, animated: true)
    }
}
