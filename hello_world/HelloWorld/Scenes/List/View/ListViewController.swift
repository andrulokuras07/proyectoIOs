//
//  ListViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 15/04/26.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // MARK: - Componentes visuales
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Bienvenid@ \(UserDefaults.standard.string(forKey: "userName") ?? "Visitante")"
    }
}
