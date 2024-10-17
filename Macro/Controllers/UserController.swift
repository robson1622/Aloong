//
//  UserController.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import Foundation
import PhotosUI

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
    @Published var points : Int? = nil
    @Published var image : UIImage? = nil
    
    init(){
        DispatchQueue.main.async {
            self.myUser = UserLocalSave().loadUser()
            if let user = self.myUser{
                Task{
                    if let _ = await user.read(){}
                    else{
                        DispatchQueue.main.sync {
                            self.myUser = nil
                        }
                    }
                }
            }
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
    
    func saveUser() {
        if let myUser = self.myUser{
            UserLocalSave().saveUser(user: myUser)
            Task{
                await myUser.update()
            }
            if let localImage = myUser.userimage{
                BucketOfImages.shared.download(from: localImage){ image in
                    if let image = image{
                        self.image = image
                        _ = self.saveImage(image)
                    }
                }
            }
        }
    }
    
    private func savePoints(){
        if let points = self.points{
            UserLocalSave().savePoints(points: points)
        }
    }
    
    func loadUser() -> UserModel?{
        if let myUser = UserLocalSave().loadUser(){
            self.myUser = myUser
            _ = self.loadImage()
            _ = self.loadPoints()
            return myUser
        }
        return nil
    }
    
    private func loadPoints() -> Int?{
        
        if let points = UserLocalSave().loadPoints(){
            self.points = points
            return points
        }
        return nil
    }
    
    private func saveImage(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let name = "myimage"
        // Diretório local para salvar a imagem
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileURL = documentsURL.appendingPathComponent("\(name).jpg")
        
        // Salva a imagem no diretório
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
    
    private func loadImage() -> UIImage? {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let name = "myimage"
        
        let fileURL = documentsURL.appendingPathComponent("\(name).jpg")
        
        // Tenta carregar a imagem
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        } else {
            print("Não foi possível recuperar a imagem.")
            return nil
        }
    }

}

