//
//  MainViewModel.swift
//  hello_world
//
//  Created by Alumnos on 20/03/26.
//

import Combine

class MainViewModel {
    
    var model = MainModel()
    // Es un observable
    @Published var isValidForm: Bool = false
    var user: User {
        get {
            // do something
            return model.user
        }
        set { // var newValue: User
            model.user = newValue
        }
    }
    
    func validateForm() {
        print("User \(user)")
        isValidForm = !(user.userName.isEmpty || user.password.isEmpty)
        print("isValid: \(isValidForm)")
    }
}

