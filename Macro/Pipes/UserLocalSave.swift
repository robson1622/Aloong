//
//  UserLocalSaveProtocol.swift
//  Macro
//
//  Created by Robson Borges on 19/08/24.
//

import Foundation



class UserLocalSave{
    
    let userKey : String = "user"
    let onboardingSkip : String = "onboard skip"
    
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
    
    func saveOnboardingSkip(skip : Bool){
        do {
            let data = try JSONEncoder().encode(skip)
            UserDefaults.standard.set(data, forKey: onboardingSkip)
        } catch {
            print("Erro ao salvar o usuário: \(error)")
        }
    }
    
    func loadOnboardingSkip() -> Bool?{
        guard let data = UserDefaults.standard.data(forKey: onboardingSkip) else {
            return nil
        }
        
        do {
            let result = try JSONDecoder().decode(Bool.self, from: data)
            return result
        } catch {
            print("Erro ao carregar o Onboarding Skip: \(error)")
            return nil
        }
    }
    
    func deleteOnboardingSkip(){
        UserDefaults.standard.removeObject(forKey: onboardingSkip)
    }
}
