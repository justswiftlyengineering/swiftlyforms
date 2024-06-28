import Foundation
import Combine
import SwiftlyFormsCore
import SwiftlyForms
import SwiftUI

public struct SFTextField<Placeholder>: SwiftlyField where Placeholder: View {
  
  @Environment(\.swiftlyFormFieldName) public var fieldName: String
  
  @EnvironmentObject public var formManager: SwiftlyFormManager
  @State public var fieldInternalValue: String = ""
  
  public var supportedFieldType: SFs.FieldType { .text }
  
  var config: Config
  var placeholder: () -> Placeholder
  
  public init(config: Config? = nil, placeholder: @escaping () -> Placeholder) {
    self.placeholder = placeholder
    self.config = config ?? Config()
  }
  
  public func makeInteractiveBody(configuration: SwiftlyFieldConfiguration) -> some View {
    VStack{
      Group {
        if config.isSecured {
          SecureField(text: $fieldInternalValue) {
            self.placeholder()
          }
        }
        else {
          TextField(text: $fieldInternalValue) {
            self.placeholder()
          }
        }
      }
    }
  }
  
  public func setInternalFieldValue(value: String?) {
    fieldInternalValue = value ?? ""
  }
  
  public struct Config {
    var isSecured = false
    public init(isSecured: Bool = false) {
      self.isSecured = isSecured
    }
  }
  
  public func onGainedFocus() {
  }
  
  public func onLostFocus() {
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

extension SFTextField where Placeholder == Text {
  public init(_ placeholder: String = "", config: Config? = nil) {
    self.init(config: config) {
      Text(placeholder)
    }
  }
}

public extension SFs.FieldType {
  static let text = SFs.FieldType(typeName: "text")
}
