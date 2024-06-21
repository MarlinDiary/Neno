//
//  RightAngledTrapezoid.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import Foundation
import SwiftUI

struct RightAngledTrapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let topWidth = width * 0.3   // 上底是总宽的 1/5
        let bottomWidth = width * 0.7  // 下底是总宽的 1/2

        var path = Path()

        path.move(to: CGPoint(x: width - topWidth, y: 0))       // 左上角点
        path.addLine(to: CGPoint(x: width, y: 0))               // 右上角点
        path.addLine(to: CGPoint(x: width, y: height))          // 右下角点
        path.addLine(to: CGPoint(x: width - bottomWidth, y: height)) // 左下角点
        path.addLine(to: CGPoint(x: width - topWidth, y: 0))    // 回到左上角点

        return path
    }
}
