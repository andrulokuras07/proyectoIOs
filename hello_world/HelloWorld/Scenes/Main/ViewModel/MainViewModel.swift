//
//  MainViewModel.swift
//  HelloWorld
//
//  Created by Alumnos on 20/03/26.
//

import Combine

class MainViewModel {
    var model = MainModel()
    
    @Published var isValidForm: Bool = false
    @Published var userNameError: String = ""
    @Published var passwordError: String = ""

    
    var user: User {
        get { // do something
            return model.user
        }
        set { // var newValue: User
            model.user = newValue
        }
    }
    
    func validateForm() {
        
        if (user.userName.isEmpty){
            userNameError = "Please enter a username"
        } else {
            userNameError = ""
        }
        
        if (user.password.isEmpty){
            passwordError = "Please enter a valid password"
        } else {
            passwordError = ""
        }
        
        print("User \(user)")
        isValidForm = !(user.userName.isEmpty || user.password.isEmpty)
        print("isValid: \(isValidForm)")
    }
    
}
