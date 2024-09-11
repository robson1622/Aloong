//
//  ActivityModel.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import Foundation


struct ActivityModel : Codable, Hashable, Identifiable{
    var id : String?
    var title : String?
    var description : String?
    var date : Date?
    var distance : Float?
    var calories : Float?
    var duration : TimeInterval?
    var steps : Int?
    var image : String?
}
