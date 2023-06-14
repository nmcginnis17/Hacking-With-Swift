//
//  ContentView.swift
//  WeSplit
//
//  Created by Nicholas McGinnis on 3/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20.0
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [15, 18, 20, 22, 25]
    
    var tip: Double {
        let tipAmount = (checkAmount / 100) * Double(tipPercentage)

        return tipAmount
    }
    
    var checkTotalValue: Double {
        let tipValue = (checkAmount / 100) * Double(tipPercentage)
        let checkTotal = checkAmount + tipValue
        
        return checkTotal
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 1)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = (checkAmount / 100) * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(1..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Slider(value: $tipPercentage, in: 0...100, step: 1.0)
                    Text("\(tipPercentage, specifier: "%.0f")%       :       $\(tip, specifier: "%.2f")")
                } header: {
                    Text("Select a Tip Percentage")
                }
                
                Section {
                    Text(checkTotalValue, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Total Check Amount")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Amount per Person")
                }
            }
            .navigationTitle("Check Splitter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
