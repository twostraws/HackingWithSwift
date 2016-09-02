//
//  KeychainWrapper.swift
//  KeychainWrapper
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 Jason Rendel. All rights reserved.
//
//    The MIT License (MIT)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import Foundation


private let SecMatchLimit: String! = kSecMatchLimit as String
private let SecReturnData: String! = kSecReturnData as String
private let SecReturnPersistentRef: String! = kSecReturnPersistentRef as String
private let SecValueData: String! = kSecValueData as String
private let SecAttrAccessible: String! = kSecAttrAccessible as String
private let SecClass: String! = kSecClass as String
private let SecAttrService: String! = kSecAttrService as String
private let SecAttrGeneric: String! = kSecAttrGeneric as String
private let SecAttrAccount: String! = kSecAttrAccount as String
private let SecAttrAccessGroup: String! = kSecAttrAccessGroup as String

private let sharedKeychainWrapper = KeychainWrapper()

/// KeychainWrapper is a class to help make Keychain access in Swift more straightforward. It is designed to make accessing the Keychain services more like using NSUserDefaults, which is much more familiar to people.
public class KeychainWrapper {
    
    /// ServiceName is used for the kSecAttrService property to uniquely identify this keychain accessor. If no service name is specified, KeychainWrapper will default to using the bundleIdentifier.
    fileprivate (set) public var serviceName: String
    
    /// AccessGroup is used for the kSecAttrAccessGroup property to identify which Keychain Access Group this entry belongs to. This allows you to use the KeychainWrapper with shared keychain access between different applications.
    fileprivate (set) public var accessGroup: String?
    
    private static let defaultServiceName: String = {
        return Bundle.main.bundleIdentifier ?? "SwiftKeychainWrapper"
    }()

    fileprivate convenience init() {
        self.init(serviceName: KeychainWrapper.defaultServiceName)
    }
    
