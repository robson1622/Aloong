//
//  NewActivityButton.swift
//  Macro
//
//  Created by Robson Borges on 30/08/24.
//

import SwiftUI

struct NewActivityButton: View {
    let onTap : () -> Void
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
                    .foregroundStyle(Color(.verde2))
                Image(systemName: "plus")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color(.black))
            }
        }
    }
    
    private func navigate(){
        ViewsController.shared.navigateTo(to: .createActivity)
    }
}

#Preview {
    NewActivityButton(onTap: {})
}
