//
//  SettingsView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.09.2024.
//

import SwiftUI



struct SettingsView: View {
    
    let coordinator: MainCoordinator
    
    @State var name: String
    @State var status: String
    @State var image: UIImage

    @State private var showLogoutAlert = false
    @State private var showDeleteAccountAlert = false
    @State private var showAlertMessage = false
    @State private var alertMessage: String?
    
    @AppStorage("preferredTheme") private var preferredTheme = 0
    @AppStorage("notificationsAllowed") private var notificationsAllowed: Bool = false

    @State private var notificationsDate: Date = UserDefaults.standard.object(forKey: "notificationsDate") as? Date ?? Date()

    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Spacer()
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(50.0)
                            
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, Color(uiColor: .accentColor))
                                .frame(width: 25, height: 25)
                        }
                        .onTapGesture {
                            print("Tapped")
                            coordinator.showProfilePicViewController(image: image)
                        }                        
                        Spacer()
                    }

                    
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
                        .onChange(of: preferredTheme) {
                            updateThemeInUIKit()
                        }
                    }
                    
                    Section("Notifications".localized) {
                        Toggle("Daily Notifications".localized, isOn: $notificationsAllowed)
                            .onChange(of: notificationsAllowed) {
                                LocalNotificationsService.checkNotificationSettings { status in 
                                    switch status {
                                    case .notDetermined:
                                        LocalNotificationsService.askPermission { granted in
                                            if granted {
                                                setNotification()
                                                notificationsDate = Date()
                                                UserDefaults.standard.set(notificationsDate, forKey: "notificationsDate")
                                            } else {
                                                notificationsAllowed = false
                                                showNotificationsDisabledAlert()
                                            }
                                        }
                                    case .denied:
                                        showNotificationsDisabledAlert()
                                    case .authorized, .provisional, .ephemeral:
                                        setNotification()
                                        notificationsDate = Date()
                                        UserDefaults.standard.set(notificationsDate, forKey: "notificationsDate")
                                    @unknown default:
                                        print("Unknown case")
                                    }
                                }
                        }
                    
                        if notificationsAllowed {
                            DatePicker("Time".localized, selection: $notificationsDate, displayedComponents: .hourAndMinute)
                            Button("Save".localized) {
                                let hour = Calendar.current.component(.hour, from: notificationsDate)
                                let minute = Calendar.current.component(.minute, from: notificationsDate)
                                LocalNotificationsService.scheduleDailyNotification(hour: hour, minute: minute)
                                UserDefaults.standard.set(notificationsDate, forKey: "notificationsDate")
                            }
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
                                        coordinator.logout()
                                    } catch {
                                        print("Couldn't delete user")
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .alert(isPresented: $showAlertMessage) {
                        Alert(
                            title: Text("Alert!".localized),
                            message: Text(alertMessage ?? ""),
                            dismissButton: .default(Text("OK".localized))
                        )
                    }
                }
            }
            .navigationTitle("Settings".localized)
        }
    }
    
    private func logout() {
        Task {
            do {
                try await FirebaseService.shared.resetPassword(email: "severus99@icloud.com")
                coordinator.logout()
            } catch {
                print("Error")
            }
        }
    }
    
    private func setNotification() {
        let hour = Calendar.current.component(.hour, from: notificationsDate)
        let minute = Calendar.current.component(.minute, from: notificationsDate)
        LocalNotificationsService.scheduleDailyNotification(hour: hour, minute: minute)
    }
    
    private func showNotificationsDisabledAlert() {
        alertMessage = "Notifications are disabled for this app. Please, review policies in device settings.".localized
        showAlertMessage.toggle()
    }
    
    private func updateThemeInUIKit() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.applyTheme(preferredTheme)
    }
}

/*
#Preview {
    SettingsView(name: "Name", status: "Status")
}
*/

