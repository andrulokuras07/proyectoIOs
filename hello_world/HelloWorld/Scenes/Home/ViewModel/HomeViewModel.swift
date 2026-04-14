//
//  HomeViewModel.swift
//  HelloWorld
//
//  Created by Alumnos on 23/03/26.
//


class HomeViewModel {
    
    var model: HomeModel
    
    init(model: HomeModel) {
        self.model = model
    }
    
    var user: User {
        get { model.user }
        set { model.user = newValue }
    }
    
    var name: String {
        user.name
    }
}
