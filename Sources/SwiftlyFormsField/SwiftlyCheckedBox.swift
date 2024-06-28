//
//  File.swift
//  
//
//  Created by Kembene Nkem on 26/06/2024.
//

import Foundation
import SwiftlyFormsCore
import SwiftlyForms
import SwiftUI

public struct SwiftlyToggleStyleConfig {
  var position: SwiftlyToggleStylePosition
  public init(position: SwiftlyToggleStylePosition = .afterToggle) {
    self.position = position
  }
}

public enum SwiftlyToggleStylePosition {
  case beforeToggle
  case afterToggle
}

struct HLabelStyle: LabelStyle {
  var iconBeforeTitle: Bool
  
  
  
  func makeBody(configuration: Configuration) -> some View {
      HStack(alignment: .center, spacing: 8) {
        if iconBeforeTitle {
          configuration.icon
        }
        configuration.title
        if !iconBeforeTitle {
          configuration.icon
        }
      }
  }
}

public struct DefaultSwiftlyToggleStyleView: View {
  var configuration: ToggleStyle.Configuration
  var styleConfig: SwiftlyToggleStyleConfig
  
  public var body: some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      
      Label {
        configuration.label
      } icon: {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
          .foregroundColor(configuration.isOn ? .accentColor : .secondary)
          .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
          .imageScale(.large)
      }
      .labelStyle(HLabelStyle(iconBeforeTitle: styleConfig.position == .afterToggle))
    }
    .buttonStyle(PlainButtonStyle())
  }
}
//
public struct SwiftlyToggleStyle<Content: View>: ToggleStyle {
  
  @Environment(\.swiftlyFormCurrentValue) var formValue: EquatableValue?
  @EnvironmentObject var fieldState: SFs.FieldState
  
  var content: (_ config: SwiftlyToggleStyleConfig, _ configuration: Configuration) -> Content
  var config: SwiftlyToggleStyleConfig
  
  public init(config: SwiftlyToggleStyleConfig, @ViewBuilder content: @escaping (_ config: SwiftlyToggleStyleConfig, _ configuration: Configuration) -> Content) {
    self.content = content
    self.config = config
  }
  
  public func makeBody(configuration: Configuration) -> some View {
    content(config, configuration)
    .onChange(of: configuration.isOn) { newValue in
      fieldState.setValue(value: .typed(value: newValue))
    }
    .onChange(of: formValue) { newValue in
      didGetNewValueFromState(configuration: configuration, newValue: newValue)
    }
    .onAppear {
      didGetNewValueFromState(configuration: configuration, newValue: fieldState.value)
    }
  }
  
  func didGetNewValueFromState(configuration: Configuration, newValue: EquatableValue?) {
    if let val = newValue?.value as? Bool {
      configuration.isOn = val
    }
    else {
      configuration.isOn = newValue != nil
    }
  }
}

extension SwiftlyToggleStyle where Content == DefaultSwiftlyToggleStyleView {
  public init(_ config: SwiftlyToggleStyleConfig = .init()) {
    self.init(config: config) { toggleConfig,  configuration in
      DefaultSwiftlyToggleStyleView(configuration: configuration, styleConfig: toggleConfig)
    }
  }
}

extension ToggleStyle where Self == SwiftlyToggleStyle<DefaultSwiftlyToggleStyleView> {
  public static func swiftlyFormToggle() -> SwiftlyToggleStyle<DefaultSwiftlyToggleStyleView> { .init() }
}


public struct SwiftlyToggle<Content>: SwiftlyField where Content: View {
  
  @EnvironmentObject public var formManager: SwiftlyFormManager
  
  @Environment(\.swiftlyFormFieldName) public var fieldName: String
  @Environment(\.swiftlyFormFieldTitle) public var fieldTitle: String?
  @State public var fieldInternalValue: Bool = false
  
  public var supportedFieldType: SFs.FieldType { .toggle }
  
  
  var styleProvider: (_ styleConfig: SwiftlyToggleStyleConfig, _ toggleConfiguration: ToggleStyle.Configuration, _ fieldConfiguration: SwiftlyFieldConfiguration) -> Content
  var styleConfig: SwiftlyToggleStyleConfig
  
  public init(config: SwiftlyToggleStyleConfig = .init(), @ViewBuilder styleProvider: @escaping (_ : SwiftlyToggleStyleConfig, _: ToggleStyle.Configuration, _: SwiftlyFieldConfiguration) -> Content) {
    self.styleProvider = styleProvider
    self.styleConfig = config
  }
  
  public func makeInteractiveBody(configuration: SwiftlyFieldConfiguration) -> some View {
    Toggle(fieldTitle ?? "", isOn: .init(get: getToggleValue, set: setToggleValue(value:)))
      .toggleStyle(SwiftlyToggleStyle(config: styleConfig, content: { styleConf, toggleConfig in
        styleProvider(styleConf, toggleConfig, configuration)
      }))
  }
  
  func getToggleValue() -> Bool {
    return fieldInternalValue
  }
  
  func setToggleValue(value: Bool) {
    fieldInternalValue = value
  }
  
}

extension SwiftlyToggle where Content == DefaultSwiftlyToggleStyleView {
  public init(config: SwiftlyToggleStyleConfig = .init()) {
    self.init(config: config) { styeConf, tConfig, fConfig in
      DefaultSwiftlyToggleStyleView(configuration: tConfig, styleConfig: styeConf)
    }
  }
}

public extension SFs.FieldType {
  static let toggle = SFs.FieldType(typeName: "toggle")
}
