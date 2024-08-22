//
//  UserLocalSaveProtocol.swift
//  Macro
//
//  Created by Robson Borges on 19/08/24.
//

import Foundation



class UserLocalSave{
    
    let userKey : String = "user"
    
    func saveUser(user : UserModel) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: userKey)
        } catch {
            print("Erro ao salvar o usuário: \(error)")
        }
    }
    
    func loadUser() -> UserModel? {
        guard let data = UserDefaults.standard.data(forKey: userKey) else {
            return nil
        }
        
        do {
            let user = try JSONDecoder().decode(UserModel.self, from: data)
            return user
        } catch {
            print("Erro ao carregar o usuário: \(error)")
            return nil
        }
    }
    
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
