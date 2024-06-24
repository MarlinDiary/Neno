//
//  SettingView.swift
//  Neno
//
//  Created by Drawix on 2024/6/23.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var settingisOn: Bool
    var body: some View {
        ZStack {
            Color(hex: colorScheme == .light ? "#CFD3D9": "#323333")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SettingView(settingisOn: .constant(true))
}
