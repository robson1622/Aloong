//
//  DatePicker.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI

struct DatePickerComponent: View {
    @State private var birthDate = Date()
        @State private var showDatePicker = false

        var body: some View {
            VStack {
                Text("Selecione sua data de nascimento:")
                    .font(.headline)
                    .padding()

                Button(action: {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }) {
                    Text("Selecionar Data")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                if showDatePicker {
                    DatePicker("", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle()) // Estilo de rolagem
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding()
                        .transition(.move(edge: .top))
                }

                Text("Data selecionada: \(formatDate(date: birthDate))")
                    .font(.subheadline)
                    .padding()
            }
        }
}

#Preview {
    DatePickerComponent()
}
