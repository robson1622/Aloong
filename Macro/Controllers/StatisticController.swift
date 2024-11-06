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
    var position : Int
}

class StatisticController: ObservableObject{
    static var shared = StatisticController()
    private let idUserActivityGroupFieldName = "idUser"
    //  private var listOfActivities : Activity?
    @Published var listOfPositionUser : [PointsOfUser]?

    @Published var first : PointsOfUser?
    @Published var second : PointsOfUser?
    @Published var third : PointsOfUser?
    
    @Published var you : PointsOfUser?
    // calcula todas as estatísticas do grupo
    // Calcula todas as estatísticas do grupo
    func calculate(idGroup: String, idMyUser: String, activitiesCompleteList: [ActivityCompleteModel], listOfUsers: [UserModel]) {
            var userScores: [UserModel: Set<Date>] = [:]

            for user in listOfUsers {
                userScores[user] = Set()
            }

            for activityComplete in activitiesCompleteList {
                if let activity = activityComplete.activity {
                    let activityDate = Calendar.current.startOfDay(for: activity.date)

                    userScores[activityComplete.owner]?.insert(activityDate)
                    for user in activityComplete.usersOfthisActivity {
                        userScores[user]?.insert(activityDate)
                    }
                }
            }

            var result: [PointsOfUser] = userScores.map { (user, dates) in
                PointsOfUser(user: user, points: dates.count, position: 0)
            }
            result.sort { $0.points > $1.points }

            for i in 0..<result.count {
                if i == 0 {
                    self.first = result[i]
                } else if i == 1 {
                    self.second = result[i]
                } else if i == 2 {
                    self.third = result[i]
                }
                if result[i].user.id == idMyUser {
                    self.you = result[i]
                }
                result[i].position = i + 1
            }

            DispatchQueue.main.sync {
                self.listOfPositionUser = result
            }
        }


    
}
