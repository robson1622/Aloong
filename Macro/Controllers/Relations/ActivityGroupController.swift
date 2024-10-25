//
//  ActivityGroupController.swift
//  Macro
//
//  Created by Robson Borges on 04/09/24.
//

import Foundation

class ActivityGroupController: ObservableObject{
    static var shared : ActivityGroupController = ActivityGroupController()
    
    @Published private var listOfActivityGroup : [ActivityGroupModel] = []
    private let idGroupFieldName : String = "idGroup"
    private let idActivityFieldName : String = "idActivity"
    
    func readAllActivityGroupsOfGroup(idGroup : String)async -> [ActivityGroupModel]{
        let list : [ActivityGroupModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idGroup, table: .activityGroup, field: idGroupFieldName)
        for element in list{
            if let index = listOfActivityGroup.firstIndex(where: {$0.id == element.id}){
                DispatchQueue.main.sync{
                    self.listOfActivityGroup[index] = element
                }
            }
            else{
                DispatchQueue.main.sync{
                    self.listOfActivityGroup.append(element)
                }
            }
        }
        return listOfActivityGroup
    }
    
    func readAllActivityGroupsOfActivity(idActivity : String)async -> [ActivityGroupModel]{
        return await DatabaseInterface.shared.readDocuments(isEqualValue: idActivity, table: .activityGroup, field: idActivityFieldName)
    }
    
    func readPlusActivityGroupOfGroup(idGroup : String)async -> [ActivityGroupModel]{
        let idLastDocumento : String? = listOfActivityGroup.last?.id
        do {
            let relations : [ActivityGroupModel] = try await DatabaseInterface.shared.loadMoreDocuments(isEqualValue: idGroup, table: .activityGroup, lastDocumentId: idLastDocumento, field: idGroupFieldName)
            for element in relations{
                if let index = listOfActivityGroup.firstIndex(where: {$0.id == element.id}){
                    DispatchQueue.main.sync{
                        self.listOfActivityGroup[index] = element
                    }
                }
                else{
                    DispatchQueue.main.sync{
                        self.listOfActivityGroup.append(element)
                    }
                }
            }
            print("\n SUCESSO AO TENTAR BAIXAR 10 ACTIVITY GROUP em ActivityGroupController/readPlusActivityGroupOfGroup \n")
        }
        catch{
            print("NÃO FOI POSSÍVEL CARREGAR MAIS ACTIVITY GROUP em ActivityGroupController/readPlusActivityGroupOfGroup")
        }
        return listOfActivityGroup
    }
    
    func deleteAllActivityGroupOfGroup(idGroup : String)async -> Bool?{
        return nil
    }
    
    
    
}
