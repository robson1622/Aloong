//
//  GroupView.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupView: View {
    @EnvironmentObject var controller : GeneralController
    @State var image : UIImage?
    @State var showCamera : Bool = false
    let model : GroupModel
    @State var totalDays : Int = 0
    @State var lastDays : Int = 0
    @State var lider : PositionUser?
    @State var you : PositionUser?
    @State var listActivities : [ActivityCompleteModel]?
    
    let youCgallenge : String = NSLocalizedString("Your challenger", comment: "Caso não haja nome no grupo, este nome será mostrado")
    let liderText : String = NSLocalizedString("Líder", comment: "Titulo da view de grupo que denota o lider")
    let youText : String = NSLocalizedString("You", comment: "Titulo da view de grupo que denota o lider")
    let daysLeft : String = NSLocalizedString("Days left", comment: "texto da contagem de dias restantes")
    let withoutActivityText : String = NSLocalizedString("Oops, \n there's nothing here yet...", comment: "Texto que fala que não há atividadesainda")
    var body: some View {
        
        ZStack (alignment: .center){//fundo
            ScrollView{
                VStack(spacing: 24){ //vstack geral
                    HStack(alignment: .center) {//logo + perfil
                        Image("aloong_logo")
                            .frame(width: 134, height: 41.07149)
                        Spacer()
                        ImageLoader(url: "")
                    }
                    .padding(.horizontal,24)
                    .padding(.top,45)
                    
                    card
                    
                    if(listActivities != nil){
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(listActivities!, id: \.id ){ index in
                                if(index.activity != nil){
                                    Button(action:{
                                        ViewsController.shared.navigateTo(to: .activity(index.activity!,index.owner))
                                    }){
                                        ActivityCard(activity: index.activity!, user: index.owner)
                                    }
                                }
                            }
                        }
                        .padding(0)
                        .frame(width: 342, alignment: .topLeading)
                    }
                    else{
                        Text(withoutActivityText)
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.black)
                    }
                }
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.branco)
            .onAppear{
                listActivities = controller.mainListActivities
                you = controller.statistic.you ?? PositionUser(user: usermodelexemple, points: 0)
                lider = controller.statistic.lider ?? you
            }
            
            VStack{
                Spacer()
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(stops: [
                                .init(color: Color.black.opacity(0), location: 0),
                                .init(color: Color.black.opacity(0.2), location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    
            }
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                NewActivityButton(onTap: {
                    showCamera = true
                }, groupId: model.id,navigateAuto: false)
            }
        }
        .onChange(of: image){ newvalue in
            if(image != nil){
                controller.activities.imagesForNewActivity = image!
                ViewsController.shared.navigateTo(to: .createActivity((controller.user.user?.id!)!, (controller.group.groupsOfThisUser.first?.id)!))
            }
        }
        .fullScreenCover(isPresented: self.$showCamera) {
            VStack{
                accessCameraView(selectedImage: self.$image)
            }
            .background(Color(.black))
        }
        .refreshable {
            Task{
                await controller.updateAll()
                listActivities = controller.mainListActivities
            }
            self.calculateProgress(startDate: model.startDate!, endDate: model.endDate!)
        }
    }
    
    
    var card : some View{
        VStack(alignment: .center, spacing: 24) {//card
            
            HStack(alignment: .center) {//seu desafio
                Text(model.title ?? "")
                    .font(.title2)
                    .foregroundColor(.preto)
                Spacer()
            }
            HStack (alignment:.center, spacing: 22){
                
                HStack (spacing: 9){
                    ImageLoader(url: "")
                    VStack (alignment:.leading){
                        // Callout/Emphasized
                        Text("\(lider?.points ?? 0 )")
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
                    ImageLoader(url: "")
                    VStack (alignment:.leading){
                        // Callout/Emphasized
                        Text("\(you?.points ?? 0 )")
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
            ProgressView(percent: lastDays, total: totalDays, unity: daysLeft)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(24)
        .frame(width:342, alignment: .top)
        .background(.branco)
        .cornerRadius(6)
        .shadow(color: .black.opacity(0.1), radius: 24.88501, x: 0, y: 8.295)
    }
    
    
    func calculateProgress(startDate: Date, endDate: Date) {
        totalDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0

        lastDays = min(max(daysPassed, 0), totalDays) // Garantir que percent esteja no intervalo válido
    }
    
}

#Preview {
    GroupView(model: exempleGroup)
}
