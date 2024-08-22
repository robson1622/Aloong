//
//  ViewsController.swift
//  Macro Challenge
//
//  Created by Robson Borges on 06/08/24.
//

import Foundation
import SwiftUI


class ViewsController : ObservableObject{
    static var shared = ViewsController()
    
    public enum Destination : Codable, Hashable{
        //user
        case user(UserModel)
        case createUser(String)
        case challengers
        case myProfile
        //group
        case group(GroupModel)
        case createGroup
        case editGroup(GroupModel)
        //geral
        case home
        case signIn
    }
    
//    public var tab :
    @Published var navPath = NavigationPath()
    
    func back(){
        navPath.removeLast()
    }
    
    func navigateTo(to : Destination,reset : Bool = false){
        
        if(reset){
            navPath.removeLast(navPath.count)
        }
        navPath.append(to)
    }
}
