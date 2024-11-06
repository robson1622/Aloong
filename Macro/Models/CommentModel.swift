//
//  CommentModel.swift
//  Macro
//
//  Created by Robson Borges on 17/09/24.
//

import Foundation

struct CommentModel : Codable, Hashable{
    var id : String?
    var idGroup : String
    var idUser : String
    var idActivity : String
    var date : Date
    var comment : String
    
    
    func create()async -> String?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .comment){
            var new = self
            new.id = idServer
            _ = await new.update()
            return idServer
        }
        return nil
    }
    
    func update() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.update(model: self, id: self.id!, table: .comment)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - UserModel/update")
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.delete(id: self.id!, table: .comment)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - UserModel/delete")
        }
        return nil
    }
    
    func read() async -> CommentModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .comment)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - UserModel/read")
        }
        return nil
    }
}
