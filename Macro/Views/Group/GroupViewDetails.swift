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
    @State var textForInvitation : String = "Use this code for aloong with my challenge :"
    @State private var showShare = false
    @State private var totalDays : Int = 0
    @State private var lastDays : Int = 0
    
    let inviteFrindText : String = NSLocalizedString("Invite friends", comment: "Texto do botão de convidar amigo")
    let leftDays : String = NSLocalizedString("Left days", comment: "Marcador de dias que faltam")
    let ranking : String = NSLocalizedString("RANKING", comment: "Texto do titulo da view de details que mostra a classificação")
    let detailsOfGroupText : String = NSLocalizedString("Details of group", comment: "Texto do titulo da view de details que mostra os detalhes do grupo")
    let daysLeft : String = NSLocalizedString("Days left", comment: "texto da contagem de dias restantes")
    var body: some View {
        
        ZStack (alignment: .center){
            VStack(spacing: 36){
                Header(title: detailsOfGroupText,onTapBack: {} )
                VStack(spacing: 10){
                    HStack(alignment: .center) {//seu desafio
                        Text(group.title)
                            .font(.title2)
                            .foregroundColor(.preto)
                        Spacer()
                    }
                    Text(group.description)
                        .font(.callout)
                        .foregroundColor(.preto)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ProgressView(percent: $lastDays, total: $totalDays, unity: daysLeft)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(0)
                
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
                Spacer()
            }
            .padding(.vertical, 18)
        }
        .padding(24)
        .padding(.vertical,18)
        .frame(width: 390, height: 844)
        .background(.branco)
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
    GroupViewDetails(listOfPositions: [PointsOfUser(user: usermodelexemple, points: 12),
                                       PointsOfUser(user: usermodelexemple2, points: 8),
                                       PointsOfUser(user: usermodelexemple3, points: 6),
                                       PointsOfUser(user: usermodelexemple4, points: 24)], group: exempleGroup)
}
