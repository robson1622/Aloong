//
//  ReactionModel.swift
//  Macro
//
//  Created by Robson Borges on 17/09/24.
//

import Foundation

struct ReactionModel : Codable, Hashable{
    var id : String?
    var idUser : String
    var idGroup : String
    var idActivity : String?
    var idComment : String?
    
    func create()async -> Bool?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .activityGroup){
            var new = self
            new.id = idServer
            return await new.update()
        }
        return nil
    }
    
    func update() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.update(model: self, id: self.id!, table: .activityUser)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityUserModel/update")
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.delete(id: self.id!, table: .activityUser)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityUserModel/delete")
        }
        return nil
    }
    
    func read() async -> ReactionModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .activityUser)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityUserModel/read")
        }
        return nil
    }
}
