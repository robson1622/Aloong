//
//  GroupController.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import Foundation



class GroupController: ObservableObject{
    @Published var members : MembersController = MembersController()
    @Published var groupsOfThisUser : [GroupModel] = []
    @Published var usersOfThisGroup : [UserModel] = []
    @Published var search : GroupModel?
    
    func load(idUser : String) async {
        groupsOfThisUser = await GroupDao.shared.read(userId: idUser)
    }
    
    func searchGroup(code : String) async -> [GroupModel]{
        return await GroupDao.shared.read(inviteCode: code)
    }
    
    func create(model : GroupModel) async -> Bool?{
        if let response = await GroupDao.shared.create(group: model){
            return true
        }
        return nil
    }
    
    func update(model : GroupModel)async -> Bool?{
        if let response = await GroupDao.shared.update(model: model){
            return response
        }
        return nil
    }
    
    func delete(model : GroupModel)async -> Bool?{
        if let response = await GroupDao.shared.delete(model: model){
            return response
        }
        return nil
    }
    
}
