//
//  GroupDao.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation

class GroupDao : ObservableObject{
    static var shared : GroupDao = GroupDao()
    
    
    func create(group : GroupModel) async -> GroupModel? {
        if(group.idUser != nil){
            if let result = FirebaseInterface.shared.createDocument(model: group){
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
        if let result = await FirebaseInterface.shared.deleteDocument(model: model){
            return result
        }
        return nil
    }
    
    func update(model : GroupModel) async -> Bool? {
        if let _ = await FirebaseInterface.shared.updateDocument(model: model){
            return true
        }
        return nil
    }
    func read(groupId : String) async -> GroupModel?{
        if let result = await FirebaseInterface.shared.readDocument(groupId: groupId){
            return result
        }
        return nil
    }
    
    func read(userId : String) async -> [GroupModel]{
        let result = await FirebaseInterface.shared.readDocuments(userId: userId)
        var groupList : [GroupModel] = []
        for groupRef in result{
            if let group = await FirebaseInterface.shared.readDocument(groupId: groupRef.groupId!){
                groupList.append(group)
            }
            else{
                print("ERRO AO TENTAR PEGAR GRUPO EM GROUPDAO/READ")
            }
        }
        
        return groupList
    }
    
    func searchGroup(code: String) -> Bool?{
        print("Função  searchGroup (GroupDao) : Não feita")
        
        
        return true
    }
    
    
}
