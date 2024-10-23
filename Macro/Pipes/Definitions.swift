//
//  Definitions.swift
//  Macro
//
//  Created by Robson Borges on 09/08/24.
//

import Foundation
import SwiftUI
//let add : String =  NSLocalizedString("Add new friend", comment: "")
struct UserModelNames {
    static let name : String =  NSLocalizedString("Name", comment: "")
    static let nickname : String = NSLocalizedString("Nick name", comment: "")
    static let birthdate : String = NSLocalizedString("Birth date" , comment: "")
    static let email : String = NSLocalizedString("Email", comment: "")
    
}

//let aniversario = Date("2023-05-19 10:30:00 +0000")
let usermodelexemple : UserModel = UserModel(id: "ebv7e128hdixnws", name: "brabs",email: "@mail.com",userimage: "/21e11c0e43f2ab517949d1834ef5e43f.jpg")
let usermodelexemple2 : UserModel = UserModel(id: "hew9829823giucgosa", name: "nico",email: "@mail.com",userimage: "/21e11c0e43f2ab517949d1834ef5e43f.jpg")
let usermodelexemple3 : UserModel = UserModel(id: "dnvuudbvscw98yw-0", name: "robis",email: "@mail.com",userimage: "/21e11c0e43f2ab517949d1834ef5e43f.jpg")
let usermodelexemple4 : UserModel = UserModel(id: "cnkjbsdg8y8quwh", name: "yan",email: "@mail.com",userimage: "/21e11c0e43f2ab517949d1834ef5e43f.jpg")
let usermodelexemple5 : UserModel = UserModel(id: "vcbdy8729ihdoih", name: "flor",email: "@mail.com",userimage: "/21e11c0e43f2ab517949d1834ef5e43f.jpg")



struct GroupModelNames {
    static let title : String =  NSLocalizedString("Title", comment: "")
    static let description : String =  NSLocalizedString("Description", comment: "")
    static let startDate : String =  NSLocalizedString("Start date", comment: "")
    static let endDate : String =  NSLocalizedString("End date", comment: "")
    static let scoreType : String =  NSLocalizedString("Points system", comment: "")
}

let exempleGroup : GroupModel = GroupModel(id: "ebv7e128hdixnws", idUser: "sjcb87w801hdo8y7cguos", title: "Grupo da Fibração", description: "Exemplo de grupo para mostrar como ficaria quando estivesse um pronto para começar a ver as organizações de texto, de imagens e lista de coisas, com um texto maior podemos ver também como ficaria a quebra de linhas do campo de texto.", startDate: Date(), endDate: Date(), scoreType: "Dias ativos",invitationCode: "A2P9")


let pointsSystemNames : [String] = [NSLocalizedString("Active days", comment: ""),NSLocalizedString("Calories", comment: ""),NSLocalizedString("Distance", comment: ""),NSLocalizedString("Intensity", comment: "")]
let pointsSystemNamesForComparations : [String] = ["Active days","Calories","Distance","Intensity"]


let noimage : String = "noimage.jpg"

struct ActivityModelNames{
    static let title : String =  NSLocalizedString("Title", comment: "")
    static let description : String =  NSLocalizedString("Description", comment: "")
    static let otherPeople : String = NSLocalizedString("Other people", comment: "")
    static let date : String =  NSLocalizedString("Date", comment: "")
    static let distance : String =  NSLocalizedString("Distance", comment: "")
    static let calories : String =  NSLocalizedString("Calories", comment: "")
    static let duration : String =  NSLocalizedString("Duration", comment: "")
    static let steps : String =  NSLocalizedString("Steps", comment: "")
    
    static let distanceIcon : String = "arrow.triangle.swap"
    static let caloriesIcon : String = "flame"
    static let durationIcon : String = "clock"
    static let stepsIcon : String = "figure.walk"
    static let addOtherUserIcon : String = "person.crop.circle.badge.plus"
}

let activityexemple = ActivityModel(id: "0000", title: "Exemple title", description: "Exemple Name", date: Date(), distance: 12.35, calories: 1209.32, duration: TimeInterval(), steps: 19240)

struct statesOfMembers{
    static let owner : String = "owner"
    static let member : String = "member"
    static let blocked : String = "blocked"
}

struct statesOfActivityRelation{
    static let owner : String = "owner"
    static let aloong : String = "aloong"
}
