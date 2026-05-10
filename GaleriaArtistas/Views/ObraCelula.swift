// ObraCelula.swift
// GaleriaArtistas
//
// Célula customizada para exibição das obras na grade da galeria.

import UIKit

/// Célula que exibe a imagem, título e nome do artista de uma obra de arte.
final class ObraCelula: UICollectionViewCell {

    // MARK: - Reutilização

    static let identificador = "CelulaObraGaleria"

    // MARK: - Subviews

    /// Contêiner com sombra e cantos arredondados que emula uma moldura.
    private let moldura: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 14
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.13
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        v.layer.shadowRadius = 7
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    /// Área de exibição da imagem da obra.
    private let tela: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.backgroundColor = .systemGray5
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    /// Rótulo do título da obra.
    private let rotuloTitulo: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 13, weight: .semibold)
        lb.textColor = .label
        lb.numberOfLines = 2
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    /// Rótulo do nome do artista.
    private let rotuloArtista: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 11, weight: .regular)
        lb.textColor = .secondaryLabel
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        montarHierarquia()
        aplicarRestricoes()
    }

    required init?(coder: NSCoder) {
        fatalError("ObraCelula não suporta inicialização via Interface Builder.")
    }

    // MARK: - Hierarquia e Constraints

    private func montarHierarquia() {
        contentView.addSubview(moldura)
        moldura.addSubview(tela)
        moldura.addSubview(rotuloTitulo)
        moldura.addSubview(rotuloArtista)
    }

    private func aplicarRestricoes() {
        NSLayoutConstraint.activate([
            // Moldura ocupa toda a célula
            moldura.topAnchor.constraint(equalTo: contentView.topAnchor),
            moldura.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moldura.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moldura.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // Imagem ocupa ~63% da altura da moldura
            tela.topAnchor.constraint(equalTo: moldura.topAnchor),
            tela.leadingAnchor.constraint(equalTo: moldura.leadingAnchor),
            tela.trailingAnchor.constraint(equalTo: moldura.trailingAnchor),
            tela.heightAnchor.constraint(equalTo: moldura.heightAnchor, multiplier: 0.63),

            // Título abaixo da imagem
            rotuloTitulo.topAnchor.constraint(equalTo: tela.bottomAnchor, constant: 8),
            rotuloTitulo.leadingAnchor.constraint(equalTo: moldura.leadingAnchor, constant: 9),
            rotuloTitulo.trailingAnchor.constraint(equalTo: moldura.trailingAnchor, constant: -9),

            // Artista abaixo do título
            rotuloArtista.topAnchor.constraint(equalTo: rotuloTitulo.bottomAnchor, constant: 3),
            rotuloArtista.leadingAnchor.constraint(equalTo: moldura.leadingAnchor, constant: 9),
            rotuloArtista.trailingAnchor.constraint(equalTo: moldura.trailingAnchor, constant: -9),
        ])
    }

    // MARK: - Preenchimento

    /// Configura a célula com os dados de uma obra.
    func preencher(com obra: ObraDeArte) {
        rotuloTitulo.text = obra.titulo
        rotuloArtista.text = obra.artista

        // Usa placeholder SF Symbol caso a imagem não esteja no catálogo de assets
        if let imagemCatalogo = UIImage(named: obra.imagemNome) {
            tela.image = imagemCatalogo
            tela.contentMode = .scaleAspectFill
        } else {
            tela.image = UIImage(systemName: "photo.artframe")
            tela.contentMode = .scaleAspectFit
        }
    }

    // MARK: - Animação de Toque

    /// Escala a célula suavemente quando pressionada, dando feedback visual imediato.
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: 0.18,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: [.allowUserInteraction, .beginFromCurrentState]
            ) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.94, y: 0.94)
                    : .identity
                self.moldura.layer.shadowOpacity = self.isHighlighted ? 0.05 : 0.13
            }
        }
    }

    // MARK: - Reutilização

    override func prepareForReuse() {
        super.prepareForReuse()
        tela.image = nil
        rotuloTitulo.text = nil
        rotuloArtista.text = nil
        transform = .identity
    }
}
