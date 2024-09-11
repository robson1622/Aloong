//
//  MemberDao.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation

class MemberDao : ObservableObject{
    static var shared : MemberDao = MemberDao()
    let collectionName : String = "member"
    let collectionGrousIdName : String = "groupId"
    let collectionUsersIdName : String = "userId"
    
    func create(model : MemberModel)async  -> Bool?{
        let idModel = FirebaseInterface.shared.createDocument(model: model, collection: collectionName)
        let withIdModel = MemberModel(groupId: model.groupId, userId: model.userId, state: model.state, id: idModel)
        if let _ = await FirebaseInterface.shared.updateDocument(model: withIdModel, id: withIdModel.id!, collection: collectionName){
            return true
        }
        return nil
    }
    
    func delete(idMember : String)async -> Bool?{
        if let sucess = await FirebaseInterface.shared.deleteDocument(id: idMember, collection: collectionName){
            return sucess
        }
        return nil
    }
    
    func update(model : MemberModel) async -> Bool?{
        if(model.id != nil){
            if let sucess = await FirebaseInterface.shared.updateDocument(model: model, id: model.id!, collection: collectionName){
                return sucess
            }
        }
        return nil
    }
    
    func read(idMember : String) async -> MemberModel?{
        if let result : MemberModel = await FirebaseInterface.shared.readDocument(id: idMember, collection: collectionName){
            return result
        }
        return nil
    }
    
    func readAllMembersOfGroup(idGroup: String)async -> [MemberModel]{
        return await FirebaseInterface.shared.readDocuments(id: idGroup, collection: collectionName, field: collectionGrousIdName)
    }
    
    func readAllMemberOfUser(idUser: String) async -> [MemberModel]{
        return await FirebaseInterface.shared.readDocuments(id: idUser, collection: collectionName, field: collectionUsersIdName)
    }
}
