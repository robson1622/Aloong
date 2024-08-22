//
//  Functions.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation



func formatDate(date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: date ?? Date())
    }


func differenceInDays(start: Date?, end : Date?) -> Int{
    if(start == nil || end == nil){
        return 0
    }
    return Calendar.current.dateComponents([.day], from: start!, to: end!).day ?? 0
}
