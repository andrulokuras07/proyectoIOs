//
//  SceneDelegate.swift
//  HelloWorld
//
//  Created by Alumnos on 18/03/26.
//

// DESCRIPCIÓN: Delegado de UIWindowScene. La ventana se inicializa desde Main.storyboard.
// Los métodos de ciclo de vida están vacíos (sin lógica custom).

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}

}

