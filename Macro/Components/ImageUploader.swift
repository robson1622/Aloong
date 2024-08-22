//
//  ImageUpload.swift
//  Macro
//
//  Created by Robson Borges on 09/08/24.
//

import SwiftUI

struct ImageUploader: View {
    var url : String?
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
                        .cornerRadius(15)
                    Text("Falta codar \n a imagem")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ImageUploader(url: "exempleurljcbs7271e6uhcs98yey98fhycwc.qs8y82y1.jpg",squere: true)
}
