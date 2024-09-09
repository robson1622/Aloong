//
//  AloongComponent.swift
//  Macro
//
//  Created by Robson Borges on 05/09/24.
//

import SwiftUI

struct AloongComponent: View {
    @Binding var marcador : Int
    @Binding var active : Bool
    var body: some View {
        Button(action:{
            if(active){
                marcador = marcador - 1
            }
            else{
                marcador = marcador + 1
            }
            active.toggle()
        }){
            ZStack{
                ZStack{
                    Circle()
                        .frame(width: 35,height: 35)
                        .foregroundColor(active ? .azul2 : Color(.systemGray4))
                    Image(systemName: "hands.and.sparkles")
                        .font(.callout)
                        .foregroundColor(.white)
                }
                ZStack{
                    Circle()
                        .frame(width: 16,height: 16)
                        .foregroundColor(active ? .azul4 : Color(.systemGray))
                    Text("\(marcador)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding(.bottom,24)
                .padding(.leading,24)
                
            }
        }
    }
    
}

#Preview {
    AloongComponent(marcador: .constant(12), active: .constant(true))
}
