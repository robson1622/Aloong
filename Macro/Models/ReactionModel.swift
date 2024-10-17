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
    
    func create()async -> ReactionModel?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .reaction){
            var new = self
            new.id = idServer
            _ = await new.update()
            return new
        }
        return nil
    }
    
    func update() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.update(model: self, id: self.id!, table: .reaction)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityUserModel/update")
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.delete(id: self.id!, table: .reaction)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityUserModel/delete")
        }
        return nil
    }
    
    func read() async -> ReactionModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .reaction)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityUserModel/read")
        }
        return nil
    }
}
