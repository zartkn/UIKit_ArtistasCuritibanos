//
//  DetalhesViewController.swift
//  GaleriaArtistas
//
//  Created by user282135 on 5/13/26.
//

import UIKit

class DetalhesViewController: UIViewController {
    let obra: ObraDeArte
    
    init(obra: ObraDeArte) {
        self.obra = obra
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        setupUI()
        setupShareButton()
    }
    
    private func setupShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(compartilhar))
    }
    
    @objc private func compartilhar() {
        let texto = "🎨 Confira a obra '\(obra.titulo)' do artista \(obra.artista). Venha conhecer mais artistas curitibanos!"
        let activity = UIActivityViewController(activityItems: [texto], applicationActivities: nil)
        // Em iPad o UIActivityViewController exige um popover anchor — sem isso o app crasha.
        if let popover = activity.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(activity, animated: true)
    }
    
    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        
        let iv = UIImageView(image: UIImage(named: obra.imagemNome) ?? UIImage(systemName: "photo"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let lbDesc = UILabel()
        lbDesc.numberOfLines = 0
        lbDesc.text = """
        Título: \(obra.titulo)
        Artista: \(obra.artista)
        Ano: \(obra.ano)
        Estilo: \(obra.estilo)
        
        Descrição:
        \(obra.descricao)
        """
        lbDesc.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(content)
        content.addSubview(iv)
        content.addSubview(lbDesc)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            content.topAnchor.constraint(equalTo: scrollView.topAnchor),
            content.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            iv.topAnchor.constraint(equalTo: content.topAnchor, constant: 20),
            iv.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            iv.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            iv.heightAnchor.constraint(equalToConstant: 300),
            
            lbDesc.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 20),
            lbDesc.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            lbDesc.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            lbDesc.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -20)
        ])
    }
}