//
//  NewActivityButton.swift
//  Macro
//
//  Created by Robson Borges on 30/08/24.
//
import SwiftUI

struct NewActivityButton: View {
    @Environment(\.colorScheme) var colorScheme
    let onTap : () -> Void
    let groupId : String?
    var navigateAuto : Bool = true
    var body: some View {
        Button(action:{
            onTap()
            if(navigateAuto){
                self.navigate()
            }
        }){
            ZStack{
                Circle()
                    .frame(width: 70, height: 70)
                    .foregroundStyle( Color(.azul4))
                Image(systemName: "plus")
                    .font(.title)
                    .bold()
                    .foregroundStyle(colorScheme == .dark ? Color(.black) : Color(.white))
            }
        }
    }
    
    private func navigate(){
        if(groupId != nil && navigateAuto){
            //ViewsController.shared.navigateTo(to: .createActivity((controller.user.user?.id)!,groupId!))
            ViewsController.shared.navigateTo(to: .camera)
        }
    }
}

#Preview {
    NewActivityButton(onTap: {},groupId: "")
}
