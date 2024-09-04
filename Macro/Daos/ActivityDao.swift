//
//  ActivityDao.swift
//  Macro
//
//  Created by Robson Borges on 30/08/24.
//

import Foundation


class ActivityDao : ObservableObject{
    static var shared : ActivityDao = ActivityDao()
    let collectionName = "activities"
    let collectionNameRelationGroup = "activitygroup"
    let collectionNameRelationUser = "activityuser"
    
    func create(model : ActivityModel,idGroup : String, idUserOwner : String, listOfUsersIds : [String] = []) async -> Bool?{
        // cria a atividade
        if let result = FirebaseInterface.shared.createDocument(model: model, collection: collectionName){
            var withId = model
            withId.id = result
            
            if let _ = await self.createRelationForAnyUser(idGroup: idGroup, idUser: idUserOwner, idActivity: result, state: statesOfActivityRelation.owner){
                for user in listOfUsersIds{
                    if let _ = await self.createRelationForAnyUser(idGroup: idGroup, idUser: user, idActivity: result, state: statesOfActivityRelation.aloong){
                    }
                    else{
                        print("ERRO !, RELAÇÃO COM O USUÁRIO \(user) NÃO FOI CRIADA ActivityDao/create")
                    }
                    
                }
            }
            return await self.update(model: withId)
        }
        print("NÃO FOI POSSÍVEL CRIAR ATIVIDADE EM ActivityDao/create")
        return nil
    }
    
    private func createRelationForAnyUser(idGroup : String, idUser : String,idActivity : String, state : String) async -> Bool?{
        // cria a relação com o grupo
        if let _ = await createRelationActivityWithGroup(idActivity: idActivity, idGroup: idGroup){
            // cria a relação com o usuário
            if let _ = await createRelationActivityWithUser(idUser: idUser, idActivity: idActivity, state: state){
                return true
            }
        }
        return nil
    }
    
    func update(model : ActivityModel) async -> Bool?{
        if (model.id != nil){
            if let withId = await FirebaseInterface.shared.updateDocument(model: model, id: model.id!, collection: collectionName){
                return withId
            }
        }
        print("ERRO AO TENTAR ATUALIZAR ATIVIDADE, ID NULO")
        return nil
    }
    
    func delete(model: ActivityModel) async -> Bool?{
        if(model.id != nil){
            if let result = await FirebaseInterface.shared.deleteDocument(id: model.id!, collection: collectionName){
                return result
            }
            else{
                print("NÃO FOI POSSIVEL APAGAR ATIVIDADE")
            }
        }
        print("ID DA ATIVIDADE NULO, NÃO FOI POSSÍVEL APAGAR")
        return nil
    }
    
    func read(id: String) async -> ActivityModel?{
        if let result : ActivityModel = await FirebaseInterface.shared.readDocument(id: id, collection: collectionName){
            return result
        }
        print("NÃO FOI POSSÍVEL LER ATIVIDADE ")
        return nil
    }
    //retorna todas as relações de atividades com um grupo específico
    func getAllRelationsOfAGroup(groupId: String){
        
    }
    
    func getAllActivitiesOfAGroup(groupId : String) async -> [ActivityModel]{
        
        return []
    }
    
    
    private func createRelationActivityWithGroup(idActivity: String,idGroup: String) async -> Bool?{
        var model : GroupActivityModel = GroupActivityModel(idActivity: idActivity, idGroup: idGroup) 
        if let newRelationWithGroupId = FirebaseInterface.shared.createDocument(model: model , collection: collectionNameRelationGroup){
            model.id = newRelationWithGroupId
            if let _ = await FirebaseInterface.shared.updateDocument(model: model, id: model.id!, collection: collectionNameRelationGroup){
                print("RELAÇÃO CRIADA COM SUCESSO")
                return true
            }
        }
        print("NÃO FOI POSSÍVEL CRIAR A RELAÇÃO DA ATIVIDADE COM O GRUPO EM ActivityDao/createRelationGroup")
        return nil
    }
    
    private func createRelationActivityWithUser(idUser: String,idActivity: String,state : String) async -> Bool?{
        var model : UserActivityModel = UserActivityModel(idUser: idUser, idActivity: idActivity, state: state)
        if let newRelationWithGroupId = FirebaseInterface.shared.createDocument(model: model , collection: collectionNameRelationUser){
            model.id = newRelationWithGroupId
            if let _ = await FirebaseInterface.shared.updateDocument(model: model, id: model.id!, collection: collectionNameRelationUser){
                print("RELAÇÃO CRIADA COM SUCESSO")
                return true
            }
        }
        print("NÃO FOI POSSÍVEL CRIAR A RELAÇÃO DA ATIVIDADE COM O GRUPO EM ActivityDao/createRelationGroup")
        return nil
    }
}
