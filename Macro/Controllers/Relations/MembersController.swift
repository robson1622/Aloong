//
//  MembersController.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import Foundation


class MembersController: ObservableObject{
    static var shared : MembersController = MembersController()
    
    private struct GroupAndMemberCollection : Observable {
        var groupId : String
        var listOfMembers : [MemberModel]
    }
    
    @Published private var listOfMembers : [GroupAndMemberCollection] = []
    @Published var listOfMyMembers : [MemberModel] = []
    private let userIdFieldName : String = "userId"
    private let groupIdFieldName : String = "groupId"
    
    func readAllMembersOfGroup(idGroup : String, reset : Bool)async -> [MemberModel]{
        
        if let index = listOfMembers.firstIndex(where: {$0.groupId == idGroup}){
            if(reset || listOfMembers[index].listOfMembers.isEmpty){
                listOfMembers[index].listOfMembers.removeAll()
                let response : [MemberModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idGroup, table: .member, field: groupIdFieldName)
                for member in response{
                    listOfMembers[index].listOfMembers.append(member)
                }
                return listOfMembers[index].listOfMembers
            }
            return listOfMembers[index].listOfMembers
        }
        else{
            var newGroupAndMemberCollection : GroupAndMemberCollection = GroupAndMemberCollection(groupId: idGroup, listOfMembers: [])
            let response : [MemberModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idGroup, table: .member, field: groupIdFieldName)
            for member in response{
                newGroupAndMemberCollection.listOfMembers.append(member)
            }
            listOfMembers.append(newGroupAndMemberCollection)
            return newGroupAndMemberCollection.listOfMembers
        }
    }
    
    func readAllMembersOfMyUser(reset : Bool = false)async -> [MemberModel]{
        if let idUser = UserController.shared.myUser?.id{
            if(reset || listOfMyMembers.isEmpty){
                if reset{
                    listOfMyMembers.removeAll()
                }
                let response : [MemberModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idUser, table: .member, field: userIdFieldName)
                for member in response{
                    if let index = listOfMyMembers.firstIndex(where: { $0.id == member.id }){
                        listOfMyMembers[index] = member
                    }
                    else{
                        listOfMyMembers.append(member)
                    }
                }
            }
        }
        return listOfMyMembers
    }

    func deleteListOfMembers(listOfIds : [String]? = nil,listOfModels : [MemberModel]? = nil)async -> Bool?{
        var alldeleted : Bool? = true
        if let list = listOfIds{
            for element in list {
                if let _ = await DatabaseInterface.shared.delete(id: element, table: .member){
                    
                }
                else{
                    print("NÃO FOI POSSÍVEL APAGAR UM MEMBRO DA LISTA - MemberController/deleteListOfMembers")
                    alldeleted = false
                }
            }
        }
        else if let list = listOfModels{
            for element in list{
                if let _ = await DatabaseInterface.shared.delete(id: element.id!, table: .member){
                    
                }
                else{
                    print("NÃO FOI POSSÍVEL APAGAR UM MEMBRO DA LISTA - MemberController/deleteListOfMembers")
                    alldeleted = false
                }
            }
        }
        return alldeleted
    }
    
}
