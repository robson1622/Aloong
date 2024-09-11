//
//  KeyboardBar.swift
//  Macro
//
//  Created by Robson Borges on 07/09/24.
//

import SwiftUI

struct KeyboardBar: View {
    var showNext : Bool = true
    var showBack : Bool = true
    var showOk : Bool = true
    
    let onTapNext : () -> Void
    let onTapBack : () -> Void
    let onTapOk : () -> Void
    
    private let nextText : String = NSLocalizedString("Next", comment: " texto do botão de próximo na barra do teclado ")
    private let backText : String = NSLocalizedString("Back", comment: " texto do botão de voltar na barra do teclado ")
    private let okText : String = NSLocalizedString("Ok", comment: " texto do botão OK na barra do teclado ")
    var body: some View {
        HStack{
            OkButton(active: showBack ,text: backText, onTap: { onTapBack() })
            OkButton(active: showNext ,text: nextText, onTap: { onTapNext() })
            Spacer()
            OkButton(active: showOk ,onTap: { onTapOk() })
        }
        .padding(6)
        .background(Color(.systemGray6))
        .border(Color(.systemGray4), width: 1)
    }
}

#Preview {
    KeyboardBar(showBack:false, onTapNext: { } , onTapBack:  {} , onTapOk: {} )
}
