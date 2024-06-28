
import Foundation
import SwiftUI
import SwiftlyFormsCore

public struct SwiftlyFormField<Content>: View where Content: View {
  
  var fieldName: String
  var title: String?
  var stateType: SFs.FieldStateType
  var fieldType: SFs.FieldType
  var config: Config
  var builder: () -> Content
  
  @EnvironmentObject var formManager: SwiftlyFormManager
  
  public init(_ fieldName: String, _ type: SFs.FieldType, title: String? = nil, stateType: SFs.FieldStateType = .generic, config: Config = .init(), @ViewBuilder builder: @escaping () -> Content) {
    self.fieldName = fieldName
    self.stateType = stateType
    self.fieldType = type
    self.config = config
    self.title = title
    self.builder = builder
  }
  
  public var body: some View {
    formManager.addField(fieldName: fieldName, fieldStateType: stateType, fieldType: fieldType, validationMode: config.validationMode, title: title) {
      builder()
    }
  }
  
  public struct Config {
    var validationMode: SFs.FieldValidationMode?
    
    public init(validationMode: SFs.FieldValidationMode? = nil) {
      self.validationMode = validationMode
    }
  }
}
