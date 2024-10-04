//
//  ActivityGroupController.swift
//  Macro
//
//  Created by Robson Borges on 04/09/24.
//

import Foundation

class ActivityGroupController: ObservableObject{
    static var shared : ActivityGroupController = ActivityGroupController()
    
    private struct ActivityGroupCollection{
        var idGroup : String
        var listOfActivityGroup : [ActivityGroupModel]
    }
    
    @Published private var listOfActivityGroup : [ActivityGroupCollection] = []
    private let idGroupFieldName : String = "idGroup"
    private let idActivityFieldName : String = "idActivity"
    
    func readAllActivityGroupsOfGroup(idGroup : String)async -> [ActivityGroupModel]{
        if let index = listOfActivityGroup.firstIndex(where: { $0.idGroup == idGroup }){
            if listOfActivityGroup[index].listOfActivityGroup.isEmpty{
                await insertRelationsInListActivityGroup(index: index, idGroup: idGroup)
            }
            else{
                await insertRelationsInListActivityGroup(index: index, idGroup: idGroup)
                
            }
            return listOfActivityGroup[index].listOfActivityGroup
        }
        else{
            let newRelations : ActivityGroupCollection = ActivityGroupCollection(idGroup: idGroup, listOfActivityGroup: [])
            listOfActivityGroup.append(newRelations)
            if let index = listOfActivityGroup.firstIndex(where: {$0.idGroup == idGroup}){
                await insertRelationsInListActivityGroup(index: index, idGroup: idGroup)
                return listOfActivityGroup[index].listOfActivityGroup
            }
            return []
        }
    }
    
    func readAllActivityGroupsOfActivity(idActivity : String)async -> [ActivityGroupModel]{
        print("FALTA FAZER COM QUE OS DADOS SEJAM SALVOS LOCALMENTE - ActivityGroupController/readAllActivityGroupsOfGroup")
        return await DatabaseInterface.shared.readDocuments(isEqualValue: idActivity, table: .activityGroup, field: idActivityFieldName)
    }
    
    func deleteAllActivityGroupOfGroup(idGroup : String)async -> Bool?{
        print("FALTA TERMINAR ActivityGroupController/deleteAllActivityGroupOfGroup")
        return nil
    }
    
    
    private func insertRelationsInListActivityGroup(index : Int,idGroup : String) async{
        let relations : [ActivityGroupModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idGroup, table: .activityGroup, field: idGroupFieldName)
        for relation in relations{
            if let indexRelation = listOfActivityGroup[index].listOfActivityGroup.firstIndex(where:{$0.id == relation.id}){
                listOfActivityGroup[index].listOfActivityGroup[indexRelation] = relation
            }
            else{
                listOfActivityGroup[index].listOfActivityGroup.append(relation)
            }
        }
    }
    
}
