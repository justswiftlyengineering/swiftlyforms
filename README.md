# swiftlyforms

Swiftlyforms is a suite of library that allow you build and manage forms using the power of SwiftUI

```swift

import SwiftlyFormsCore
import SwiftlyForms
import SwiftlyFormsField

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
        
        SwiftlyFormField(FieldNames.sendReceipt, .toggle, title: "Get the Receipt") {
          SwiftlyToggle()
        }

        Button(action: {
          print(formManager.getFieldValues())
        }, label: {
          Text("Submit")
        })
        .disabled(!formManager.formIsValid)
        
      }
      .frame(maxWidth: .infinity)
      .environmentObject(appearance)
      .environmentObject(formManager)
      .padding(.top, 30)
    }
  }
}
```