    /// Create a custom instance of KeychainWrapper with a custom Service Name and optional custom access group.
    ///
    /// - parameter serviceName: The ServiceName for this instance. Used to uniquely identify all keys stored using this keychain wrapper instance.
    /// - parameter accessGroup: Optional unique AccessGroup for this instance. Use a matching AccessGroup between applications to allow shared keychain access.
    public init(serviceName: String, accessGroup: String? = nil) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }
    
    /// Standard access keychain
    public class func standardKeychainAccess() -> KeychainWrapper {
        return sharedKeychainWrapper
    }

    // MARK:- Public Methods
    
    /// Checks if keychain data exists for a specified key.
    ///
    /// - parameter keyName: The key to check for.
    /// - parameter withOptions: Optional KeychainItemOptions to use when retrieving the keychain item.
    /// - returns: True if a value exists for the key. False otherwise.
    public func hasValue(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Bool {
        if let _ = self.data(forKey: keyName, withOptions: options) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Public Getters
    
    public func integer(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Int? {
        guard let numberValue = self.object(forKey: keyName, withOptions: options) as? NSNumber else {
            return nil
        }
        
        return numberValue.intValue
    }
    
    public func float(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Float? {
        guard let numberValue = self.object(forKey: keyName, withOptions: options) as? NSNumber else {
            return nil
        }
        
        return numberValue.floatValue
    }
    
    public func double(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Double? {
        guard let numberValue = object(forKey: keyName, withOptions: options) as? NSNumber else {
            return nil
        }
        
        return numberValue.doubleValue
    }
    
    public func bool(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Bool? {
        guard let numberValue = object(forKey: keyName, withOptions: options) as? NSNumber else {
            return nil
        }
        
        return numberValue.boolValue
    }
    
    /// Returns a string value for a specified key.
    ///
    /// - parameter keyName: The key to lookup data for.
    /// - parameter withOptions: Optional KeychainItemOptions to use when retrieving the keychain item.
    /// - returns: The String associated with the key if it exists. If no data exists, or the data found cannot be encoded as a string, returns nil.
    public func string(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> String? {
        guard let keychainData = self.data(forKey: keyName, withOptions: options) else {
            return nil
        }
        
        return String(data: keychainData as Data, encoding: .utf8) as String?
    }
    
    /// Returns an object that conforms to NSCoding for a specified key.
    ///
    /// - parameter keyName: The key to lookup data for.
    /// - parameter withOptions: Optional KeychainItemOptions to use when retrieving the keychain item.
    /// - returns: The decoded object associated with the key if it exists. If no data exists, or the data found cannot be decoded, returns nil.
    public func object(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> NSCoding? {
        guard let keychainData = self.data(forKey: keyName, withOptions: options) else {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: keychainData as Data) as? NSCoding
    }

    
    /// Returns a Data object for a specified key.
    ///
    /// - parameter keyName: The key to lookup data for.
    /// - parameter withOptions: Optional KeychainItemOptions to use when retrieving the keychain item.
    /// - returns: The Data object associated with the key if it exists. If no data exists, returns nil.
    public func data(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Data? {
        var keychainQueryDictionary = self.setupKeychainQueryDictionary(forKey: keyName, withOptions: options)
        var result: AnyObject?
        
        // Limit search results to one
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want Data/CFData returned
        keychainQueryDictionary[SecReturnData] = kCFBooleanTrue
        
        // Search
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keychainQueryDictionary as CFDictionary, UnsafeMutablePointer($0))
        }
        
        return status == noErr ? result as? Data : nil
    }
    
    
    /// Returns a persistent data reference object for a specified key.
    ///
    /// - parameter keyName: The key to lookup data for.
    /// - parameter withOptions: Optional KeychainItemOptions to use when retrieving the keychain item.
    /// - returns: The persistent data reference object associated with the key if it exists. If no data exists, returns nil.
    public func dataRef(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Data? {
        var keychainQueryDictionary = self.setupKeychainQueryDictionary(forKey: keyName, withOptions: options)
        var result: AnyObject?
        
        // Limit search results to one
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want persistent Data/CFData reference returned
        keychainQueryDictionary[SecReturnPersistentRef] = kCFBooleanTrue
        
        // Search
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keychainQueryDictionary as CFDictionary, UnsafeMutablePointer($0))
        }
        
        return status == noErr ? result as? Data : nil
    }
    
    // MARK: Public Setters
    
    /// Save a String value to the keychain associated with a specified key. If a String value already exists for the given keyname, the string will be overwritten with the new value.
    ///
    /// - parameter value: The String value to save.
    /// - parameter forKey: The key to save the String under.
    /// - parameter withOptions: Optional KeychainItemOptions to use when setting the keychain item.
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult public func setString(_ value: String, forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Bool {
        if let data = value.data(using: .utf8) {
            return self.setData(data as Data, forKey: keyName, withOptions: options)
        } else {
            return false
        }
    }

    /// Save an NSCoding compliant object to the keychain associated with a specified key. If an object already exists for the given keyname, the object will be overwritten with the new value.
    ///
    /// - parameter value: The NSCoding compliant object to save.
    /// - parameter forKey: The key to save the object under.
    /// - parameter withOptions: Optional KeychainItemOptions to use when setting the keychain item.
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult public func setObject(_ value: Any, forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        return self.setData(data as Data, forKey: keyName, withOptions: options)
    }

    /// Save a Data object to the keychain associated with a specified key. If data already exists for the given keyname, the data will be overwritten with the new value.
    ///
    /// - parameter value: The Data object to save.
    /// - parameter forKey: The key to save the object under.
    /// - parameter withOptions: Optional KeychainItemOptions to use when setting the keychain item.
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult public func setData(_ value: Data, forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Bool {
        var keychainQueryDictionary: [String:Any] = self.setupKeychainQueryDictionary(forKey: keyName, withOptions: options)
        
        keychainQueryDictionary[SecValueData] = value
        
        let status: OSStatus = SecItemAdd(keychainQueryDictionary as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return self.updateData(value, forKey: keyName)
        } else {
            return false
        }
    }

    /// Remove an object associated with a specified key.
    ///
    /// - parameter keyName: The key value to remove data for.
    /// - parameter withOptions: Optional KeychainItemOptions to use when looking up the keychain item.
    /// - returns: True if successful, false otherwise.
    @discardableResult public func removeObject(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> Bool {
        let keychainQueryDictionary: [String:Any] = self.setupKeychainQueryDictionary(forKey: keyName)

        // Delete
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)

        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    /// Remove all keychain data added through KeychainWrapper. This will only delete items matching the currnt ServiceName and AccessGroup if one is set.
    public func removeAllKeys() -> Bool {
        //let keychainQueryDictionary = self.setupKeychainQueryDictionary(forKey: keyName)
        
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        var keychainQueryDictionary: [String:Any] = [SecClass:kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[SecAttrService] = self.serviceName
        
        // Set the keychain access group if defined
        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        }
        
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    /// Remove all keychain data, including data not added through keychain wrapper.
    ///
    /// - Warning: This may remove custom keychain entries you did not add via SwiftKeychainWrapper.
    ///
    public class func wipeKeychain() {
        deleteKeychainSecClass(kSecClassGenericPassword) // Generic password items
        deleteKeychainSecClass(kSecClassInternetPassword) // Internet password items
        deleteKeychainSecClass(kSecClassCertificate) // Certificate items
        deleteKeychainSecClass(kSecClassKey) // Cryptographic key items
        deleteKeychainSecClass(kSecClassIdentity) // Identity items
    }

    // MARK:- Private Methods
    
    /// Remove all items for a given Keychain Item Class
    ///
    ///
    @discardableResult private class func deleteKeychainSecClass(_ secClass: AnyObject) -> Bool {
        let query = [SecClass: secClass]
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    /// Update existing data associated with a specified key name. The existing data will be overwritten by the new data
    private func updateData(_ value: Data, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: [String:Any] = self.setupKeychainQueryDictionary(forKey: keyName)
        let updateDictionary = [SecValueData:value]

        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary as CFDictionary, updateDictionary as CFDictionary)

        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    /// Setup the keychain query dictionary used to access the keychain on iOS for a specified key name. Takes into account the Service Name and Access Group if one is set.
    ///
    /// - parameter keyName: The key this query is for
    /// - parameter withOptions: The KeychainItemOptions to use when setting the keychain item.
    /// - returns: A dictionary with all the needed properties setup to access the keychain on iOS
    private func setupKeychainQueryDictionary(forKey keyName: String, withOptions options: KeychainItemOptions? = nil) -> [String:Any] {
        var keychainQueryDictionary = [String:Any]()
        
        if let options = options {
            keychainQueryDictionary[SecClass] = options.itemClass.keychainAttrValue
            keychainQueryDictionary[SecAttrAccessible] = options.itemAccessibility.keychainAttrValue
        } else {
            // Setup default access as generic password (rather than a certificate, internet password, etc)
            keychainQueryDictionary[SecClass] = KeychainItemClass.GenericPassword.keychainAttrValue
            
            // Protect the keychain entry so it's only valid when the device is unlocked
            keychainQueryDictionary[SecAttrAccessible] = KeychainItemAccessibility.WhenUnlocked.keychainAttrValue
        }
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[SecAttrService] = self.serviceName
        
        // Set the keychain access group if defined
        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        }
        
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier = keyName.data(using: .utf8)
        
        keychainQueryDictionary[SecAttrGeneric] = encodedIdentifier
        
        keychainQueryDictionary[SecAttrAccount] = encodedIdentifier
        
        return keychainQueryDictionary
    }
}
