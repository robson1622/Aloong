//
//  MembersController.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import Foundation


class MembersController: ObservableObject{
    @Published var listOfMembers : [MemberModel] = []
    
    func loadMembers(idGroup : String) async {
        
    }
    
    func joinInMember(idGroup : String, idUser : String) async{
        
    }
    
    func removeMember(idGroup : String, idUser: String) async{
        
    }
}
