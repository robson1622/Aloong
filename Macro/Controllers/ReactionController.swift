//
//  ReactionController.swift
//  Macro
//
//  Created by Robson Borges on 17/09/24.
//
import Foundation

class ReactionController : ObservableObject{
    static var shared = ReactionController()
    @Published private var listOfSavedReactions : [savedReactions] = []
    private let idGroupFieldName : String = "idGroup"
    private let idCommentFieldName : String = "idComment"
    private let idActivityFieldName : String = "idActivity"
    private let idUserFieldName : String = "idUser"
    
    private struct savedReactions{
        var idGroup : String
        var listOfReactions : [ReactionModel]
    }
    func readAllReactionsOfAUser(idUser : String) async -> [ReactionModel]{
        var reactions : [ReactionModel] = []
        if listOfSavedReactions.isEmpty{
            reactions = await DatabaseInterface.shared.readDocuments(isEqualValue: idUser, table: .reaction, field: idUserFieldName)
        }
        else{
            for saved in listOfSavedReactions{
                if let reactionsOfUser = saved.listOfReactions.filter({$0.idUser == idUser}).first{
                    reactions.append(reactionsOfUser)
                }
            }
        }
        return reactions
    }
    
    func readAllReactionsOfAGroup(idGroup : String) async -> [ReactionModel]{
        let reactions : [ReactionModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idGroup, table: .reaction, field: idGroupFieldName)
        if let indexSaved = listOfSavedReactions.firstIndex(where: {$0.idGroup == idGroup}){
            for reaction in reactions{
                if let index = listOfSavedReactions[indexSaved].listOfReactions.firstIndex(where: {$0.id == reaction.id}){
                    listOfSavedReactions[indexSaved].listOfReactions[index] = reaction
                }
                else{
                    listOfSavedReactions[indexSaved].listOfReactions.append(reaction)
                }
            }
            return listOfSavedReactions[indexSaved].listOfReactions
        }
        else{
            let newSavedReactions : savedReactions = savedReactions(idGroup: idGroup, listOfReactions: reactions)
            listOfSavedReactions.append(newSavedReactions)
            return reactions
        }
        
    }
    
    func readAllReactionsOfAActivity(idActivity : String, idGroup : String) async -> [ReactionModel]{
        //verifica se já exite
        if let index = listOfSavedReactions.firstIndex(where: {$0.idGroup == idGroup}){
            let reaction = listOfSavedReactions[index].listOfReactions.filter({$0.idActivity == idActivity})
            if !reaction.isEmpty{
                return reaction
            }
        }
        // caso não exita nos buscamos
        let reactions : [ReactionModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idActivity, table: .reaction, field: idActivityFieldName)
        return reactions.filter({$0.idGroup == idGroup})
    }
    
    func readAllReactionsOfAComment(idComment : String, idGroup : String) async -> [ReactionModel]{
        //verifica se já exite
        if let index = listOfSavedReactions.firstIndex(where: {$0.idGroup == idGroup}){
            let reaction = listOfSavedReactions[index].listOfReactions.filter({$0.idComment == idComment})
            if !reaction.isEmpty{
                return reaction
            }
        }
        // caso não exita nos buscamos
        let reactions : [ReactionModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idComment, table: .reaction, field: idCommentFieldName)
        return reactions.filter({$0.idGroup == idGroup})
    }
}
