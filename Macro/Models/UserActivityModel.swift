//
//  UserActivityModel.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import Foundation



struct UserActivityModel: Codable, Hashable{
    var id : String?
    var idUser : String
    var idActivity : String
    var state : String
}
