//
//  ReactionController.swift
//  Macro
//
//  Created by Robson Borges on 17/09/24.
//
import Foundation

class ReactionController : ObservableObject{
    static var shared = ReactionController()
    @Published var listOfReactions : [ReactionModel] = []
    private let idGroupFieldName : String = "idGroup"
    private let idCommentFieldName : String = "idComment"
    private let idActivityFieldName : String = "idActivity"
    private let idUserFieldName : String = "idUser"
    
    func readAllReactionsOfAGroup(idGroup : String) async -> [ReactionModel]{
        let list : [ReactionModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: idGroup, table: .reaction, field: idGroupFieldName)
        for reaction in list{
            if let index = listOfReactions.firstIndex(where : {$0.id == reaction.id}){
                DispatchQueue.main.sync{
                    listOfReactions[index] = reaction
                }
            }else{
                DispatchQueue.main.sync{
                    listOfReactions.append(reaction)
                }
            }
        }
        print("\n TOTAL DE \(listOfReactions.count) REACTIONS \n")
        return listOfReactions
    }
    
    func findAnReaction(idGroup: String, idUser : String, idActivity : String) async -> ReactionModel?{
        _ = await self.readAllReactionsOfAGroup(idGroup: idGroup)
        if let index = listOfReactions.firstIndex(where: {$0.idUser == idUser && $0.idActivity == idActivity }){
            return listOfReactions[index]
        }
        return nil
    }
}
