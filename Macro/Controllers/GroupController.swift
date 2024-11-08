//
//  GroupController.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import Foundation



class GroupController: ObservableObject{
    static var shared = GroupController()
    @Published var groupsOfThisUser : [GroupModel] = []
    private let idUserMemberFieldName = "userId"
    private let collectionName = "groups"
    private let invitationFieldName = "invitationCode"
    
    private let keyLocalMainGroup = "keyLocalMainGroup"
    
    func load(idUser : String) async {
        let relations : [MemberModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idUser, table: .member, field: idUserMemberFieldName)
        for relation in relations{
            if let group : GroupModel = await DatabaseInterface.shared.read(id: relation.groupId, table: .group){
                groupsOfThisUser.append(group)
            }
        }
    }
    
    func deleteMainGroupOfUser(){
        UserDefaults.standard.removeObject(forKey: keyLocalMainGroup)
    }
    
    func searchGroup(code : String) async -> [GroupModel]{
        return await DatabaseInterface.shared.readDocuments(isEqualValue: code, table: .group, field: invitationFieldName)
    }
    
    func readMainGroupOfUser() -> GroupModel?{
        guard let data = UserDefaults.standard.data(forKey: keyLocalMainGroup) else {
            return nil
        }
        
        do {
            let group = try JSONDecoder().decode(GroupModel.self, from: data)
            return group
        } catch {
            print("Erro ao carregar o usuário: \(error)")
            return nil
        }
    }
    
    func saveLocalMainGroup(group : GroupModel) {
        do {
            let data = try JSONEncoder().encode(group)
            UserDefaults.standard.set(data, forKey: keyLocalMainGroup)
        } catch {
            print("Erro ao salvar o usuário: \(error)")
        }
    }
    
    func readAllGroupsOfUser(reset : Bool = false) async -> [GroupModel]{
        if let idUser = UserController.shared.myUser?.id{
            if reset{
                groupsOfThisUser.removeAll()
            }
            let members : [MemberModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idUser, table: .member, field: idUserMemberFieldName)
            for member in members{
                if let group : GroupModel = await DatabaseInterface.shared.read(id: member.groupId, table: .group){
                    if let index = groupsOfThisUser.firstIndex(where: {$0.id == group.id}){
                        groupsOfThisUser[index] = group
                    }
                    else{
                        groupsOfThisUser.append(group)
                    }
                }
            }
        }
        return groupsOfThisUser
    }
    
}
