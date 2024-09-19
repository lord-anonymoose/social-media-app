//
//  SettingsView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.09.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @State var name: String
    @State var status: String
    
    @State var showLogoutAlert = false
    @State var showDeleteAccountAlert = false
    
    @State var showAlertMessage = false
    @State var alertMessage: String?

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
                        }
                        Divider()
                        HStack {
                            Text("Status".localized)
                                .padding(.trailing, 25)
                            TextField("Status".localized, text: $status)
                        }
                    }
                }
                
                Button("Save".localized) {
                    Task {
                        do {
                            try await FirebaseService.shared.updateUserInformation(newName: name, newStatus: status)
                            alertMessage = "Your information is saved!".localized
                            showAlertMessage.toggle()
                        } catch {
                        }
                    }
                }
                
                Section("Privacy & Security".localized) {
                    Button("Send reset password link".localized) {
                        showLogoutAlert.toggle()
                    }
                }
                
                Section("App Settings".localized) {
                    Picker("Preferred theme".localized, selection: $preferredTheme) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                }
                
                Button("Log out".localized, role: .cancel) {
                    logout()
                }
                
                Section() {
                    Button("Delete account".localized, role: .destructive) {
                        
                        showDeleteAccountAlert.toggle()
                    }
                }
                
                .alert(isPresented: self.$showLogoutAlert) {
                    Alert(
                        title: Text("Warning!".localized),
                        message: Text("Resetting your password would lead to logging out from the app. Do you want to continue?".localized),
                        primaryButton: .destructive(Text("Reset Password".localized)) {
                            logout()
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                .alert(isPresented: self.$showDeleteAccountAlert) {
                    Alert(
                        title: Text("Warning!".localized),
                        message: Text("Deleting account is permanent. You can not undo or restore your account after that".localized),
                        primaryButton: .destructive(Text("Delete account".localized)) {
                            Task {
                                do {
                                    try await FirebaseService.shared.deleteCurrentUser()
                                    let navigationController = UINavigationController()
                                    let coordinator = MainCoordinator(navigationController: navigationController)
                                    coordinator.logout()
                                } catch {
                                    print("Couldn't delete user")
                                }
                            }
                        },
                          secondaryButton: .cancel()
                    )
                }
                
                .alert(isPresented: self.$showAlertMessage) {
                    Alert(
                        title: Text("Alert!".localized),
                        message: Text(alertMessage ?? ""),
                        dismissButton: .default(Text("OK".localized)) {
                            let navigationController = UINavigationController()
                            let coordinator = MainCoordinator(navigationController: navigationController)
                            coordinator.login()
                        }
                    )
                }
            }
            .navigationTitle("Settings".localized)
        }
    }
    
    private func logout() {
        Task {
            do {
                try await FirebaseService.shared.resetPassword(email: "severus99@icloud.com")
                let navigationController = UINavigationController()
                let coordinator = MainCoordinator(navigationController: navigationController)
                coordinator.logout()
            } catch {
                print("Error")
            }
        }
    }
}

#Preview {
    SettingsView(name: "Name", status: "Status")
}