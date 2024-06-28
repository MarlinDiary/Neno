//
//  ButtonView.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import SwiftUI

import SwiftUI

struct ButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var text: String
    @FocusState.Binding var focusedField: Int?
    @Binding var pageID: Int
    var radius: CGFloat = 75
    var untappedColor: Color = Color(hex: "#C4ADB5")
    var darkuntappedColor: Color = Color(hex: "#C4ADB5")
    var tappedColor: Color = Color(hex: "#D55984")
    var isTapped: Bool {
        thisPageID == pageID
    }
    var hasContent: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines) != ""
    }
    var thisPageID: Int
    
    
    var body: some View {
        ZStack {
            Button {
                pageID = thisPageID
                focusedField = thisPageID
            } label: {
                if colorScheme == .light {
                    Circle()
                        .fill(Color(hex: "#CFD3D9").gradient.shadow(.inner(color: Color(hex: "#949BA9"), radius: 3*radius/75, x: 0, y: -6*radius/75)).shadow(.inner(color: Color(hex: "#E6E8E9"), radius: 3*radius/75, x: 0, y: 6*radius/75)))
                        .frame(width: radius * 2)
                } else {
                    Circle()
                        .fill(Color(hex: "#323333").gradient.shadow(.inner(color: Color(hex: "#2E2E2E"), radius: 3*radius/75, x: 0, y: -6*radius/75)).shadow(.inner(color: Color(hex: "#515351"), radius: 3*radius/75, x: 0, y: 6*radius/75)))
                        .frame(width: radius * 2)
                }
            }
            .buttonStyle(CustomButtonStyle(radius: radius))
            if colorScheme == .light {
                if hasContent {
                    Circle()
                        .fill(isTapped ? untappedColor.gradient.shadow(.inner(color: Color(hex: "#000000").opacity(0.5), radius: 3*radius/75, x: 0, y: 3*radius/75)).shadow(.inner(color: Color(hex: "#FFFFFF"), radius: 3*radius/75, x: 0, y: -2*radius/75)): tappedColor.gradient.shadow(.inner(color: Color(hex: "#000000").opacity(0.5), radius: 3*radius/75, x: 0, y: 3*radius/75)).shadow(.inner(color: Color(hex: "#FFFFFF"), radius: 3*radius/75, x: 0, y: -2*radius/75)))
                        .shadow(color: tappedColor.opacity(isTapped ? 1: 0), radius: 40*radius/75, x: 0, y: 0)
                        .frame(width: radius)
                        .allowsHitTesting(false)
                } else {
                    Circle()
                        .fill(isTapped ? Color(hex: "#F8F8F8").gradient.shadow(.inner(color: Color(hex: "#000000").opacity(0.1), radius: 3*radius/75, x: 0, y: 3*radius/75)).shadow(.inner(color: Color(hex: "#FFFFFF"), radius: 3*radius/75, x: 0, y: -2*radius/75)): Color(hex: "#CFD3D9").gradient.shadow(.inner(color: Color(hex: "#000000").opacity(0.5), radius: 3*radius/75, x: 0, y: 3*radius/75)).shadow(.inner(color: Color(hex: "#FFFFFF"), radius: 3*radius/75, x: 0, y: -2*radius/75)))
                        .shadow(color: Color(hex: "#F8F8F8").opacity(isTapped ? 1: 0), radius: 40*radius/75, x: 0, y: 0)
                        .frame(width: radius)
                        .allowsHitTesting(false)
                }
            } else {
                if hasContent {
                    Circle()
                        .fill(isTapped ? untappedColor.gradient.shadow(.inner(color: Color(hex: "#000000").opacity(0.5), radius: 3*radius/75, x: 0, y: 3*radius/75)).shadow(.inner(color: Color(hex: "#000000").opacity(0.7), radius: 3*radius/75, x: 0, y: -2*radius/75)): darkuntappedColor.gradient.shadow(.inner(color: Color(hex: "#000000").opacity(0.5), radius: 3*radius/75, x: 0, y: 3*radius/75)).shadow(.inner(color: Color(hex: "#000000"), radius: 3*radius/75, x: 0, y: -2*radius/75)))
                        .shadow(color: tappedColor.opacity(isTapped ? 1: 0), radius: 40*radius/75, x: 0, y: 0)
                        .frame(width: radius)
                        .allowsHitTesting(false)
                } else {
                    Circle()
                        .fill(isTapped ? Color(hex: "#FFFFFF").gradient.shadow(.inner(color: Color(hex: "#000000").opacity(0.5), radius: 3*radius/75, x: 0, y: 3*radius/75)).shadow(.inner(color: Color(hex: "#000000").opacity(0.7), radius: 3*radius/75, x: 0, y: -2*radius/75)): Color(hex: "#323333").gradient.shadow(.inner(color: Color(hex: "#000000").opacity(0.5), radius: 3*radius/75, x: 0, y: 3*radius/75)).shadow(.inner(color: Color(hex: "#000000"), radius: 3*radius/75, x: 0, y: -2*radius/75)))
                        .shadow(color: Color(hex: "#FFFFFF").opacity(isTapped ? 1: 0), radius: 40*radius/75, x: 0, y: 0)
                        .frame(width: radius)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    var radius: CGFloat = 75
    @Environment(\.colorScheme) var colorScheme
    func makeBody(configuration: Configuration) -> some View {
        if colorScheme == .light {
            configuration.label
                .shadow(color: Color(hex: "#68727D").opacity(configuration.isPressed ? 0.01: 0.3), radius: 12*radius/75, x: 0, y: 10*radius/75)
        } else {
            configuration.label
                .shadow(color: .black.opacity(configuration.isPressed ? 0.2: 0.6), radius: 12*radius/75, x: 0, y: 15*radius/75)
        }
    }
}
