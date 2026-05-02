//
//  APIKeyManager.swift
//  Top-League
//
//  Created by JETSMobileLabMini6 on 30/04/2026.
//
import Foundation

class APIKeyManager {
    
    static let shared = APIKeyManager()
    private init() {}
    
    private let userDefaultsKey = "com.topleague.apikey"
    
    private var defaultAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String,
              !key.isEmpty else {
            fatalError("API Key not found in Info.plist")
        }
        return key
    }
    
    func saveAPIKey(_ key: String) {
        UserDefaults.standard.set(key, forKey: userDefaultsKey)
    }
    
    var apiKey: String {
        return UserDefaults.standard.string(forKey: userDefaultsKey) ?? defaultAPIKey
    }
    
    func clearAPIKey() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    var hasCustomKey: Bool {
        return UserDefaults.standard.string(forKey: userDefaultsKey) != nil
    }
}
