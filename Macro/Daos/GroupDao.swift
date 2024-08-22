//
//  GroupDao.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation

class GroupDao : ObservableObject{
    static var shared : GroupDao = GroupDao()
    
    @Published var searchResult : GroupModel?
    
    func create(model : GroupModel){
        print("Função  create (GroupDao) : Não feita")
    }
    
    func delete(model : GroupModel){
        print("Função  delete (GroupDao) : Não feita")
    }
    
    func update(model : GroupModel){
        print("Função  update (GroupDao) : Não feita")
    }
    
    func searchGroup(code: String) -> Bool?{
        print("Função  searchGroup (GroupDao) : Não feita")
        
        GroupDao.shared.searchResult = exempleGroup
        
        return true
    }
    
    
}
