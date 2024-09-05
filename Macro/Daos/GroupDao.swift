//
//  GroupDao.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation

class GroupDao : ObservableObject{
    static var shared : GroupDao = GroupDao()
    private let collectionName = "groups"
    private let invitationFieldName = "invitationCode"
    
    func create(group : GroupModel) async -> GroupModel? {
        if(group.idUser != nil){
            if let result = FirebaseInterface.shared.createDocument(model: group,collection: collectionName){
                let groupSaved = GroupModel(id: result, idUser: group.idUser, title: group.title, description: group.description, startDate: group.startDate, endDate: group.endDate, scoreType: group.scoreType, groupImage: group.groupImage)
                if let _ = await update(model: groupSaved){
                    return groupSaved
                }
            }
            else{
                print("Não foi possível criar o grupo")
            }
        }
        print("ERRO AO CRIAR GRUPO, idUser nill, na função GroupDao.create ")
        return nil
        
    }
    
    func delete(model : GroupModel)async -> Bool?{
        if model.id != nil{
            if let result = await FirebaseInterface.shared.deleteDocument(id: model.id!, collection: collectionName){
                return result
            }
        }
        else{
            print("ID DO GRUPO NULO, NÃO FOI POSSÍVEL APAGAR")
        }
        return nil
    }
    
    func update(model : GroupModel) async -> Bool? {
        if(model.id != nil){
            if let _ = await FirebaseInterface.shared.updateDocument(model: model, id: model.id!, collection: collectionName){
                return true
            }
        }
        else{
            print("NÃO FOI POSSÍVEL ATUALIZAR GRUPO, ID NULO")
        }
        return nil
    }
    func read(groupId : String) async -> GroupModel?{
        if let result : GroupModel = await FirebaseInterface.shared.readDocument(id: groupId, collection: collectionName){
            return result
        }
        return nil
    }
    func read(inviteCode : String) async -> [GroupModel]{
        let response : [GroupModel] = await FirebaseInterface.shared.readDocumentWithField(isEqualValue: inviteCode, collection: collectionName, field: invitationFieldName)
        return response
    }
    func read(userId : String) async -> [GroupModel]{
        let result = await MemberDao.shared.readAllMemberOfUser(idUser: userId)
        var groupList : [GroupModel] = []
        
        for groupRef in result{
            if let group : GroupModel = await FirebaseInterface.shared.readDocument(id: groupRef.groupId!, collection: collectionName){
                groupList.append(group)
            }
            else{
                print("ERRO AO TENTAR PEGAR GRUPO EM GROUPDAO/READ")
                print(result)
            }
        }
        
        return groupList
    }
}
