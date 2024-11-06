//
//  DetailsGroupView.swift
//  Macro
//
//  Created by Nicole Cardoso Machado on 04/09/24.
//

import SwiftUI

struct GroupViewDetails: View {
    @Environment(\.colorScheme) var colorScheme
    @State var listOfPositions : [PointsOfUser]
    let group : GroupModel
    @State var total : Int = 0
    @State var percent : Int = 0
    
    @State private var showShare = false
    @State private var totalDays : Int = 0
    @State private var lastDays : Int = 0
    @State private var sucessoncopy : Bool = false
    
    let inviteFrindText : String = NSLocalizedString("Invite friends", comment: "Texto do botão de convidar amigo")
    let leftDays : String = NSLocalizedString("Left days", comment: "Marcador de dias que faltam")
    let ranking : String = NSLocalizedString("RANKING", comment: "Texto do titulo da view de details que mostra a classificação")
    let detailsOfGroupText : String = NSLocalizedString("DETAILS", comment: "Texto do titulo da view de details que mostra os detalhes do grupo")
    let daysLeft : String = NSLocalizedString("Days left", comment: "texto da contagem de dias restantes")
    let copyCode : String = NSLocalizedString("Copy code :", comment: "texto do botão de copiar o código")
    let sucessText : String = NSLocalizedString("Sucess on copy", comment: "Texto que informa que o texto foi copiado com sucesso")
    let textForInvitation : String = NSLocalizedString("Use this code for aloong with my challenge :",comment: "Texto que vai ser enviado para os amigos com o código")
    var body: some View {
        
        ZStack (alignment: .center){
            VStack {
                
                VStack(spacing: 36){
                    
                    VStack(spacing: 10){
                        HStack(alignment: .center) {//seu desafio
                            Text(group.title)
                                .font(.degular22)
                                .fontWeight(.medium)
                                .foregroundColor(.preto)
                            Spacer()
                            Image(systemName: "clock")
                                .foregroundStyle(Color(.preto))
                            
                            Text("\(lastDays) \(daysLeft)")
                                .foregroundStyle(Color(.preto))
                        }
                        Text(group.description)
                            .font(.callout)
                            .foregroundColor(.preto)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack{
                            Button(action:{
                                UIPasteboard.general.string = group.invitationCode
                                sucessoncopy = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    sucessoncopy = false
                                }
                            }){
                                HStack{
                                    Text("\(copyCode)")
                                        .font(.body)
                                        .foregroundColor(Color(.systemGray))
                                    
                                    Image(systemName: "document.on.document")
                                        .font(.body)
                                        .foregroundColor(.roxo3)
                                    
                                    Text("\(group.invitationCode ?? "")")
                                        .font(.body)
                                        .foregroundColor(.roxo3)
                                    
                                }
                            }
                            Spacer()
                        }
                        
                    }
                    .padding(.top,24)
                    
                    VStack(spacing: 8){
                        HStack{
                            Text(ranking)
                                .font(.caption)
                                .foregroundColor(.cinza2)
                                .padding(.leading, 4)
                            Spacer()
                        }
                        .padding(0)
                        
                        VStack(spacing:0){
                            ForEach(listOfPositions.indices, id: \.self) { index in
                                HStack{
                                    Text("\(index + 1)º   \(listOfPositions[index].user.name)")
                                        .font(.body)
                                        .foregroundColor(.preto)
                                    Spacer()
                                    Text("\(listOfPositions[index].points)")
                                        .font(.body)
                                        .foregroundColor(.cinza2)
                                }
                                .padding()
                                .background(.branco)
                                if(index != (listOfPositions.count-1)) {
                                    Divider()
                                        .padding(.leading, 16)
                                }
                            }
                        }
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8)
                    }
                    HStack{
                        Button(action:{
                            showShare.toggle()
                        }){
                            HStack{
                                Image(systemName: "square.and.arrow.up")
                                    .font(.body)
                                    .foregroundColor(colorScheme == .dark ? .black : .white)
                                
                                Text(inviteFrindText)
                                    .font(.body)
                                    .foregroundColor(colorScheme == .dark ? .black : .white)
                            }
                            .padding(.horizontal,20)
                            .padding(.vertical,14)
                            .background(Color(.roxo3))
                            .cornerRadius(12)
                            .padding(.top,35)
                        }
                        
                        
                    }
                    Spacer()
                    if sucessoncopy{
                        Text(sucessText)
                            .foregroundStyle(Color(.roxo3))
                            .font(.callout)
                            .italic()
                            .padding(8)
                            .background(Color(.roxo))
                            .cornerRadius(10)
                            .padding(.bottom,35)
                    }
                    
                }
                
                .padding(.horizontal,24)
            }
            .padding(.top,110)
            .background(
                Image(colorScheme == .dark ? "background_dark" : "backgroundLacoVerde")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            
            VStack{
                Header(title: detailsOfGroupText,onTapBack: {} )
                Spacer()
            }
            
        }
        .ignoresSafeArea()
        .frame(width: 390, height: 844)
        .onAppear{
            let list = listOfPositions.sorted(by: { $0.points > $1.points})
            listOfPositions = list
            self.calculateProgress(startDate: group.startDate, endDate: group.endDate)
        }
        .sheet(isPresented: $showShare, content: {
            ShareSheet(activityItems: [textForInvitation,group.invitationCode ?? ""])
                .presentationDetents([.fraction(0.55)])
        })
    }
    func copyToClipboard(code: String) {
            UIPasteboard.general.string = code
        }
    
    func calculateProgress(startDate: Date, endDate: Date) {
        totalDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        lastDays = min(max(daysPassed, 0), totalDays) // Garantir que percent esteja no intervalo válido
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    GroupViewDetails(listOfPositions: [PointsOfUser(user: usermodelexemple, points: 12,position: 1),
                                       PointsOfUser(user: usermodelexemple2, points: 8,position: 1),
                                       PointsOfUser(user: usermodelexemple3, points: 6,position: 2),
                                       PointsOfUser(user: usermodelexemple4, points: 24,position: 3)], group: exempleGroup)
}
