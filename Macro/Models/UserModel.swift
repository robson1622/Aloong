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
    
    init(id: String? = nil, appleId: UUID? = nil, nickname: String? = nil, name: String? = nil, birthdate: Date? = nil, email: String? = nil, userimage: String? = nil) {
        self.id = id
        self.nickname = nickname
        self.name = name
        self.birthdate = birthdate
        self.email = email
        self.userimage = userimage
    }
}
