//
//  GroupViewCard.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupViewCard: View {
    let model : GroupModel
    var noImage : String = NSLocalizedString("No image", comment: "aviso de sem imagem")
    var noTitle : String = NSLocalizedString("No named", comment: "texto que avisa que o grupo não possui nome, esse caso não deve acontecer, mas caso aconteça...")
    var daysLeft : String = NSLocalizedString("Days left", comment: "Texto que fala quantos dias faltam para o desafio acabar")
    
    var body: some View {
        VStack{
            HStack{
                Text(model.title ?? noTitle)
                    .font(.title3)
                Spacer()
                
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 40)
                    Image(systemName: "heart")
                        .foregroundColor(Color(.black))
                }
            }
            HStack{
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 40)
                    .padding(.trailing,-20)
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 40)
                    .padding(.trailing,-20)
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 40)
                Spacer()
                
            }
            .padding(.vertical,16)
            HStack{
//                ProgressView(percent: differenceInDays(start: model.startDate, end: Date()), total: differenceInDays(start: model.startDate, end: model.endDate), unity: daysLeft )
//                    .padding(.vertical,16)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

#Preview {
    GroupViewCard(model:exempleGroup)
}
