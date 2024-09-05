//
//  DetailsGroupView.swift
//  Macro
//
//  Created by Nicole Cardoso Machado on 04/09/24.
//

import SwiftUI

struct DetailsGroupView: View {
    let list = ["hausus","hausus","hausus","hausus","hausus","hausus"]
    var body: some View {
        
        
        ZStack (alignment: .center){
            VStack(spacing: 36){
                VStack(spacing: 10){
                    HStack(alignment: .center) {//seu desafio
                        Text("Seu desafio")
                            .font(.title2)
                            .foregroundColor(.preto)
                        Spacer()
                    }
                    Text("Descrição de até duas linhas que eu tinha esquecido de considerar")
                        .font(.callout)
                        .foregroundColor(.preto)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ProgressView(percent: 25, total: 120, unity: "dias restantes")
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(0)
                
                VStack(spacing: 8){
                    HStack{
                        Text("CLASSIFICAÇÕES")
                            .font(.caption)
                            .foregroundColor(.cinza2)
                            .padding(.leading, 4)
                        Spacer()
                    }
                    .padding(0)
                    
                    VStack(spacing:0){
                        ForEach(list.indices, id: \.self) { i in
                            HStack{
                                Text("Item \(i)")
                                    .font(.body)
                                    .foregroundColor(.preto)
                                Spacer()
                                Text("x dias")
                                    .font(.body)
                                    .foregroundColor(.cinza2)
                            }
                            .padding()
                            .background(.branco)
                            if(i != (list.count-1)) {
                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8)
                }
                
                
                
                Button(action: {
                    // Ação que será executada quando o botão for pressionado
//                    print("Botão pressionado!")
                }) {
                    HStack(alignment: .center, spacing: 4) {
                        // Body/Regular
                        HStack{
                            Image(systemName: "square.and.arrow.up")
                                .font(.body)
                                .foregroundColor(.branco)
                                .padding(.horizontal,0)
                                .padding(.vertical,0)
                            Text("Convidar amigos")
                                .font(.body)
                                .foregroundColor(.branco)
                                .padding(.horizontal,0)
                                .padding(.vertical,0)
                        }
                        .padding(.horizontal,20)
                        .padding(.vertical,14)
                        .background(.azul3)
                        .cornerRadius(8)
                    }
                }
                .padding(0)
                
                Spacer()
            }
            .padding(.vertical, 18)
        }
        .padding(24)
        .padding(.vertical,18)
        .frame(width: 390, height: 844)
        .background(.branco)
    }
}

#Preview {
    DetailsGroupView()
}
