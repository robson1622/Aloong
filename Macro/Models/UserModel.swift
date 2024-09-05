//
//  UserModel.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import Foundation


struct UserModel:  Codable, Hashable{
    var id : String?
    var nickname : String?
    var name : String?
    var birthdate : Date?
    var email : String?
    var userimage : String?
}
