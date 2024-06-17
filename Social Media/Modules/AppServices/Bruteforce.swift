//
//  Bruteforce.swift
//  Social Media
//
//  Created by Philipp Lazarev on 17.06.2024.
//

import Foundation

final class AppBruteforce {
    func bruteForce(userToUnclock: String) -> String {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""
        
        
        do {
            let passwordToUnlock = try Checker.getPassword(login: userToUnclock)
            
            while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                print(password)
            }
        }
        catch AppError.userNotExist {
            print("User does not exist")
        }
        catch AppError.passwordIncorrect {
            print("Password is incorrect")
        }
        catch {
            print("Unknown error")
        }        
        print("Password unlocked: \(password)")
        return password
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }
    
    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }
    
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
}
