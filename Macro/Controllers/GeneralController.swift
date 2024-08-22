//
//  HomeController.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import Foundation


class GeneralController: ObservableObject{
    @Published var user : UserController = UserController()
    @Published var group : GroupController = GroupController()
    @Published var satistic : StatisticController = StatisticController()
    
    func updateAll(){
        
    }
    
    func updateUser(){
        
    }
    
    func updateGroups(){
        
    }
    
}
