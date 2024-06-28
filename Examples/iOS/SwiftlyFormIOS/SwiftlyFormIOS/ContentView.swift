//
//  ContentView.swift
//  SwiftlyFormIOS
//
//  Created by Kembene Nkem on 15/06/2024.
//

import SwiftUI
import SwiftlyFormsCore
import SwiftlyForms
import SwiftlyFormsField
import Combine

enum FieldNames {
  static let amount = "amount"
  static let cardNumber = "cardNumber"
  static let expiryDate = "expiryDate"
  static let cvv = "cvv"
  static let sendReceipt = "sendReceipt"
}

struct ContentForm: View {
  @ObservedObject var formManager: SwiftlyFormManager
  @StateObject var appearance = SwiftlyDecoratorAppearance()
  init(formManager: SwiftlyFormManager) {
    self.formManager = formManager
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        SwiftlyFormField(FieldNames.amount, .text, title: "Amount") {
          SFTextField {
            Text("Enter Amount")
//              .foregroundStyle()
          }
          .keyboardType(.numberPad)
          .swiftlyformValidator_required()
          .swiftlyDecorator()
        }
        
        SwiftlyFormField(FieldNames.cardNumber, .text, title: "Card Number") {
          SFTextField {
            Text("Enter Card Number")
          }
          .keyboardType(.numberPad)
          .swiftlyDecorator()
        }
        
        HStack {
          SwiftlyFormField(FieldNames.expiryDate, .text, title: "Expiry Date") {
            SFTextField {
              Text("MM/YY")
            }
            .keyboardType(.numberPad)
          }
          .swiftlyDecorator()
          
          SwiftlyFormField(FieldNames.cvv, .text, title: "CVV") {
            SFTextField {
              Text("CVV")
            }
          }
          .swiftlyDecorator()
        }
        
        SwiftlyFormField(FieldNames.sendReceipt, .toggle, title: "Get the Receipt") {
          SwiftlyToggle()
        }
        
      }
      .frame(maxWidth: .infinity)
      .environmentObject(appearance)
      .environmentObject(formManager)
      .padding(.top, 30)
    }
  }
}

struct ContentView: View {
  
  @StateObject var formManager = SwiftlyFormManager()
  @StateObject var appearance = SwiftlyDecoratorAppearance()
  
  @State var isOn = false
  
  @State private var cancellable: AnyCancellable?
  
  @State var amountState: SFs.FieldState?
  @State var amountEntered: String = "0.0"
  
  var currencyFormatter = NumberFormatter()
  
  init() {
    currencyFormatter.numberStyle = .currency
    currencyFormatter.currencySymbol = "$"
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 40) {
      HStack(spacing: 0) {
        Text("SWIFT")
        Text("LY")
          .padding(7)
          .foregroundColor(Color.white)
          .background(Color.blue)
          .clipShape(Circle())
      }
      .font(.title)
      .padding(.top, 40)
      VStack {
        Text("Payment")
        Text("In Style For You")
      }
      .font(.title2)
      
      ContentForm(formManager: formManager)
      Spacer()
      Button(action: {
        print(self.formManager.getFieldValues())
      }, label: {
        Text("Pay \(amountEntered)")
      })
      .tint(.white)
      .padding(.vertical, 20)
      .frame(maxWidth: .infinity)
      .background(Color.blue)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .padding(.bottom, 20)
      
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 30)
    .onAppear {
      cancellable = formManager.getFieldState(fieldName: FieldNames.amount)?.$value.sink { val in
        onNewAmountEntered(amount: val?.value)
      }
    }
  }
  
  func onNewAmountEntered(amount: Any?) {
    guard let val = amount, let value = Double("\(val)") else {
      self.amountEntered = currencyFormatter.string(from: 0.0) ?? ""
      return
    }
    self.amountEntered = currencyFormatter.string(for: value) ?? ""
  }
}

#Preview {
    ContentView()
}
