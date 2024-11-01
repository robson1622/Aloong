//
//  GroupActivityModel.swift
//  Macro
//
//  Created by Robson Borges on 30/08/24.
//

import Foundation



struct ActivityGroupModel : Codable, Hashable{
    var id : String?
    var date : Date
    var idActivity : String
    var idGroup : String
    
    func create()async -> String?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .activityGroup){
            let newActivity = ActivityGroupModel(id: idServer,date: Date(), idActivity: self.idActivity, idGroup: self.idGroup)
            _ = await newActivity.update()
            return idServer
        }
        return nil
    }
    
    func update() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.update(model: self, id: self.id!, table: .activityGroup)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityGroupModel/update")
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.delete(id: self.id!, table: .activityGroup)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityGroupModel/delete")
        }
        return nil
    }
    
    func read() async -> ActivityGroupModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .activityGroup)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityGroupModel/read")
        }
        return nil
    }
}
