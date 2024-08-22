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
    
    var body: some View {
        VStack(spacing: 0) {

            ZStack {
                HStack {
                    if title != nil {
                        Text(title!)
                            .foregroundStyle(.black)
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
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.black)
                                
                                Text("back")
                            }
                            .tint(.white)
                            .foregroundStyle(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
        }
    }
}

#Preview {
    Header(title: "teste")
}
