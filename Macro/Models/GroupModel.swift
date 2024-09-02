//
//  GroupModel.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation

struct GroupModel:  Codable, Hashable, Identifiable{
    var id : String?
    var idUser : String?
    var title : String?
    var description : String?
    var startDate : Date?
    var endDate : Date?
    var scoreType : String?
    var groupImage : String?
    var invitationCode : String?
}
