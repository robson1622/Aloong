//
//  Enums.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation

enum dataBaseType {
    case user,group,member;
}

enum LoadingStates {
    case idle,loading,done;
}

func LoadingStateString(_ type : LoadingStates) -> String{
    switch type {
    case .idle:
        return "Idle"
    case .loading:
        return "Loading"
    case .done:
        return "Done"
    }
}
