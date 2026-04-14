//
//  HomeViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 23/03/26.
//

import UIKit

class HomeViewController: UITabBarController {
    
    // MARK: - Componentes visuales
    private let viewmodel: HomeViewModel
    
    // MARK: - Componentes visuales
    init?(coder: NSCoder, viewModel: HomeViewModel) {
        self.viewmodel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("inir(coder:) has not been implemented")
    }
    
    // MARK: - Componentes visuales
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
