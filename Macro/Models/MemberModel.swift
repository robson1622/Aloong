//
//  MemberModel.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import Foundation


struct MemberModel : Codable, Hashable{
    var id : String?
    var groupId : String
    var userId : String
    var state : String

    
    func create()async -> MemberModel?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .member){
            var newMember = self
            newMember.id = idServer
            if let _ = await newMember.update(){
                return newMember
            }
        }
        return nil
    }
    
    func update() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.update(model: self, id: self.id!, table: .member)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - MemberModel/update")
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.delete(id: self.id!, table: .member)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - MemberModel/delete")
        }
        return nil
    }
    
    func read() async -> MemberModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .member)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - MemberModel/read")
        }
        return nil
    }
}

