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

struct ActivityCompleteModel : Hashable, Codable,Identifiable,Observable{
    var id = UUID()
    var owner : UserModel
    var usersOfthisActivity : [UserModel] = []
    var groupsOfthisActivity : [GroupModel] = []
    var images : [String] = []
    var reactions : [ReactionModel] = []
    var comments : [CommentModel] = []
    var activity : ActivityModel?
    var numberOfReactions : Int = 0
    var thisUserReacted : Bool = false
}
