//
//  ActivityCompleteModel.swift
//  Macro
//
//  Created by Robson Borges on 05/09/24.
//

import Foundation



struct ActivityCompleteModel : Hashable, Codable{
    var id : String?
    var user : UserModel?
    var group : GroupModel?
    var activity : ActivityModel?
}
