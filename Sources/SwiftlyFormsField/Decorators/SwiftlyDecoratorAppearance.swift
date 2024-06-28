//
//  File.swift
//  
//
//  Created by Kembene Nkem on 27/06/2024.
//

import Foundation
import SwiftUI
import SwiftlyForms

public struct AppearanceData {
  var titleFont: Font?
  var foregroundFont: Font?
  var titleColor: Color?
  var borderColor: Color?
  var backgroundColor: Color?
  var foregroundColor: Color?
  var accentColor: Color?
  
  public init(
    titleFont: Font? = .body,
    foregroundFont: Font? = .footnote,
    titleColor: Color? = .primary,
    borderColor: Color? = Color.secondary,
    backgroundColor: Color? = Color(UIColor.systemBackground),
    foregroundColor: Color? = .primary.opacity(0.8),
    accentColor: Color? = .accentColor) {
      
    self.titleFont = titleFont
    self.foregroundFont = foregroundFont
    self.titleColor = titleColor
    self.borderColor = borderColor
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
    self.accentColor = accentColor
  }
  
  /// TODO: Use Macros to implement this
  public func clone(
    titleFont: Font? = nil,
    foregroundFont: Font? = nil,
    titleColor: Color? = nil,
    borderColor: Color? = nil,
    backgroundColor: Color? = nil,
    foregroundColor: Color? = nil,
    accentColor: Color? = nil) -> AppearanceData {
      var data = self
      data.titleFont = titleFont ?? self.titleFont
      data.foregroundFont = foregroundFont ?? self.foregroundFont
      data.titleColor = titleColor ?? self.titleColor
      data.borderColor = borderColor ?? self.borderColor
      data.backgroundColor = backgroundColor ?? self.backgroundColor
      data.foregroundColor = foregroundColor ?? self.foregroundColor
      data.accentColor = accentColor ?? self.accentColor
      return data
  }
  
}

public struct AppearanceState: Hashable {
  var rawValue: String
  
  public static let invalid = AppearanceState(rawValue: "invalid")
  public static let focused = AppearanceState(rawValue: "focus")
  public static let basic = AppearanceState(rawValue: "unfocused")
  
  public init(rawValue: String) {
    self.rawValue = rawValue
  }
  
}

open class SwiftlyDecoratorAppearance: ObservableObject {
  @Published public var background: Color? = Color(UIColor.systemBackground)
  @Published public var borderColor: Color? = Color.secondary
  @Published public var config: SwiftlyFieldDecoratorConfig
  
  private static var _defaultInstance: SwiftlyDecoratorAppearance?
  
  private var appearances: [AppearanceState: AppearanceData] = [:]
  
  public static var defaultInstance: SwiftlyDecoratorAppearance {
    guard let instance = _defaultInstance else {
      let instance = SwiftlyDecoratorAppearance()
      _defaultInstance = instance
      return instance
    }
    return instance
  }
  
  public init(basic: AppearanceData? = nil, focused: AppearanceData? = nil, invalid: AppearanceData? = nil) {
    config = .init()
    registerAppearanceData(forState: .basic, data: basic ?? .init(borderColor: Color.secondary.opacity(0.8)))
      .registerAppearanceData(forState: .focused, data: focused ?? .init())
      .registerAppearanceData(forState: .invalid, data: invalid ?? .init(
        foregroundFont: Font.system(.footnote),
        borderColor: Color.red,
        foregroundColor: Color.red))
  }
  
  public static func setDefaultDecorator(appearance: SwiftlyDecoratorAppearance) {
    SwiftlyDecoratorAppearance._defaultInstance = appearance
  }
  
  @discardableResult
  public func registerAppearanceData(forState state: AppearanceState, data: AppearanceData) -> Self {
    appearances[state] = data
    return self
  }
  
  public func getFont(forTitleWithState state: AppearanceState, defaultValue: ValueProvider<Font>) -> Font {
    getAppearanceData(forState: state).titleFont ?? defaultValue()
  }
  
  public func getFont(forForegroundWithState state: AppearanceState, defaultValue: ValueProvider<Font>) -> Font {
    getAppearanceData(forState: state).foregroundFont ?? defaultValue()
  }
  
  public func getColor(forTitleWithState state: AppearanceState, defaultValue: ValueProvider<Color>) -> Color {
    getAppearanceData(forState: state).titleColor ?? defaultValue()
  }
  
  public func getColor(forBorderWithState state: AppearanceState, defaultValue: ValueProvider<Color>) -> Color {
    getAppearanceData(forState: state).borderColor ?? defaultValue()
  }
  
  public func getColor(forBackgroundWithState state: AppearanceState, defaultValue: ValueProvider<Color>) -> Color {
    getAppearanceData(forState: state).backgroundColor ?? defaultValue()
  }
  
  public func getColor(forForegroundWithState state: AppearanceState, defaultValue: ValueProvider<Color>) -> Color {
    getAppearanceData(forState: state).foregroundColor ?? defaultValue()
  }
  
  public func getColor(forAccentWithState state: AppearanceState, defaultValue: ValueProvider<Color>) -> Color {
    getAppearanceData(forState: state).accentColor ?? defaultValue()
  }
  
  public func getAppearanceData(forState state: AppearanceState? = nil) -> AppearanceData {
    guard let state = state else {
      return .init()
    }
    return appearances[state] ?? .init()
  }
}
