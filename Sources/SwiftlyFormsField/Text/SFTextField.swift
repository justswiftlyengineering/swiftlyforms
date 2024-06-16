//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import Combine
import SwiftlyFormsCore
import SwiftlyForms
import SwiftUI

public struct SFTextField<Placeholder>: SwiftlyField where Placeholder: View {
  
  @Environment(\.swiftlyFormFieldName) public var fieldName: String
  @Environment(\.swiftlyFormFieldType) public var fieldType: SFs.FieldType
  
  @EnvironmentObject var fieldState: SFs.FieldState
  @EnvironmentObject public var formManager: SwiftlyFormManager
  
  @State private var isEnvironmentObjectSet = false
  @State var fieldValue: String = ""
  
  var config: Config
  var placeholder: () -> Placeholder
  
  public var supportedTypes: [SFs.FieldType] {
    return [.text]
  }
  
  public init(config: Config? = nil, placeholder: @escaping () -> Placeholder) {
    self.placeholder = placeholder
    self.config = config ?? Config()
  }
  
  public var interactiveField: some View {
    VStack{
      Group {
        if config.isSecured {
          SecureField(text: $fieldValue) {
            self.placeholder()
          }
        }
        else {
          TextField(text: $fieldValue) {
            self.placeholder()
          }
        }
      }
      .onChange(of: fieldValue) { new in
        fieldState.setValue(value: .string(value: new))
      }
      .onChange(of: fieldState.value) { new in
        fieldValue = (new?.value as? String) ?? ""
      }
    }
    .onAppear {
      if !isEnvironmentObjectSet {
        isEnvironmentObjectSet = true
        updateValueFromState()
      }
    }
  }
  
  private func updateValueFromState() {
    guard let val: String = fieldState.forceValueType() else {
      return
    }
    fieldValue = "\(val)"
  }
  
  public struct Config {
    var isSecured = false
    
    public init(isSecured: Bool = false) {
      self.isSecured = isSecured
    }
  }
}

#Preview {
  SwiftlyFormManager()
    .addFieldExporting(fieldName: "kem", fieldType: .text) {
      SFTextField{
        Text("Enter username")
      }
    }
}

public extension SFs.FieldType {
  static let text = SFs.FieldType(typeName: "text")
}
