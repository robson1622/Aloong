//
//  ActivityUserController .swift
//  Macro
//
//  Created by Robson Borges on 04/09/24.
//

import Foundation

class ActivityUserController: ObservableObject{
    @Published var listOfActivityUser : [ActivityUserModel] = []
    
    func load(idUser: String)async {
        listOfActivityUser = await ActivityUserDao.shared.readAllActivityUserOfUser(idUser: idUser)
    }
}
