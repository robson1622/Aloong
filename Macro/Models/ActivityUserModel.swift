//
//  UserActivityModel.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import Foundation



struct ActivityUserModel: Codable, Hashable{
    var id : String?
    var idUser : String
    var idActivity : String
    var state : String
    
    func create()async -> String?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .activityUser){
            var new = self
            new.id = idServer
            _ = await new.update()
            return idServer
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
    
    func read() async -> ActivityUserModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .activityUser)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityUserModel/read")
        }
        return nil
    }
}
