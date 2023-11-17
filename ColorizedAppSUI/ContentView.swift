//
//  ContentView.swift
//  ColorizedAppSUI
//
//  Created by Максим Евграфов on 14.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var redSliderValue = Double.random(in: 0...255)
    @State private var greenSliderValue = Double.random(in: 0...255)
    @State private var blueSliderValue = Double.random(in: 0...255)
    
    @FocusState private var activeField: Field?
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
                .onTapGesture {
                    activeField = nil
                }
            VStack {
                ColorDeskView(redColor: redSliderValue, greenColor: greenSliderValue, blueColor: blueSliderValue)
                    .padding()
                VStack {
                    ColorSliderView(value: $redSliderValue, color: .red)
                        .focused($activeField, equals: .red)
                    ColorSliderView(value: $greenSliderValue, color: .green)
                        .focused($activeField, equals: .green)
                    ColorSliderView(value: $blueSliderValue, color: .blue)
                        .focused($activeField, equals: .blue)
                }
                .keyboardType(.decimalPad)
                .toolbar {
                    if (activeField != nil) {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button(action: previousField) {
                                Image(systemName: "chevron.up")
                            }
                            Button(action: nextField) {
                                Image(systemName: "chevron.down")
                            }
                            Spacer()
                            Button("Done") {
                                activeField = nil
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    struct ColorDeskView: View {
        var redColor: Double
        var greenColor: Double
        var blueColor: Double
        
        var body: some View {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(red: redColor/255, green: greenColor/255, blue: blueColor/255))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white, lineWidth: 5))
                .frame(height: 150)
        }
    }
    
    struct ColorSliderView: View {
        @Binding var value: Double
        @State private var text: String = "0"
        @State private var isAlertPresenter = false
        
        var color: Color
        
        var body: some View {
            HStack {
                Text("\(lround(value))")
                    .foregroundStyle(.white)
                    .frame(maxWidth: 35, alignment: .leading)
                Slider(value: $value, in: 0...255, step: 1)
                    .tint(color)
                    .frame(maxWidth: .infinity)
                    .onChange(of: value) {
                        text = "\(lround(value))"
                    }
                TextField("value", text: $text)
                    .frame(maxWidth: 50, alignment: .trailing)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .alert("Wrong format!", isPresented: $isAlertPresenter, actions: {}) {
                        Text("Please enter value from 0 to 255")
                    }
                    .onChange(of: text) {
                        if let newValue = Double(text), (0...255).contains(newValue) {
                            value = newValue
                        } else {
                            isAlertPresenter = true
                            value = 0
                            text = "0"
                        }
                    }
            }
            .padding()
            .onAppear {
                text = "\(lround(value))"
            }
        }
    }
}

private extension ContentView {
    enum Field {
        case red, green, blue
    }
    
    func nextField() {
        switch activeField {
        case .red:
            activeField = .green
        case .green:
            activeField = .blue
        case .blue:
            activeField = .red
        case .none:
            activeField = nil
        }
    }
    
    func previousField() {
        switch activeField {
        case .red:
            activeField = .blue
        case .blue:
            activeField = .green
        case .green:
            activeField = .red
        case .none:
            activeField = nil
        }
    }
}

#Preview {
    ContentView()
}
