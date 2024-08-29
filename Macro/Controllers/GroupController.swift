//
//  GroupController.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import Foundation



class GroupController: ObservableObject{
    
    @Published var groupsOfThisUser : [GroupModel] = []
    @Published var search : GroupModel?
    
    func loadGroups(model : UserModel?) -> Bool{
        print("loadGroups : FUNÇÃO NÃO FEITA")
        return false
    }
    
    func searchGroup(code : String) async -> GroupModel?{
        print("searchGroup : FUNÇÃO NÃO FEITA")
        return nil
    }
    
    func create(model : GroupModel) async {
        let testGroup = await GroupDao().create(group: model)
        print(testGroup as Any)
    }
    
    func update(model : GroupModel){
        
    }
    
    func delete(model : GroupModel){
        
    }
    
}
