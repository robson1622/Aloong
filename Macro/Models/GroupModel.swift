//
//  GroupModel.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation

struct GroupModel:  Codable, Hashable, Identifiable{
    var id : String?
    var idUser : String
    var title : String
    var description : String
    var startDate : Date
    var endDate : Date
    var scoreType : String
    var invitationCode : String?
    
    func create()async -> GroupModel?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .activityGroup){
            var newGroup = self
            newGroup.id = idServer
            newGroup.invitationCode = await generateInvitationCode()
            let relationOwner = MemberModel(groupId: idServer, userId: self.idUser, state: statesOfMembers.owner)
            if let _ = await relationOwner.create(){
                if let _ = await newGroup.update(){
                    return newGroup
                }
            }
        }
        return nil
    }
    
    func update() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.update(model: self, id: self.id!, table: .group)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - GroupModel/update")
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.delete(id: self.id!, table: .group)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - GroupModel/delete")
        }
        return nil
    }
    
    func read() async -> GroupModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .group)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - GroupModel/read")
        }
        return nil
    }
}
