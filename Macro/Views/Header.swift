//
//  Header.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct Header: View {
    var title: String?
    var trailing: [AnyView] = []
    var onTapBack : () -> Void?
    var body: some View {
        VStack(spacing: 0) {

            ZStack {
                HStack {
                    if title != nil {
                        Text(title!)
                            .foregroundStyle(Color(.preto))
                            .bold()
                    }
                }
                
                HStack() {
                    Spacer()
                    
                    ForEach(trailing.indices, id: \.self) { index in
                        trailing[index]
                            .padding(.leading, 8)
                    }
                }
                
                HStack {
                    if (ViewsController.shared.navPath.count > 1) {
                        Button {
                            ViewsController.shared.back()
                            onTapBack()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.roxo3)
                                
                                Text("back")
                                    .foregroundStyle(.roxo3)
                            }
                            .tint(.white)
                            .foregroundStyle(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical,16)
        }
    }
}

#Preview {
    Header(title: "teste",onTapBack: {})
}
