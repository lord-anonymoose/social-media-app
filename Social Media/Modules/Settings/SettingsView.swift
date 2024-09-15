//
//  SettingsView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.09.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var name = "Philipp Lazarev"
    @State private var status = "Hello, world"
    @State private var isDisabled = true
    
    @State var showsAlert = false

    @AppStorage("preferredTheme") private var preferredTheme = 0
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section("My information") {
                    VStack {
                        HStack {
                            Text("Name".localized)
                                .padding(.trailing, 25)
                            TextField("Name".localized, text: $name)
                                .disabled(isDisabled)
                        }
                        Divider()
                        HStack {
                            Text("Status".localized)
                                .padding(.trailing, 25)
                            TextField("Status".localized, text: $status)
                        }
                        Divider()
                        HStack {
                            Button("Save information".localized) {
                                print("Information saved")
                            }
                            Spacer()
                        }
                    }
                    .alert(isPresented: self.$showsAlert) {
                        Alert(
                            title: Text("Warning!".localized),
                            message: Text("Resetting your password would lead to logging out from the app. Do you want to continue?".localized),
                            primaryButton: .destructive(Text("Reset Password")) {
                                Task {
                                    do {
                                        try await FirebaseService.shared.resetPassword(email: "severus99@icloud.com")
                                        let navigationController = UINavigationController()
                                        let coordinator = MainCoordinator(navigationController: navigationController)
                                        coordinator.logout()
                                    } catch {
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
                Section("Privacy & Security".localized) {
                    Button("Send reset password link".localized) {
                        showsAlert.toggle()
                    }
                }
                
                Section("App Settings".localized) {
                    Picker("Preferred theme".localized, selection: $preferredTheme) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    
                }
                
            }
            .navigationTitle("Settings".localized)
        }
    }
}

#Preview {
    SettingsView()
}
