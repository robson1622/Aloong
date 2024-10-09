//
//  ActivityImage.swift
//  Macro
//
//  Created by Robson Borges on 11/09/24.
//

import Foundation


struct ActivityImageModel : Codable, Hashable, Identifiable{
    var id : String?
    var idActivity : String?
    var imageURL : String?
    var number : Int?
    
    func create()async -> String?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .activityImage){
            var new = self
            new.id = idServer
            _ = await new.update()
            return idServer
        }
        return nil
    }
    
    func update() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.update(model: self, id: self.id!, table: .activityImage)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityImageModel/update")
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.delete(id: self.id!, table: .activityImage)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityImageModel/delete")
        }
        return nil
    }
    
    func read() async -> ActivityImageModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .activityImage)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityImageModel/read")
        }
        return nil
    }
}
