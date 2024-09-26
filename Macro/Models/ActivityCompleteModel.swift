//
//  ActivityCompleteModel.swift
//  Macro
//
//  Created by Robson Borges on 05/09/24.
//

import Foundation

struct GroupsAndActivitiesModel : Hashable, Codable, Identifiable{
    var id = UUID()
    var idGroups : String
    var activitiesComplete : [ActivityCompleteModel] = []
}

struct ActivityCompleteModel : Hashable, Codable,Identifiable{
    var id = UUID()
    var owner : UserModel
    var usersOfthisActivity : [UserModel] = []
    var groupsOfthisActivity : [GroupModel] = []
    var images : [String] = []
    var activity : ActivityModel?
}
