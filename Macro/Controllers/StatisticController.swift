//
//  StatisticController.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import Foundation

struct PositionUser{
    var user : UserModel
    var points : Int
}

class StatisticController: ObservableObject{
    
//   private var listOfActivities : Activity?
    @Published var listOfUser : [UserModel]?
    @Published var listOfPositionUser : [PositionUser]?
    @Published var activitiesComplete : [ActivityCompleteModel]?
    
    @Published var lider : PositionUser?
    @Published var you : PositionUser?
    
    // calcula todas as estatísticas do grupo
    func calculate(idUser : String){
        if let activities = activitiesComplete, let users = listOfUser {
            var pointsCounter: [PositionUser] = []
            // Contar as atividades por usuário
            for user in users {
                let quantity = self.filterActivitiesByOwner(listActivities: activities, idUserAtual: user.id!)
                pointsCounter.append(PositionUser(user: user, points: quantity.count))
            }
            // Ordenar os usuários pela pontuação, do maior para o menor
            let sortedMembers = pointsCounter.sorted { $0.points > $1.points }
            
            lider = sortedMembers.first
            you = sortedMembers.first { $0.user.id == idUser }  // Substituir por lógica para pegar o usuário atual
        } else {
            print("LISTA DE ATIVIDADES COMPLETAS OU LISTA DE USUÁRIOS NULA EM StatisticController/calculate")
        }
    }
    
    private func filterActivitiesByOwner(listActivities: [ActivityCompleteModel], idUserAtual: String) -> [ActivityCompleteModel] {
        return listActivities.filter { $0.owner.id == idUserAtual }
    }
}
