//
//  InfoButtonView.swift
//  Neno
//
//  Created by Drawix on 2024/6/23.
//

import SwiftUI

struct InfoButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    var radius: CGFloat = 75
    @Binding var isTapped: Bool
    var body: some View {
        Button {
            withAnimation {
                isTapped.toggle()
            }
        } label: {
            ZStack{
                if colorScheme == .light {
                    Circle()
                        .fill(Color(hex: "#CFD3D9").gradient.shadow(.inner(color: Color(hex: "#949BA9"), radius: 3*radius/75, x: 0, y: -6*radius/75)).shadow(.inner(color: Color(hex: "#E6E8E9"), radius: 3*radius/75, x: 0, y: 6*radius/75)))
                        .frame(width: radius * 2)
                } else {
                    Circle()
                        .fill(Color(hex: "#323333").gradient.shadow(.inner(color: Color(hex: "#2E2E2E"), radius: 3*radius/75, x: 0, y: -6*radius/75)).shadow(.inner(color: Color(hex: "#515351"), radius: 3*radius/75, x: 0, y: 6*radius/75)))
                        .frame(width: radius * 2)
                }
                Image(systemName: "ellipsis")
                    .opacity(0.4)
                    //.rotationEffect(isTapped ? .degrees(360): .zero)
                    .font(.custom("", size: radius*1.1))
                    .allowsHitTesting(false)
            }
        }
        .buttonStyle(CustomButtonStyle(radius: radius))
    }
}

#Preview {
    InfoButtonView(isTapped: .constant(false))
}
