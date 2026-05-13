//
//  GaleriaViewController.swift
//  GaleriaArtistas
//
//  Created by user282135 on 5/13/26.
//

import UIKit

class GaleriaViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var todasAsObras = ObraDeArte.acervo
    private var obrasFiltradas: [ObraDeArte] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Artistas Curitibanos"
        navigationController?.navigationBar.prefersLargeTitles = true
        obrasFiltradas = todasAsObras
        setupSearch()
        setupCollectionView()
    }
    
    private func setupSearch() {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Buscar artista ou obra..."
        navigationItem.searchController = sc
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(ObraCelula.self, forCellWithReuseIdentifier: ObraCelula.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
}

// MARK: - Layout Responsivo (iPad e iPhone)
extension GaleriaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let larguraDaTela = view.bounds.width
        let colunas: CGFloat = larguraDaTela > 600 ? 3 : 2 // 3 colunas no iPad/Landscape, 2 no iPhone
        let larguraItem = (larguraDaTela - (colunas + 1) * 15) / colunas
        return CGSize(width: larguraItem, height: larguraItem * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

extension GaleriaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return obrasFiltradas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ObraCelula.identifier, for: indexPath) as! ObraCelula
        cell.configure(with: obrasFiltradas[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetalhesViewController(obra: obrasFiltradas[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Lógica de Pesquisa
extension GaleriaViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let texto = searchController.searchBar.text?.lowercased(), !texto.isEmpty else {
            obrasFiltradas = todasAsObras
            collectionView.reloadData()
            return
        }
        obrasFiltradas = todasAsObras.filter { $0.titulo.lowercased().contains(texto) || $0.artista.lowercased().contains(texto) }
        collectionView.reloadData()
    }
}
