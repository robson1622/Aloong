//
//  ActivityGroupController.swift
//  Macro
//
//  Created by Robson Borges on 04/09/24.
//

import Foundation

class ActivityGroupController: ObservableObject{
    @Published var listOfActivityGroup : [ActivityGroupModel] = []
    
    func load(idGroup : String)async {
        listOfActivityGroup = await ActivityGroupDao.shared.readAllGroupActivitiesOfGroup(idGroup: idGroup)
    }
    
    
}
