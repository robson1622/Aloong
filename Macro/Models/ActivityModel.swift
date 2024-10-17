//
//  ActivityModel.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import Foundation
import PhotosUI

struct ActivityModel : Codable, Hashable, Identifiable{
    var id : String?
    var title : String
    var description : String
    var date : Date
    var distance : Float?
    var calories : Float?
    var duration : TimeInterval?
    var steps : Float?
    
    func creste()async -> ActivityModel?{
        if let idServer = DatabaseInterface.shared.create(model: self, table: .activity){
            var new = self
            new.id = idServer
            _ = await new.update()
            return new
        }
        return nil
    }
    func createForManyGroups(listOfGroupsIds : [String],myIdUser : String,listOfImages : [UIImage])async -> Bool?{
        var erro : Bool = false
        var idActivityCreated : String = ""
        var relationWithUserId : String = ""
        var listOfRelationsGroupCreated : [String] = []
        var listOfActivityImageModel : [ActivityImageModel] = []
        if let idServer = DatabaseInterface.shared.create(model: self, table: .activity){
            var new = self
            new.id = idServer
            idActivityCreated = idServer
            // criar as relações grupo-atividade
            for groupId in listOfGroupsIds {
                var newRelation = ActivityGroupModel(idActivity: idServer, idGroup: groupId)
                if let idRelation = DatabaseInterface.shared.create(model: newRelation, table: .activityGroup){
                    newRelation.id = idRelation
                    _ = await DatabaseInterface.shared.update(model: newRelation, id: idRelation, table: .activityGroup)
                    listOfRelationsGroupCreated.append(idRelation)
                }
                else{
                    print("ERRO AO TENTAR CRIAR RELAÇÃO DE ATIVIDADE COM GRUPO EM ActivityModel/createForManyGroups")
                    erro = true
                }
            }
            // criar as relações image-atividade
            listOfActivityImageModel = await self.uploadImages(listOfImages,idServer: idServer)
            // criar relação com o usuário
            var newRelationWithUser = ActivityUserModel(idUser: myIdUser, idActivity: idServer, state: statesOfActivityRelation.owner)
            if let idRelation = DatabaseInterface.shared.create(model: newRelationWithUser, table: .activityUser){
                newRelationWithUser.id = idRelation
                _ = await DatabaseInterface.shared.update(model: newRelationWithUser, id: idRelation, table: .activityUser)
                relationWithUserId = idRelation
            }
        }
        else{
            print("ERRO AO TENTAR CRIAR DE ATIVIDADE EM ActivityModel/createForManyGroups")
            erro = true
        }
        
        if erro{
            Task{
                _ = await DatabaseInterface.shared.delete(id: idActivityCreated, table: .activity)
                _ = await DatabaseInterface.shared.delete(id: relationWithUserId, table: .activityUser)
                for activitygroupid in listOfRelationsGroupCreated{
                    _ = await DatabaseInterface.shared.delete(id: activitygroupid, table: .activityGroup)
                }
                for image in listOfActivityImageModel{
                    if let id = image.id{
                        _ = await DatabaseInterface.shared.delete(id: id, table: .activityImage)
                    }
                }
            }
        }

        return erro
    }
    
