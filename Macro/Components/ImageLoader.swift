//
//  ImageLoader.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI

struct ImageLoader: View {
    let url : String?
    var squere : Bool = false
    var body: some View {
        VStack{
            if(!squere){
//                ZStack{
//                    Circle()
//                    Text("Falta codar \n a imagem")
//                        .foregroundColor(.white)
//                }
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 44, height: 44)
                  .background(
                    Image("PATH_TO_IMAGE")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 44, height: 44)
                      .clipped()
                  )
                  .background(Color(.cinza1))
                  .cornerRadius(44)
                  .shadow(color: .black.opacity(0.1), radius: 20.635, x: 0, y: 6.88)
                  .overlay(
                    RoundedRectangle(cornerRadius: 44)
                      .inset(by: 2)
                      .stroke(Color(.azul3), lineWidth: 4)
                  )
            }
            else{
//                ZStack{
//                    Rectangle()
//                    Text("Falta codar \n a imagem")
//                        .foregroundColor(.white)
//                }
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 44, height: 44)
                  .background(
                    Image("PATH_TO_IMAGE")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 44, height: 44)
                      .clipped()
                  )
                  .background(Color(.cinza1))
                  .cornerRadius(44)
                  .shadow(color: .black.opacity(0.1), radius: 20.635, x: 0, y: 6.88)
                  .overlay(
                    RoundedRectangle(cornerRadius: 44)
                      .inset(by: 2)
                      .stroke(Color(.azul3), lineWidth: 4)
                  )
            }
        }
    }
}

#Preview {
    ImageLoader(url: "image")
}
