//
//  LaunchScreenView.swift
//  Neno
//
//  Created by Drawix on 2024/6/22.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var rectangleHeight: CGFloat = 12
    @State private var isAnimating = false
    @State private var easeOut = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "CFD3D9"), Color(hex: "A1A7AF")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(hex: "FEFFFD").shadow(.inner(color: .black.opacity(0.3), radius: 9, x: 0, y: 0)).shadow(.inner(color: .white, radius: 2, x: 0, y: 6)))
                .frame(width: 135,height: 105)
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(lineWidth: 5)
                .frame(width: 135,height: 105)
                .foregroundStyle(Color(hex: "4B5056"))
            HStack(spacing: 30) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(hex: "4B5056").shadow(.inner(color: .white.opacity(0.4), radius: 2, x: 2, y: 0)))
                    .frame(width: 12, height: rectangleHeight)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(hex: "4B5056").shadow(.inner(color: .white.opacity(0.4), radius: 2, x: 2, y: 0)))
                    .frame(width: 12, height: rectangleHeight)
            }
        }
        .opacity(easeOut ? 0: 1)
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { timer in
            withAnimation(.spring(duration: 0.5)) {
                    rectangleHeight = 36
            }
        }
    }
}


#Preview {
    LaunchScreenView()
}
