//
//  GroupView.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupView: View {
    let model : GroupModel
    @State var lider : UserModel = UserModel()
    @State var you : UserModel = UserModel()
    
    
    var body: some View {

        ZStack (alignment: .center){//fundo
            VStack(spacing: 24){ //vstack geral
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {//logo + perfil
                    Image("aloong_logo")
                        .frame(width: 134, height: 41.07149)
                    Spacer()
                    ImageLoader(url: "")
                }
                
                VStack(alignment: .center, spacing: 24) {//card
                    HStack(alignment: .center) {//seu desafio
                        Text("Seu desafio")
                            .font(.title2)
                            .foregroundColor(.preto)
                      Spacer()
                    }
                        HStack (alignment:.center, spacing: 22){
                            
                            HStack (spacing: 9){
                                ImageLoader(url: "")
                                VStack (alignment:.leading){
                                    // Callout/Emphasized
                                    Text("24")
                                        .font(.callout)
                                        .foregroundColor(.preto)
                                        .bold()
                                    
                                    // Caption1/Regular
                                    Text("Líder")
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
                                    Text("24")
                                        .font(.callout)
                                        .foregroundColor(.preto)
                                        .bold()
                                    
                                    // Caption1/Regular
                                    Text("Líder")
                                        .font(.caption)
                                        .foregroundColor(.preto)
                                }
                                Spacer()
                            }
                        
                    }
                    ProgressView(percent: 25, total: 120, unity: "dias restantes")
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(24)
                .frame(width:342, alignment: .top)
                .background(.branco)
                .cornerRadius(6)
                .shadow(color: .black.opacity(0.1), radius: 24.88501, x: 0, y: 8.295)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top, spacing: 16) {
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 96.8, height: 121)
                          .background(
                            Image("img_teste")
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(width: 96.80000305175781, height: 121)
                              .clipped()
                          )
                          .cornerRadius(1)
                        
                        VStack (spacing: 10){
                            HStack{
                                Text("MARCELA")
                                    .font(.caption)
                                    .foregroundColor(.preto)
                                Spacer()
                                // Caption1/Italic
                                Text("10h51")
                                    .font(.caption)
                                    .foregroundColor(.cinza2)
                                    .multilineTextAlignment(.trailing)
                                    .italic()
                            }
                            
                            Text("Atividade física yoga ioga corrida e mt suor cardio")
                                .font(.subheadline)
                                .foregroundColor(.preto)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
//                            HStack{
//                                Image(systemName: "hands.and.sparkles")
//                                    .font(.title2)
//                                    .foregroundColor(.preto)
//                                Spacer()
//                            }
                            
                            
                            
                            
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, minHeight: 121, maxHeight: 121, alignment: .leading)
                    }
                    .padding(16)
                    .frame(width: 342, alignment: .topLeading)
                    .background(.branco)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.1), radius: 24.88501, x: 0, y: 8.295)
                    
                    Spacer()
                    
                }
                .padding(0)
                .frame(width: 342, alignment: .topLeading)
            }
        }
        .padding(24)
        .padding(.vertical,18)
        .frame(width: 390, height: 844)
        .background(.branco)
    }
    
}

#Preview {
    GroupView(model: exempleGroup)
}
