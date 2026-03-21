//
//  ViewController.swift
//  hello_world
//
//  Created by Alumnos on 18/03/26.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    // MARK: - Componentes visuales
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: - Partes Privadas
    private let viewModel = MainViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        // Fin ocultar teclado
        
        tfUser.delegate = self
        tfPass.delegate = self
        
        viewModel.$isValidForm
            .sink { [weak self] isValid in
                guard let self else { return }
                self.btnLogin.isEnabled = isValid
            }
            .store(in: &cancellable)
    }
    
    @IBAction func loginTapped() {
        guard let navigationController = navigationController else { return }
        let storyboardName = "Main"
        let id = "Second"
        let secondVC = UIStoryboard(
            name: storyboardName,
            bundle: nil
        ).instantiateViewController(
            identifier: id
        ) { coder in
            return UIViewController(coder: coder) // init()
        }
        
        navigationController.pushViewController(secondVC, animated: true)
        // navigationController.present(secondVC, animates: true)
        
    }


}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString
        string: String) -> Bool {
        // Calculamos el texto
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: currentText)
        if tfUser == textField {
            viewModel.user.userName = updatedText
        }
        else if tfPass == textField {
            viewModel.user.password = updatedText
        }
        viewModel.validateForm()
        return true
    }
}

