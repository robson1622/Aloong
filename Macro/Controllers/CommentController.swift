//
//  CommitController.swift
//  Macro
//
//  Created by Robson Borges on 17/09/24.
//

import Foundation



class CommentController: ObservableObject{
    static var shared : CommentController = CommentController()
    @Published var listOfCommitsOfUser : [CommentModel] = []
    @Published var listOfCommitsOfGroup : [CommentModel] = []
    private let userIdFieldName : String = "idUser"
    private let groupIdFieldName : String = "idGroup"
    
    private struct CommitsPerUser {
        var idUser : String
        var listOfCommits : [CommentModel]
    }
    
    private struct CommitsPerGroup {
        var idGroup : String
        var listOfCommits : [CommentModel]
    }
    
    private struct CommitsPerActivity {
        var idActivity : String
        var listOfCommits : [CommentModel]
    }
    
    @Published private var listOfCommitsPerUser : [CommitsPerUser] = []
    @Published private var listOfCommitsPerGroup : [CommitsPerGroup] = []
    @Published private var listOfCommitsPerActivity : [CommitsPerActivity] = []
    
    func readAllCommitsOfActivity(idActivity : String) async -> [CommentModel]{
        if let index = listOfCommitsPerActivity.firstIndex(where: { $0.idActivity == idActivity }){
            if listOfCommitsPerActivity[index].listOfCommits.isEmpty{
                await insertInlistOfCommitsPerActivity(index: index, idActivity: idActivity)
            }
            else{
                Task{
                    await insertInlistOfCommitsPerActivity(index: index, idActivity: idActivity)
                }
            }
            return listOfCommitsPerActivity[index].listOfCommits
        }
        else{
            let newRelations : CommitsPerActivity = CommitsPerActivity(idActivity: idActivity, listOfCommits: [])
            listOfCommitsPerActivity.append(newRelations)
            if let index = listOfCommitsPerActivity.firstIndex(where: {$0.idActivity == idActivity}){
                await insertInlistOfCommitsPerActivity(index: index, idActivity: idActivity)
                return listOfCommitsPerActivity[index].listOfCommits
            }
            return []
        }
    }
    
    func readAllCommitsOfUser(idUser : String) async -> [CommentModel]{
        if let index = listOfCommitsPerUser.firstIndex(where: { $0.idUser == idUser }){
            if listOfCommitsPerUser[index].listOfCommits.isEmpty{
                await insertInlistOfCommitsPerUser(index: index, idUser: idUser)
            }
            else{
                Task{
                    await insertInlistOfCommitsPerUser(index: index, idUser: idUser)
                }
            }
            return listOfCommitsPerUser[index].listOfCommits
        }
        else{
            let newRelations : CommitsPerUser = CommitsPerUser(idUser: idUser, listOfCommits: [])
            listOfCommitsPerUser.append(newRelations)
            if let index = listOfCommitsPerUser.firstIndex(where: {$0.idUser == idUser}){
                await insertInlistOfCommitsPerUser(index: index, idUser: idUser)
                return listOfCommitsPerUser[index].listOfCommits
            }
            return []
        }
    }
    
    func readAllCommitsOfGroup(idGroup : String) async -> [CommentModel]{
        if let index = listOfCommitsPerGroup.firstIndex(where: { $0.idGroup == idGroup }){
            if listOfCommitsPerGroup[index].listOfCommits.isEmpty{
                await insertInlistOfCommitsPerGroup(index: index, idGroup: idGroup)
            }
            else{
                Task{
                    await insertInlistOfCommitsPerGroup(index: index, idGroup: idGroup)
                }
            }
            return listOfCommitsPerGroup[index].listOfCommits
        }
        else{
            let newRelations : CommitsPerGroup = CommitsPerGroup(idGroup: idGroup, listOfCommits: [])
            listOfCommitsPerGroup.append(newRelations)
            if let index = listOfCommitsPerGroup.firstIndex(where: {$0.idGroup == idGroup}){
                await insertInlistOfCommitsPerGroup(index: index, idGroup: idGroup)
                return listOfCommitsPerGroup[index].listOfCommits
            }
            return []
        }
    }
    
    func deleteCommits(listOfIds : [String]? = nil , listOfCommits : [CommentModel]? = nil) async -> Bool?{
        var deletedAll : Bool? = true
        if let listOfIds{
            for id in listOfIds {
                if let _ = await DatabaseInterface.shared.delete(id: id, table: .comment){
                    
                }
                else{
                    print("NAO FOI POSSÍVEL APAGAR COMNTÁRIO EM CommentController/deleteCommits")
                    deletedAll = false
                }
            }
        }
        else if let listOfCommits{
            for commit in listOfCommits {
                if(commit.id != nil){
                    if let _ = await DatabaseInterface.shared.delete(id: commit.id!, table: .comment){
                        
                    }
                    else{
                        print("NAO FOI POSSÍVEL APAGAR COMNTÁRIO EM CommentController/deleteCommits")
                        deletedAll = false
                    }
                }
                else{
                    print("NAO FOI POSSÍVEL APAGAR COMNTÁRIO, ID NULO EM CommentController/deleteCommits")
                    deletedAll = false
                }
            }
        }
        return deletedAll
    }
    
    private func insertInlistOfCommitsPerUser(index : Int,idUser : String) async{
        let relations : [CommentModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idUser, table: .comment, field: userIdFieldName)
        for relation in relations{
            if let indexRelation = listOfCommitsPerUser[index].listOfCommits.firstIndex(where:{$0.id == relation.id}){
                listOfCommitsPerUser[index].listOfCommits[indexRelation] = relation
            }
            else{
                listOfCommitsPerUser[index].listOfCommits.append(relation)
            }
        }
    }
    
    private func insertInlistOfCommitsPerGroup(index : Int,idGroup : String) async{
        let relations : [CommentModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idGroup, table: .comment, field: groupIdFieldName)
        for relation in relations{
            if let indexRelation = listOfCommitsPerGroup[index].listOfCommits.firstIndex(where:{$0.id == relation.id}){
                listOfCommitsPerGroup[index].listOfCommits[indexRelation] = relation
            }
            else{
                listOfCommitsPerGroup[index].listOfCommits.append(relation)
            }
        }
    }
    
    private func insertInlistOfCommitsPerActivity(index : Int,idActivity : String) async{
        let relations : [CommentModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idActivity, table: .comment, field: groupIdFieldName)
        for relation in relations{
            if let indexRelation = listOfCommitsPerActivity[index].listOfCommits.firstIndex(where:{$0.id == relation.id}){
                listOfCommitsPerActivity[index].listOfCommits[indexRelation] = relation
            }
            else{
                listOfCommitsPerActivity[index].listOfCommits.append(relation)
            }
        }
    }
}
