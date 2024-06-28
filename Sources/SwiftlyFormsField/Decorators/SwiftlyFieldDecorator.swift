//
//  File.swift
//  
//
//  Created by Kembene Nkem on 27/06/2024.
//

import Foundation
import SwiftUI
import SwiftlyFormsCore

public struct SwiftlyFieldDecoratorConfig {
  var spacing: EdgeInsets
  var titleSpacing: CGFloat
  var borderWidth: CGFloat
  var cornerRadius: CGFloat
  public init(
    spacing: EdgeInsets? = nil,
    titleSpacing: CGFloat = 10,
    borderWidth: CGFloat = 1,
    cornerRadius: CGFloat = 10
  ) {
    self.spacing = spacing ?? .init(top: 10, leading: 10, bottom: 10, trailing: 10)
    self.titleSpacing = titleSpacing
    self.borderWidth = borderWidth
    self.cornerRadius = cornerRadius
  }
  
}

public struct SwiftlyFieldDecorator<Content>: View where Content: View {
  
  @EnvironmentObject var _appearance: SwiftlyDecoratorAppearance
  
  @Environment(\.swiftlyFormFieldTitle) var title: String?
  @Environment(\.swiftlyFormFieldErrorMessage) var errorMessage: String?
  
  private var _config: SwiftlyFieldDecoratorConfig?
  private var overriddenAppearance: SwiftlyDecoratorAppearance?
  private var content: () -> Content
  
  var appearance: SwiftlyDecoratorAppearance { overriddenAppearance ?? _appearance }
  var config: SwiftlyFieldDecoratorConfig { _config ?? appearance.config }
  
  @State var appearanceData: AppearanceData = .init()
  @State var appearanceState: AppearanceState = .basic
  @State var appearanceErrorData: AppearanceData = .init()
  
  
  public init(appearance: SwiftlyDecoratorAppearance? = nil,
              config: SwiftlyFieldDecoratorConfig? = nil,
              @ViewBuilder content: @escaping () -> Content) {
    self.content = content
    self.overriddenAppearance = appearance
    self._config = config
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      Text(title ?? "")
        .font(appearanceData.titleFont)
        .foregroundStyle(appearanceData.foregroundColor ?? Color.primary)
        .lineLimit(1, reservesSpace: true)
      VStack(alignment: .leading) {
        content()
        if let error = errorMessage {
          Text(error)
            .font(appearanceErrorData.foregroundFont)
            .foregroundStyle(appearanceErrorData.foregroundColor ?? Color.red)
        }
      }
    }
    .padding(.top, config.spacing.top)
    .padding(.bottom, config.spacing.bottom)
    .padding(.leading, config.spacing.leading)
    .padding(.trailing, config.spacing.trailing)
    .background(appearance.background ?? .clear)
    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
    .overlay(
      RoundedRectangle(cornerRadius: config.cornerRadius)
        .stroke(appearanceData.borderColor ?? Color.clear, lineWidth: config.borderWidth)
      )
    .onAppear {
      self.onViewDidAppear()
    }
  }
  
  func onViewDidAppear() {
    let state = resolveCurrentAppearanceState()
    appearanceData = appearance.getAppearanceData(forState: state)
    appearanceErrorData = appearance.getAppearanceData(forState: .invalid)
    appearanceState = state
  }
  
  func resolveCurrentAppearanceState() -> AppearanceState {
    return .basic
  }
  
}

public struct SwiftlyFieldDecoratorModifier: ViewModifier {
  
  var appearance: SwiftlyDecoratorAppearance?
  var config: SwiftlyFieldDecoratorConfig?
  
  public init(appearance: SwiftlyDecoratorAppearance? = nil, config: SwiftlyFieldDecoratorConfig? = nil) {
    self.appearance = appearance
    self.config = config
  }
  
  public func body(content: Content) -> some View {
    SwiftlyFieldDecorator(appearance: appearance, config: config) {
      content
    }
  }
  
}

public extension View {
  func swiftlyDecorator(appearance: SwiftlyDecoratorAppearance? = nil, config: SwiftlyFieldDecoratorConfig? = nil) -> some View {
    self.modifier(SwiftlyFieldDecoratorModifier(appearance: appearance, config: config))
  }
}
