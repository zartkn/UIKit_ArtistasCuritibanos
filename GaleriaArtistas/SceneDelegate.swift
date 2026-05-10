// SceneDelegate.swift
// GaleriaArtistas
//
// Ponto de entrada da cena: monta a hierarquia de view controllers sem Storyboard.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let cenaJanela = scene as? UIWindowScene else { return }

        // Cria a janela principal e define o GaleriaViewController como raiz
        let janela = UIWindow(windowScene: cenaJanela)
        let galeria = GaleriaViewController()
        let navegador = UINavigationController(rootViewController: galeria)
        janela.rootViewController = navegador
        janela.makeKeyAndVisible()
        self.window = janela
    }
}
