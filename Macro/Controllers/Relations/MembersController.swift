//
//  MembersController.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import Foundation


class MembersController: ObservableObject{
    @Published var listOfMembers : [MemberModel] = []
    
    func loadMembers(idGroup : String) async {
        listOfMembers = await MemberDao.shared.readAllMembersOfGroup(idGroup: idGroup)
    }
    func getMembersOfUser(idUser: String) async -> [MemberModel]{
        return await MemberDao.shared.readAllMemberOfUser(idUser: idUser)
    }
    func create(idGroup : String, idUser : String,state : String = statesOfMembers.member) async -> Bool?{
        let model : MemberModel = MemberModel(groupId: idGroup, userId: idUser, state: state)
        return await MemberDao.shared.create(model: model)
    }
    
    func remove(idMember : String) async -> Bool?{
        return await MemberDao.shared.delete(idMember: idMember)
    }
    
    func update(model : MemberModel) async -> Bool?{
        if let response = await MemberDao.shared.update(model: model){
            return response
        }
        return nil
    }
}
