//
//  LocalAuthorizationService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.08.2024.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationService {
    
    static let shared = LocalAuthorizationService()
    
    private init() {}
    
    func biometricType() -> BiometricType {
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
    
    func authenticate(success: @escaping () -> Void, failure: @escaping (Error?) -> Void) {
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