    func createForOneGroup(listOfOtherUsersIds : [String],myIdUser : String,idGroup : String,listOfImages : [UIImage],completion: @escaping (ActivityModel?,[String]) -> Void)async {
        var erro : Bool = false
        var idActivityCreated : String = ""
        var ownerRelation : String = ""
        var listOfRelationsUserCreated : [String] = []
        var idrelationsGroupCreated : String = ""
        var listOfActivityImageModel : [ActivityImageModel] = []
        let listOfIdsImages : [String] = []
        if let idServer = DatabaseInterface.shared.create(model: self, table: .activity){
            idActivityCreated = idServer
            var new = self
            new.id = idServer
            _ = await DatabaseInterface.shared.update(model: new, id: idServer, table: .activity)
            // criar relação com os usuários
            for otherUsersId in listOfOtherUsersIds{
                var newRelation = ActivityUserModel(idUser: otherUsersId, idActivity: idServer, state: statesOfActivityRelation.aloong)
                if let idRelatio = DatabaseInterface.shared.create(model: newRelation, table: .activityUser){
                    listOfRelationsUserCreated.append(idRelatio)
                    newRelation.id = idRelatio
                    _ = await DatabaseInterface.shared.update(model: newRelation, id: idRelatio, table: .activityUser)
                }
                else{
                    print("ERRO AO TENTAR CRIAR RELAÇÃO DE ATIVIDADE COM USUÁRIO EM ActivityModel/createForOneGroup")
                    erro = true
                    break
                }
            }
            // criar relação com o grupo
            if let idRelationGroup = await ActivityGroupModel(idActivity: idServer, idGroup: idGroup).create(){
                idrelationsGroupCreated = idRelationGroup
            }else{
                print("ERRO AO TENTAR CRIAR RELACAO DA ATIVIDADE COM O GRUPO EM ActivityModel/createForOneGroup")
                erro = true
            }
            // criar relação com o dono
            if let idRelation = await ActivityUserModel(idUser: myIdUser, idActivity: idServer, state: statesOfActivityRelation.owner).create(){
                ownerRelation = idRelation
            }
            else{
                print("ERRO AO TENTAR CRIAR RELACAO DA ATIVIDADE COM O USUÁRIO DONO EM ActivityModel/createForOneGroup")
                erro = true
            }
            // criar as relações image-atividade
            listOfActivityImageModel = await self.uploadImages(listOfImages,idServer: idServer)
            
            completion(new,listOfIdsImages)
        }
        else{
            print("ERRO AO TENTAR CRIAR DE ATIVIDADE EM ActivityModel/createForOneGroup")
            erro = true
        }
        
        if erro{
            Task{
                _ = await DatabaseInterface.shared.delete(id: idActivityCreated, table: .activity)
                _ = await DatabaseInterface.shared.delete(id: ownerRelation, table: .activityUser)
                _ = await DatabaseInterface.shared.delete(id: idrelationsGroupCreated, table: .activityGroup)
                for relation in listOfRelationsUserCreated{
                    _ = await DatabaseInterface.shared.delete(id: relation, table: .activityUser)
                }
                for relation in listOfActivityImageModel{
                    if let id = relation.id{
                        _ = await DatabaseInterface.shared.delete(id: id, table: .activityImage)
                    }
                }
            }
        }
    }
    
    func addNewUserInActivity(idUser: String) async -> Bool?{
        if let id = self.id{
            var newRelation = ActivityUserModel(idUser: idUser, idActivity: id, state: statesOfActivityRelation.aloong)
            if let idRelatio = DatabaseInterface.shared.create(model: newRelation, table: .activityUser){
                newRelation.id = idRelatio
                _ = await DatabaseInterface.shared.update(model: newRelation, id: idRelatio, table: .activityUser)
                return true
            }
            else{
                print("ERRO AO TENTAR CRIAR RELAÇÃO DE ATIVIDADE COM USUÁRIO EM ActivityModel/addNewUserInActivity")
                return false
            }
        }
        return nil
    }
    
    private func uploadImages(_ images : [UIImage], idServer : String) async -> [ActivityImageModel]{
        var relations : [ActivityImageModel] = []
        var imageNumber = 0
        for image in images{
            BucketOfImages.shared.upload(image: image, type: .activity){ url in
                Task{
                    let newRelation = ActivityImageModel(idActivity: idServer,imageURL: url,number: imageNumber)
                    if let relationId = await newRelation.create(){
                        relations.append(ActivityImageModel(id: relationId,idActivity: idServer,imageURL: url,number: imageNumber))
                    }
                    else{
                        print("ERRO AO TENTAR CRIAR RELAÇÃO DE ATIVIDADE COM IMAGEM EM ActivityModel/createForManyGroups")
                    }
                }
            }
            imageNumber += 1
        }
        return relations
    }
    
    func update() async -> Bool?{
        if(self.id != nil){
            return await DatabaseInterface.shared.update(model: self, id: self.id!, table: .activity)
        }
        else{
            print("ERRO AO ATUALIZAR ATIVIDADE - ActivityModel/update")
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id != nil){
            // só é possível apagar atividade se voce for o criador
            // se não for o criador então só se pode apagar a sua relação com a atividade
            return await DatabaseInterface.shared.delete(id: self.id!, table: .activity)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityModel/delete")
        }
        return nil
    }
    
    func read() async -> ActivityModel?{
        if(self.id != nil){
            return await DatabaseInterface.shared.read(id: self.id!, table: .activity)
        }
        else{
            print("ERRO AO CRIAR USUÁRIO - ActivityModel/read")
        }
        return nil
    }
}
