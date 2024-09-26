//
//  TimerPickerView.swift
//  Macro
//
//  Created by Robson Borges on 02/09/24.
//

import SwiftUI

struct TimePicker: View {
    @Binding var selectDate : Date
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    Spacer()
                    .padding(.top,24)
                }
            }
            .padding(.top,22)
            DatePicker("", selection: $selectDate,displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle()) // Estilo de rolagem
                .padding(.trailing,16)
        }
        .padding(16)
        .frame(height: 250)
        .background(Color(.branco))
    }
}

#Preview {
    let today = Date()
    return TimePicker(selectDate: .constant(today))
}
