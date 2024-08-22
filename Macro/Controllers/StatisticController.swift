//
//  StatisticController.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import Foundation


class StatisticController: ObservableObject{
    
//   private var listOfActivities : Activity?
    private var listOfMembers : UserModel?
    
    // estas listas seram ordenadas de acordo a colocação do usuário
    @Published var activeDaysPositions : UserModel?
    var caloriesPositions : UserModel?
    var distancePositions : UserModel?
    var intensityPositions : UserModel?
    
    @Published var lider : UserModel?
    @Published var you : UserModel?
    @Published var countDown : Int?
    
    var totalActivities : Int?
    var totalCalories : Int?
    var totalDistance : Int?
    
    // calcula todas as estatísticas do grupo
    func calculate(group: GroupModel){
        //precisa solicitar o grupo ao servidor
        //precisa solicitar todas as atividades do grupo
        
    }
}
