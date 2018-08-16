//
//  AppData.swift
//  flex-mitt
//
//  Created by Admin on 4/9/17.
//  Copyright © 2017 Flex-Sports. All rights reserved.
//


import UIKit
import Foundation

final class AppData {
    
    static let sharedInstance = AppData()

    private static let SettingExist = "SettingExist"
    private static let FirstSetting = "FirstSetting"
    private static let RoundCount = "RoundCount"
    private static let RoundDuration = "RoundDuration"
    private static let WarnDelay = "WarnDelay"
    private static let RestDuration = "RestDuration"
    private static let CountLM = "CountLM"
    private static let CountRM = "CountRM"
    
    
    private static let DefaultRoundCountIndex = 7 // Default = 8
    private static let DefaultDurationIndex = 0    // Default = 0
    private static let DefaultWarnDelayIndex = 0   // Default = 0
    private static let DefaultRestDurationIndex = 0 // Default = 0
    
    private static let RestDurationArray = [15, 30, 60, 120, 180]

    
    
    private init() {
    }
    
    class func setDefault() {
        
        setRoundCount(count: DefaultRoundCountIndex)
        setRoundDuration(count: DefaultDurationIndex)
        setWarnDelay(count: DefaultWarnDelayIndex)
        setRestDuration(count: DefaultRestDurationIndex)
        
        setSettingExist(isExist: true)
    }
    
    class func setFirstSetting(firstSetting:Bool) {
        let defaults = UserDefaults.standard
        defaults.set(firstSetting, forKey: FirstSetting)
        defaults.synchronize()
    }
    
    class func getFirstSetting() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: FirstSetting)
    }
    
    
    class func setSettingExist(isExist:Bool) {
        let defaults = UserDefaults.standard
        defaults.set(isExist, forKey: SettingExist)
        defaults.synchronize()
    }
    
    class func getSettingExist() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: SettingExist)
    }
    
    
    class func setRoundCount(count:Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: RoundCount)
        defaults.synchronize()
    }
    
    class func getRoundCount() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: RoundCount)
    }
    
    
    class func setRoundDuration(count:Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: RoundDuration)
        defaults.synchronize()
    }
    
    class func getRoundDuration() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: RoundDuration)
    }
    
    
    class func setWarnDelay(count:Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: WarnDelay)
        defaults.synchronize()
    }
    
    class func getWarnDelay() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: WarnDelay)
    }
    
    
    class func setRestDuration(count:Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: RestDuration)
        defaults.synchronize()
    }
    
    class func getRestDuration() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: RestDuration)
    }
    
    class func setCountLM(countLM: [Int]) {
        let defaults = UserDefaults.standard
        defaults.set(countLM, forKey: CountLM)
        defaults.synchronize()
    }
    
    class func getCountLM() -> [Int] {
        let defaults = UserDefaults.standard
        let array = defaults.array(forKey: CountLM)  as? [Int] ?? [Int]()
        return array
    }
 
    class func setCountRM(countLM: [Int]) {
        let defaults = UserDefaults.standard
        defaults.set(countLM, forKey: CountRM)
        defaults.synchronize()
    }
    
    class func getCountRM() -> [Int] {
        let defaults = UserDefaults.standard
        let array = defaults.array(forKey: CountRM)  as? [Int] ?? [Int]()
        return array
    }
    
}


