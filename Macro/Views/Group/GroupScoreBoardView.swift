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
    @State var first : PointsOfUser
    @State var second : PointsOfUser
    @State var third : PointsOfUser
    
    @State var you : PointsOfUser
    
    let liderText : String = NSLocalizedString("Líder", comment: "Titulo da view de grupo que denota o lider")
    let youText : String = NSLocalizedString("You", comment: "Titulo da view de grupo que denota o lider")
    let daysLeft : String = NSLocalizedString("Days left", comment: "texto da contagem de dias restantes")
    let withoutActivityText : String = NSLocalizedString("Oops, \n there's nothing here yet...", comment: "Texto que fala que não há atividadesainda")
    let detailsText : String = NSLocalizedString("Details", comment: "Texto do botão de detalhes do painel de colocações na groupview")
    let yourposition : String = NSLocalizedString("Your position", comment: "Texto do painel de colocações na groupview")
    var body: some View {
        VStack(alignment: .center, spacing: 24) {//card
            
            HStack(alignment: .center) {//seu desafio
                Text(model.title)
                    .font(.degular22)
                    .foregroundColor(.branco)
                Spacer()
                
                Text(detailsText)
                    .font(.body)
                    .foregroundColor(.verde)
                
            }
            HStack(alignment:.bottom){
                PlaceChallengerComponet(image: second.user.userimage, positionImage: .second, name: second.user.name)
                PlaceChallengerComponet(image: first.user.userimage, positionImage: .first, name: first.user.name)
                PlaceChallengerComponet(image: third.user.userimage, positionImage: .third, name: third.user.name)
            }
            .padding(.top,-16)
            
            HStack{
                Text(yourposition)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(.branco))
                Spacer()
                Image(systemName: "clock")
                    .fontWeight(.medium)
                    .foregroundStyle(Color(.branco))
                
                Text("\(lastDays) \(daysLeft)")
                    .fontWeight(.medium)
                    .foregroundStyle(Color(.branco))
            }
            
            
        }
        .padding(24)
        .frame(width:342, alignment: .top)
        .background( Image("backgradiente"))
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

struct PlaceChallengerComponet : View{
    let image : String?
    enum position{
        case first, second, third
    }
    let positionImage : position
    let name : String
    @State var uiimage : UIImage?
    let dimenssionFirst : CGFloat = 66
    let dimenssionOthers : CGFloat = 44
    let dimenssionMedalFirst : [CGFloat] = [31,41]
    let dimenssionMedalOthers : [CGFloat] = [23,30]
    
    var body : some View{
        VStack (alignment:.center){
            ZStack{
                if let uiimage{
                    Image(uiImage: uiimage)
                        .resizable()
                        .frame(width: positionImage == .first ? dimenssionFirst : dimenssionOthers , height: positionImage == .first ? dimenssionFirst : dimenssionOthers )
                        .clipShape(Circle())
                }
                Image(self.getImage())
                    .resizable()
                    .frame(width: positionImage == .first ? dimenssionMedalFirst[0] : dimenssionMedalOthers[0] ,height: positionImage == .first ? dimenssionMedalFirst[1] : dimenssionMedalOthers[1] )
                    .padding(.top,positionImage == .first ? dimenssionFirst/1.2 : dimenssionOthers/1.2)
                    .padding(.trailing,positionImage == .first ? dimenssionFirst/1.2 : dimenssionOthers/1.2)
                
            }
            // Callout/Emphasized
            Text(name)
                .font(.footnote)
                .foregroundColor(.branco)
        }
        .onAppear{
            if let image = image{
                BucketOfImages.shared.download(from: image){ response in
                    if let response = response{
                        uiimage = response
                    }
                    else{
                        uiimage = self.placeholderImage()
                    }
                }
            }
        }
    }
    
    func getImage() -> String{
        switch positionImage{
        case .first:
            return "firstplace"
        case .second:
            return "secondplace"
        case .third:
            return "threeplace"
        }
    }
    
    func placeholderImage() -> UIImage{
        switch positionImage{
        case .first:
            return UIImage(named: "plaveholderuserblue")!
        case .second:
            return UIImage(named: "plaveholderuserpink")!
        case .third:
            return UIImage(named: "plaveholderusergreen")!
        }
    }
    
}

#Preview {
    //PlaceChallengerComponet(image: "plaveholderuserblue", positionImage: .first, name: "Fulano")
    
    
    GroupScoreBoardView(model: exempleGroup, first: PointsOfUser(user: usermodelexemple, points: 3), second: PointsOfUser(user: usermodelexemple2, points: 3),third: PointsOfUser(user: usermodelexemple3, points: 3), you: PointsOfUser(user: usermodelexemple4, points: 10))
}
