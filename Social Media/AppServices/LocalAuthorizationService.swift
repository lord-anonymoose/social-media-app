//
//  LocalAuthorizationService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.08.2024.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationService {
    
    static func biometricType() -> BiometricType {
        let authContext = LAContext()
        var error: NSError?
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            case .opticID:
                return .optic
            @unknown default:
                return .none
            }
        } else {
            return .none
        }
    }
    
    static func authenticate(success: @escaping () -> Void, failure: @escaping (Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = String(localized: "Identification")
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { authSuccess, authError in
                DispatchQueue.main.async {
                    if authSuccess {
                        success()
                    } else {
                        failure(authError)
                    }
                }
            }
        } else {
            failure(error)
        }
    }
    
    enum BiometricType {
        case none
        case touch
        case face
        case optic
    }
}
/*
final class LocalAuthorizationService {
    
    
    static func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            case .opticID:
                return .optic
            @unknown default:
                return .none
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    static func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            let reason = "Идентифицируйте себя"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                if success {
                    DispatchQueue.main.async { //[unowned self] in
                        print("Успешная авторизация")
                    }
                }
            }

        } else {
            print("Face/Touch ID не найден")
        }
    }
    
    enum BiometricType {
        case none
        case touch
        case face
        case optic
    }
    
}
*/
