//
//  UserController.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import Foundation


class UserController: ObservableObject{
    static var shared : UserController = UserController()
    
    private struct UsersGroupCollection{
        var idGroup : String
        var users : [UserModel]
    }
    
    private struct UserActivityCollection{
        var idActivity : String
        var users : [UserModel]
    }
    @Published private var userActivities : [UserActivityCollection] = []
    @Published private var usersGroups : [UsersGroupCollection] = []
    //usuário atual
    @Published var myUser : UserModel?
    
    init(){
        DispatchQueue.main.async {
            self.myUser = UserLocalSave().loadUser()
        }
    }
    
    
    func readAllUsersOfGroup(idGroup : String, reset : Bool) async -> [UserModel] {
        if(reset || usersGroups.isEmpty){
            usersGroups.removeAll()
            var new = UsersGroupCollection(idGroup: idGroup, users: [])
            let membersmodels = await MembersController.shared.readAllMembersOfGroup(idGroup: idGroup, reset: false)
            for member in membersmodels{
                if let user : UserModel = await DatabaseInterface.shared.read(id: member.userId, table: .user){
                    new.users.append(user)
                }
            }
            usersGroups.append(new)
            return new.users
        }
        else{
            if let index = usersGroups.firstIndex(where: {$0.idGroup == idGroup}){
                return usersGroups[index].users
            }
            else{
                var new = UsersGroupCollection(idGroup: idGroup, users: [])
                let membersmodels = await MembersController.shared.readAllMembersOfGroup(idGroup: idGroup, reset: false)
                for member in membersmodels{
                    if let user : UserModel = await DatabaseInterface.shared.read(id: member.userId, table: .user){
                        new.users.append(user)
                    }
                }
                usersGroups.append(new)
                return new.users
            }
        }
    }
    
    func readAllUsersOfActivity(idActivity : String, reset : Bool) async -> [UserModel]{
        if(reset || userActivities.isEmpty){
            userActivities.removeAll()
            var new = UserActivityCollection(idActivity: idActivity, users: [])
            let activityusers = await ActivityUserController.shared.readAllActivityUserOfActivity(idActivity: idActivity)
            for act in activityusers{
                if let user : UserModel = await DatabaseInterface.shared.read(id: act.idUser, table: .user){
                    new.users.append(user)
                }
            }
            userActivities.append(new)
            return new.users
        }
        else{
            if let index = userActivities.firstIndex(where: {$0.idActivity == idActivity}){
                return userActivities[index].users
            }
            else{
                var new = UserActivityCollection(idActivity: idActivity, users: [])
                let activityusers = await ActivityUserController.shared.readAllActivityUserOfActivity(idActivity: idActivity)
                for act in activityusers{
                    if let user : UserModel = await DatabaseInterface.shared.read(id: act.idUser, table: .user){
                        new.users.append(user)
                    }
                }
                userActivities.append(new)
                return new.users
            }
        }
    }
    
    func loadUser() -> UserModel?{
        if let myUser = UserLocalSave().loadUser(){
            self.myUser = myUser
            return myUser
        }
        return nil
    }
}

