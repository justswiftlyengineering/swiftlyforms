
import Foundation
import SwiftUI
import SwiftlyFormsCore
import Combine

public struct CharacterLimitModifer: ViewModifier {
  
  var value: Binding<String>
  var length: Int
  
  public init(value: Binding<String>, length: Int) {
    self.value = value
    self.length = length
  }
  
  public func body(content: Content) -> some View {
    content.onReceive(Just(value)) {val in
      value.wrappedValue = String(val.wrappedValue.prefix(length))
    }
  }
}

public struct FormFieldCharacterLimitModifier: ViewModifier {
  @EnvironmentObject var fieldState: SFs.FieldState
  
  var length: Int
  
  public init(length: Int) {
    self.length = length
  }
  
  public func body(content: Content) -> some View {
    content
      .onChange(of: fieldState.value) { newValue in
        guard let val = newValue?.value as? String else {
          return
        }
        let value = String(val.prefix(length))
        fieldState.setValue(value: .string(value: value))
      }
  }
}
