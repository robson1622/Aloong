//
//  ListElementInputSelector.swift
//  Macro
//
//  Created by Robson Borges on 09/08/24.
//

import SwiftUI

struct ListElementInputSelector: View {
    let title : String
    let options : [String]
    @Binding var pointsSystem : String
    
    var body: some View {
        
        HStack{
            Text(title)
                .font(.callout)
                .bold()
                .frame(maxWidth: 120)
            HStack{
                Picker("Opções", selection: $pointsSystem) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Isso mostra o Picker como um menu suspenso
                
                
            }
            Spacer()
        }
    }
}

#Preview {
    ListElementInputSelector(title: "Exemple of title" ,options: ["Dias ativos","Calorias","Distancia","Tempo"],pointsSystem: .constant("Distancia"))
}
