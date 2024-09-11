//
//  ImageLoader.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI
import PhotosUI

struct ImageLoader: View {
    @State var url : String?
    var squere : Bool = false
    var largeImage : Bool = false
    @State var image : UIImage?
    var body: some View {
        VStack{
            if squere{
                if largeImage{
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 342, height: 426)
                        .clipped()
                        .cornerRadius(8)
                }
                else{
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 97, height: 121)
                        .clipped()
                        .cornerRadius(8)
                }
            }
            else{
                if largeImage{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 130, height: 130)
                        .background(
                            Image(uiImage: image ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .clipped()
                        )
                        .background(Color(.cinza1))
                        .cornerRadius(130)
                        .shadow(color: .black.opacity(0.1), radius: 20.635, x: 0, y: 6.88)
                        .overlay(
                            RoundedRectangle(cornerRadius: 130)
                                .inset(by: 2)
                                .stroke(Color(.azul3), lineWidth: 8)
                        )
                }
                else{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 44, height: 44)
                        .background(
                            Image(uiImage: image ?? UIImage())
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
        .onChange(of: url){ newValue in
            if let url = url{
                if(!url.isEmpty){
                    FirebaseInterface.shared.downloadImage(from: url){ response in
                        image = response
                    }
                }
            }
        }
        .onChange(of: image){ newValue in
            self.image = newValue
        }
        .onAppear{
            if let image = image{
                self.image = image
            }
            else{
                if let url = url{
                    if(!url.isEmpty){
                        FirebaseInterface.shared.downloadImage(from: url){ response in
                            image = response
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ImageLoader(url: "profileimage/1A504F81-A3BD-49E1-BD84-F0F9E490D673",squere: true ,largeImage: false)
}
