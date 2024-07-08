//
//  SettingView.swift
//  Neno
//
//  Created by Drawix on 2024/6/26.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("colorSchemeMode") private var colorSchemeMode = "System" // System, Dark, Light
    @AppStorage("appIcon") private var appIcon = "Gray"
    @AppStorage("iCloudSync") private var iCloudSync = true
    @AppStorage("confirmDelete") private var confirmDelete = false
    @AppStorage("fontSize") private var fontSize = "Medium"
    @AppStorage("font") private var font = "Arial"
    @State private var sensorTrigger = false
    
    @Binding var infoisOn: Bool
    var strokeColor: String
    @Binding var deleteSensorTrigger: Bool
    @Binding var copySensorTrigger: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // Info View
                HStack {
                    Text("Settings")
                    Spacer()
                    Button(action: {
                        withAnimation {
                            infoisOn.toggle()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .rotationEffect(infoisOn ? .zero : .degrees(90))
                    }
                }
                .font(.title2.bold())
                
                Spacer()
                Divider()
                Spacer()
                
                Group {
                    Button(action: {
                        switch colorSchemeMode {
                        case "System":
                            colorSchemeMode = "Dark"
                        case "Dark":
                            colorSchemeMode = "Light"
                        default:
                            colorSchemeMode = "System"
                        }
                        applyColorScheme()
                        sensorTrigger.toggle()
                    }) {
                        HStack {
                            Image(systemName: "flipphone")
                            Text("Color Scheme: \(colorSchemeMode)")
                        }
                    }
                    
                    Spacer()
                    Button(action: {
                        appIcon = (appIcon == "Gray") ? "Yellow" : "Gray"
                        UIApplication.shared.setAlternateIconName(appIcon == "Gray" ? nil : "AppIconYellow")
                        sensorTrigger.toggle()
                    }) {
                        HStack {
                            Image(systemName: "app.gift")
                            Text("App Icon: \(appIcon)")
                        }
                    }
                }
                
                Spacer()
                Divider()
                Spacer()
                
                Group {
                    Button(action: {
                        iCloudSync.toggle()
                        sensorTrigger.toggle()
                    }) {
                        HStack {
                            Image(systemName: "icloud")
                            Text("iCloud Sync: \(iCloudSync ? "Open" : "Closed")")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        sensorTrigger.toggle()
                        confirmDelete.toggle()
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("Confirm Delete: \(confirmDelete ? "Open" : "Closed")")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        // 打开系统语言设置
                        sensorTrigger.toggle()
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "eyeglasses")
                            Text("Language: English")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        sensorTrigger.toggle()
                        switch fontSize {
                        case "Small":
                            fontSize = "Medium"
                        case "Medium":
                            fontSize = "Large"
                        default:
                            fontSize = "Small"
                        }
                    }) {
                        HStack {
                            Image(systemName: "textformat.alt")
                            Text("Font Size: \(fontSize)")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                                            sensorTrigger.toggle()
                                            switch font {
                                            case "Arial":
                                                font = "Helvetica"
                                            case "Helvetica":
                                                font = "Courier"
                                            default:
                                                font = "Arial"
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: "textformat")
                                                Text("Font: \(font)")
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                }
            }
            .foregroundStyle(.primary.opacity(0.8))
            .padding()
            .sensoryFeedback(.warning, trigger: deleteSensorTrigger)
            .sensoryFeedback(.success, trigger: copySensorTrigger)
            .sensoryFeedback(.success, trigger: sensorTrigger)
        }
        .padding(.top, colorScheme == .light ? 12 : 9)
        .padding(.leading, colorScheme == .light ? 12 : 9)
        .padding(.trailing, colorScheme == .light ? 12 : 9)
        .padding(.bottom, colorScheme == .light ? 12 : 11)
        .onAppear {
            applyColorScheme()
        }
    }
    
    func applyColorScheme() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        switch colorSchemeMode {
        case "Dark":
            scene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        case "Light":
            scene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        default:
            scene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}

#Preview {
    SettingView(infoisOn: .constant(true), strokeColor: "00000", deleteSensorTrigger: .constant(true), copySensorTrigger: .constant(true))
}
