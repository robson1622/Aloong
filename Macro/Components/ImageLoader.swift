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
                ZStack{
                    Circle()
                    Text("Falta codar \n a imagem")
                        .foregroundColor(.white)
                }
            }
            else{
                ZStack{
                    Rectangle()
                    Text("Falta codar \n a imagem")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ImageLoader(url: "image")
}
