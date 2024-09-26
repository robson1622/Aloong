//
//  StatisticController.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import Foundation

struct PointsOfUser : Decodable, Encodable, Equatable, Hashable{
    var user : UserModel
    var points : Int
}

class StatisticController: ObservableObject{
    static var shared = StatisticController()
    private let idUserActivityGroupFieldName = "idUser"
//   private var listOfActivities : Activity?
    @Published var listOfPositionUser : [PointsOfUser]?
    
    @Published var lider : PointsOfUser?
    @Published var you : PointsOfUser?
    
    // calcula todas as estatísticas do grupo
    func calculate(idGroup: String, idMyUser: String, activitiesCompleteList: [ActivityCompleteModel], listOfUsers: [UserModel]) async -> [PointsOfUser] {
        // Dicionário para armazenar a pontuação dos usuários
        var userScores: [UserModel: Set<Date>] = [:]

        // Inicializa o dicionário de pontuação com todos os usuários e zero atividades
        for user in listOfUsers {
            userScores[user] = Set()
        }

        // Itera sobre cada atividade completa
        for activityComplete in activitiesCompleteList {
            // Verifica se a atividade tem um valor válido
            if let activity = activityComplete.activity {
                let activityDate = Calendar.current.startOfDay(for: activity.date)

                // Conta o criador da atividade (owner)
                if userScores[activityComplete.owner] == nil {
                    userScores[activityComplete.owner] = Set()
                }
                userScores[activityComplete.owner]?.insert(activityDate)

                // Conta os participantes da atividade (usersOfthisActivity)
                for user in activityComplete.usersOfthisActivity {
                    if userScores[user] == nil {
                        userScores[user] = Set()
                    }
                    userScores[user]?.insert(activityDate)
                }
            }
        }

        // Converte o dicionário de pontuação para uma lista de PointsOfUser
        var result: [PointsOfUser] = userScores.map { (user, dates) in
            PointsOfUser(user: user, points: dates.count) // A pontuação é a quantidade de dias únicos
        }
        listOfPositionUser = result
        // Ordena os resultados por pontuação (opcional, caso queira já ordenar por pontos)
        result.sort { $0.points > $1.points }

        // Armazena o usuário atual e o líder (opcional, se estiver usando essas variáveis em outro lugar)
        if let index = result.firstIndex(where: { $0.user.id == idMyUser }) {
            you = result[index] // Atualiza a variável com o usuário atual
        }
        if let topUser = result.max(by: { $0.points < $1.points }) {
            lider = topUser // Atualiza a variável com o líder
        }

        return result
    }

    
}
