//
//  ActivitiesController.swift
//  Macro
//
//  Created by Robson Borges on 03/09/24.
//

import Foundation


class ActivitiesController: ObservableObject{
    @Published var activities : [ActivityModel] = []
    @Published var groupsRelationActivities : [GroupActivityModel] = []
    @Published var userRelationActivities : [UserActivityModel] = []
    
    func load(){
        
    }
    //retorna todas as atividades do usuário
    func getActivitiesOfUser(){
        
    }
    //retorna todas as atividades do grupo
    func getActivitiesOfGroup(){
        
    }
    //restorna todos os usuário relacionados com a atividade
    func getUserOfActivityOfGroup(activityId: String, groupId: String) -> [UserModel]{
        
        return []
    }
    //retorna usuário pertencentes a um grupo
    //retorna a quantidade de usuários de um grupo
    //restorna a quantidade de pessoas marcadas em uma atividade
}
