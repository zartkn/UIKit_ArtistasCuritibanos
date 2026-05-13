//
//  SceneDelegate.swift
//  GaleriaArtistas
//
//  Created by user282135 on 5/13/26.
//

import UIKit // <-- ISSO É O MAIS IMPORTANTE

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Criamos o navegador começando pela nossa Galeria
        let galeriaVC = GaleriaViewController()
        let navigation = UINavigationController(rootViewController: galeriaVC)
        
        window.rootViewController = navigation
        self.window = window
        window.makeKeyAndVisible()
    }
}
