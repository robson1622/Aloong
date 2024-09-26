//
//  GroupScoreBoardView.swift
//  Macro
//
//  Created by Robson Borges on 22/09/24.
//

import SwiftUI

struct GroupScoreBoardView: View {
    @Environment(\.colorScheme) var colorScheme
    let model : GroupModel
    @State var totalDays : Int = 0
    @State var lastDays : Int = 0
    @State var lider : PointsOfUser
    @State var you : PointsOfUser
    
    let liderText : String = NSLocalizedString("Líder", comment: "Titulo da view de grupo que denota o lider")
    let youText : String = NSLocalizedString("You", comment: "Titulo da view de grupo que denota o lider")
    let daysLeft : String = NSLocalizedString("Days left", comment: "texto da contagem de dias restantes")
    let withoutActivityText : String = NSLocalizedString("Oops, \n there's nothing here yet...", comment: "Texto que fala que não há atividadesainda")
    var body: some View {
        VStack(alignment: .center, spacing: 24) {//card
            
            HStack(alignment: .center) {//seu desafio
                Text(model.title)
                    .font(.title2)
                    .foregroundColor(.preto)
                Spacer()
            }
            HStack (alignment:.center, spacing: 22){
                
                HStack (spacing: 9){
                    ImageLoader(url : lider.user.userimage,squere: false,largeImage: false)
                    VStack (alignment:.leading){
                        // Callout/Emphasized
                        Text("\(lider.points)")
                            .font(.callout)
                            .foregroundColor(.preto)
                            .bold()
                        
                        // Caption1/Regular
                        Text(liderText)
                            .font(.caption)
                            .foregroundColor(.preto)
                    }
                    Spacer()
                }
                
                RoundedRectangle(cornerRadius: 5) // Ajuste o cornerRadius conforme necessário
                    .frame(width: 0.5, height: 44) // Altere o width conforme necessário
                    .foregroundColor(.preto) // Define a cor de preenchimento como transparente
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 0.75) // Define a borda do retângulo
                    )
                
                HStack (spacing: 9){
                    ImageLoader(url: you.user.userimage, squere: false,largeImage: false)
                    VStack (alignment:.leading){
                        // Callout/Emphasized
                        Text("\(you.points)")
                            .font(.callout)
                            .foregroundColor(.preto)
                            .bold()
                        
                        // Caption1/Regular
                        Text(youText)
                            .font(.caption)
                            .foregroundColor(.preto)
                    }
                    Spacer()
                }
                
            }
            ProgressView(percent: $lastDays, total: $totalDays, unity: daysLeft)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(24)
        .frame(width:342, alignment: .top)
        .background( colorScheme == .dark ? .cinza : .branco)
        .cornerRadius(6)
        .shadow(color: .black.opacity(0.1), radius: 24.88501, x: 0, y: 8.295)
        .onAppear {
            calculateProgress(startDate: model.startDate, endDate: model.endDate)
        }
        
    }
    func calculateProgress(startDate: Date, endDate: Date) {
        totalDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        lastDays = min(max(daysPassed, 0), totalDays) // Garantir que percent esteja no intervalo válido
    }
}

#Preview {
    GroupScoreBoardView(model: exempleGroup, lider: PointsOfUser(user: usermodelexemple, points: 3), you: PointsOfUser(user: usermodelexemple4, points: 10))
}
