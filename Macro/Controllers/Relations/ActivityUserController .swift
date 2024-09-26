//
//  ActivityUserController .swift
//  Macro
//
//  Created by Robson Borges on 04/09/24.
//

import Foundation

class ActivityUserController: ObservableObject{
    static let shared = ActivityUserController()
    @Published private var listOfRelationsWithUser : [RelationsWithUser] = []
    @Published private var listOfRelationsWithActivity : [RelationsWithActivity] = []
    private let idUserFieldName : String = "idUser"
    private let idActivityFieldName : String = "idActivity"
    
    private struct RelationsWithUser {
        var idUser: String
        var listOfActivityUser: [ActivityUserModel]
    }
    
    private struct RelationsWithActivity{
        var idActivity : String
        var listOfActivityUser : [ActivityUserModel]
    }
    
    func readAllActivityUserOfUser(idUser: String)async -> [ActivityUserModel]{
        if let index = listOfRelationsWithUser.firstIndex(where: { $0.idUser == idUser }){
            if listOfRelationsWithUser[index].listOfActivityUser.isEmpty{
                await insertRelationsInListUser(index: index, idUser: idUser)
            }
            else{
                Task{
                    await insertRelationsInListUser(index: index, idUser: idUser)
                }
            }
            return listOfRelationsWithUser[index].listOfActivityUser
        }
        else{
            let newRelations : RelationsWithUser = RelationsWithUser(idUser: idUser, listOfActivityUser: [])
            listOfRelationsWithUser.append(newRelations)
            if let index = listOfRelationsWithUser.firstIndex(where: {$0.idUser == idUser}){
                await insertRelationsInListUser(index: index, idUser: idUser)
                return listOfRelationsWithUser[index].listOfActivityUser
            }
            return []
        }
    }
    
    func readAllActivityUserOfActivity(idActivity: String)async -> [ActivityUserModel]{
        if let index = listOfRelationsWithActivity.firstIndex(where: { $0.idActivity == idActivity }){
            if listOfRelationsWithActivity[index].listOfActivityUser.isEmpty{
                await insertRelationsInListActivity(index: index, idActivity: idActivity)
            }
            else{
                Task{
                    await insertRelationsInListActivity(index: index, idActivity: idActivity)
                }
            }
            return listOfRelationsWithActivity[index].listOfActivityUser
        }
        else{
            let newRelations : RelationsWithActivity = RelationsWithActivity(idActivity: idActivity, listOfActivityUser: [])
            listOfRelationsWithActivity.append(newRelations)
            if let index = listOfRelationsWithActivity.firstIndex(where: {$0.idActivity == idActivity}){
                await insertRelationsInListActivity(index: index, idActivity: idActivity)
                return listOfRelationsWithActivity[index].listOfActivityUser
            }
            return []
        }
    }
    
    private func insertRelationsInListActivity(index : Int,idActivity : String) async{
        let relations : [ActivityUserModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idActivity, table: .activityUser, field: idActivityFieldName)
        for relation in relations{
            if let indexRelation = listOfRelationsWithActivity[index].listOfActivityUser.firstIndex(where:{$0.id == relation.id}){
                listOfRelationsWithActivity[index].listOfActivityUser[indexRelation] = relation
            }
            else{
                listOfRelationsWithActivity[index].listOfActivityUser.append(relation)
            }
        }
    }
    
    
    private func insertRelationsInListUser(index : Int,idUser : String) async{
        let relations : [ActivityUserModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idUser, table: .activityUser, field: idUserFieldName)
        for relation in relations{
            if let indexRelation = listOfRelationsWithUser[index].listOfActivityUser.firstIndex(where:{$0.id == relation.id}){
                listOfRelationsWithUser[index].listOfActivityUser[indexRelation] = relation
            }
            else{
                listOfRelationsWithUser[index].listOfActivityUser.append(relation)
            }
        }
    }
}
