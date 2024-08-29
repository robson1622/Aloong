//
//  MemberDao.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation

class MemberDao : ObservableObject{
    static var shared : MemberDao = MemberDao()
    
    func create(model : MemberModel)async  -> Bool?{
        let idModel = FirebaseInterface.shared.createDocument(model: model)
        let withIdModel = MemberModel(groupId: model.groupId, userId: model.userId, state: model.state, id: idModel)
        if let _ = await FirebaseInterface.shared.updateDocument(model: withIdModel){
            return true
        }
        return nil
    }
    
    func delete(model : GroupModel){
        print("Função  delete (MemberDao) : Não feita")
    }
    
    func update(model : GroupModel){
        print("Função  update (MemberDao) : Não feita")
    }
    
    
}
