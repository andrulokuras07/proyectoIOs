//
//  ViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 18/03/26.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    // MARK: - Componenetes visuales
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblUserError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    // MARK: - Propiedades privadas
    private let viewModel = MainViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: -  Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        // Fin ocultar teclado
        
        tfUser.delegate = self
        tfPassword.delegate = self
        
        viewModel.$isValidForm
            .sink { [weak self] isValid in
                guard let self else { return }
                self.btnLogin.isEnabled = isValid
            }
            .store(in: &cancellable)
        
        viewModel.$passwordError
            .sink { [weak self] error in
                guard let self else { return }
                let showError = !error.isEmpty
                self.lblPasswordError.text = error
                self.setErrorBorder(for: tfPassword, show: showError)
            }
            .store(in: &cancellable)
        
        viewModel.$userNameError
            .sink { [weak self] error in
                guard let self else { return }
                let showError = !error.isEmpty
                self.lblUserError.text = error
                self.setErrorBorder(for: tfUser, show: showError)
            }
            .store(in: &cancellable)
    }
    
    @IBAction func loginTapped() {
        guard let navigationController = navigationController else { return }
        let storyboard = "Main"
        let id = "Home"
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "userName") ?? ""
        let password = defaults.string(forKey: "password") ?? ""
        
        let SecondVC = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(identifier: id) {
            coder in
            self.viewModel.user.name = "Alexander Riggs Zermeño"
            let model = HomeModel(user: self.viewModel.user)
            let viewModel = HomeViewModel(model: model)
            return HomeViewController(coder: coder, viewModel: viewModel) // init()
        }
        
        if viewModel.user.userName == userName && viewModel.user.password == password {
            navigationController.pushViewController(SecondVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid credentials", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    // Ocultar teclado al presionar return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField:UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        if tfUser == textField {
            viewModel.user.userName = updatedText
        }
        else if tfPassword == textField {
            viewModel.user.password = updatedText
        }
        viewModel.validateForm()
        
        return true
    }
    
    func setErrorBorder(for textField:UITextField, show: Bool) {
        if show {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
        } else {
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0.0
        }
    }
    
}
