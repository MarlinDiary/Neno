//
//  LaunchScreenView.swift
//  Neno
//
//  Created by Drawix on 2024/6/22.
//

import SwiftUI

struct LaunchScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if colorScheme == .light {
                LinearGradient(colors: [Color(hex: "CFD3D9"), Color(hex: "A1A7AF")], startPoint: .top, endPoint: .bottom)
        } else {
                LinearGradient(colors: [Color(hex: "313232"), Color(hex: "1E1F1F")], startPoint: .top, endPoint: .bottom)
        }
    }
}


#Preview {
    LaunchScreenView()
}
