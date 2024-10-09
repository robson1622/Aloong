//
//  ActivityViewCreate.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var controller : GeneralController
    @State var userOwner : Bool = false
    let activity : ActivityModel
    let user : UserModel
    let imagesString : [String]
    @State var numberOfAloongs : Int = 12
    @State var aloongActive : Bool = false
    @State var atualTab : Int = 0
    
    let edit : String = NSLocalizedString("Edit", comment: "Texto do botão para editar a atividade")
    var body: some View {
        VStack{
            Header(trailing: [AnyView(
                VStack{
                    if(userOwner){
                        Button(action:{
                            
                        }){
                            Text(edit)
                                .font(.callout)
                                .foregroundColor(.roxo3)
                        }
                    }
                }
            )],onTapBack: {
                for image in imagesString{
                    BucketOfImages.shared.removeImageOfRAM(url: image)
                }
            })
            UserHeader(model: user, subtitle: dateToLocalizedString( activity.date), activieShare: false, onTapShare: {})
            ZStack{
                TabView {
                    ForEach(imagesString.indices, id: \.self) { i in
                        ImageLoader(url: imagesString[i], squere: true, largeImage: true)
                            .overlay(
                                VStack {
                                    HStack {
                                        Spacer()
                                        // Indicador de páginas dentro da imagem
                                        Text("\(i + 1) / \(imagesString.count)")
                                            .font(.footnote)
                                            .bold()
                                            .padding(4)
                                            .background(Color.branco.opacity(0.8))
                                            .foregroundColor(.preto)
                                            .cornerRadius(4)
                                            .padding(8)
                                    }
                                    Spacer()
                                }
                            )
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                VStack{
                    Spacer()
                    HStack{
                        if let duration = activity.duration{
                            MetricsComponent(icon: .duration, value:timeIntervalToString( duration))
                        }
                        if(activity.distance != nil){
                            MetricsComponent(icon: .distance, value: String(format: "%.1f", activity.distance!))
                        }
                        if(activity.steps != nil){
                            MetricsComponent(icon: .steps, value: String(format: "%.1f", activity.steps!))
                        }
                        Spacer()
                    }
                    .padding(.bottom,8)
                    .padding(.leading,12)
                }
            }
            .frame(width: 342, height: 426)
            .padding(.vertical,12)
            
            HStack{
                Text(activity.title)
                    .font(.title3)
                    .foregroundColor(.preto)
                Spacer()
            }
            .padding(.top,12)
            HStack{
                Text(activity.description)
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray))
                Spacer()
            }
            HStack{
                //AloongComponent(marcador: $numberOfAloongs, active: $aloongActive)
                Spacer()
            }
            Spacer()
        }
        .padding(24)
        .onAppear{
        }
        .refreshable {
            
        }
        .ignoresSafeArea()
        .background(Color(.branco))
    }
    
    func update(){
        print("FALTA CODAR ActivityView/update")
    }
    
    func timeIntervalToString(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours)h\(minutes)m"
    }
    
    func dateToLocalizedString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Usa a localização atual do dispositivo
        formatter.dateStyle = .long // Formato longo, adequado para exibir dia, mês, ano
        formatter.timeStyle = .short // Formato curto para horas e minutos
        
        return formatter.string(from: date)
    }
}

#Preview {
    ActivityView(activity: activityexemple, user: usermodelexemple5,imagesString: [])
}
