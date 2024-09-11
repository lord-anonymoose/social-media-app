//
//  SecretWordModel.swift
//  Social Media
//
//  Created by Philipp Lazarev on 18.05.2024.
//

/*
 
 FOLLOWING CODE IS DEPRECATED AND IS NOT USED IN LATEST APP VERSIONS
 
 */

/*
import Foundation

struct SecretWordModel {
    var guessed: Bool?
    var currentEmoji = ""
    var currentPhrase = ""
    
    private let correctEmojis = ["💪", "⭐️", "🥳", "👏", "👍", "🥇", "🎉", "✅"]
    private let wrongEmojis = ["😑", "👎", "🤔", "🙁", "❌", "🚫", "🗿"]
    
    private let correctPhrases = [
        "Well done!",
        "You are right!",
        "Absolutely!",
        "Yesss!",
        "Nicely done!",
        "You nailed it!"
    ]
    
    private let wrongPhrases = [
        "Not this time...",
        "Try again maybe...",
        "Nope...",
        "You were close, but not too much...",
        "Wrong...",
        "No, it's not..."
    ]
    
    init(guessed: Bool?) {
        if guessed != nil {
            if guessed == true {
                self.currentEmoji = correctEmojis.randomElement() ?? "✅"
                self.currentPhrase = correctPhrases.randomElement() ?? "Yes!"
            } else {
                self.currentEmoji = wrongEmojis.randomElement() ?? "❌"
                self.currentPhrase = wrongPhrases.randomElement() ?? "No"
            }
        } else {
            self.currentEmoji = "❓"
            self.currentPhrase = "Time to guess a secret word"
        }
    }
    
    init() {
        self.currentEmoji = "❓"
        self.currentPhrase = "Time to guess a secret word"
    }
}
*/
