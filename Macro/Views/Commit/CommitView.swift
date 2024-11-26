//
//  CommitView.swift
//  Macro
//
//  Created by Robson Borges on 04/11/24.
//

import SwiftUI

let exempleOfCommit : CommentModel = CommentModel(id: "108u8y8ijx.wok1010c0-.wxp,w", idGroup: "", idUser: "", idActivity: "", date: Date(), comment: "Texto do comentário de exemplo, um texto bem longo para ver como fica quando o texto é grande e se deve pular linha")
let exempleOfCommit2 : CommentModel = CommentModel(id: "108u8y8ijx.wok1010c0-.wxp,w", idGroup: "", idUser: "", idActivity: "", date: Date(), comment: "Texto do comentário de exemplo")

struct CommitView: View {
    let commit : CommentModel
    let user : UserModel
    @State private var uiimage : UIImage?
    var body: some View {
        HStack{
            
            Image(uiImage: uiimage ?? self.placeholderImage())
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
            VStack{
                HStack{
                    Text(user.name)
                        .font(.callout)
                        .foregroundColor(Color.gray)
                    Spacer()
                    Text(formattedDateAndTime(from:commit.date))
                        .font(.caption)
                        .italic()
                        .foregroundColor(Color(.systemGray2))
                }
                HStack{
                    Text(commit.comment)
                        .font(.callout)
                        .foregroundColor(Color.preto)
                    Spacer()
                }
            }
            .padding(.leading,9)
            
        }
        .padding(.top,12)
        .padding(.bottom,12)
        .padding(.trailing,24)
        .padding(.leading,16)
        .background(Color(.systemGray6))
        .onAppear{
            if let image = user.userimage{
                BucketOfImages.shared.download(from: image){ response in
                    if let response = response{
                        uiimage = response
                    }
                }
            }
        }
        .cornerRadius(6)
    }
    
    func placeholderImage() -> UIImage {
        // Array com os nomes das imagens
        let imageNames = ["plaveholderuserblue", "plaveholderuserpink", "plaveholderusergreen"]
        
        // Seleciona um índice aleatório entre 0 e 2
        let randomIndex = Int.random(in: 0..<imageNames.count)
        
        // Retorna a imagem correspondente ao índice sorteado
        return UIImage(named: imageNames[randomIndex]) ?? UIImage()
    }

    
}

#Preview {
    CommitView(commit: exempleOfCommit2, user: usermodelexemple)
}
