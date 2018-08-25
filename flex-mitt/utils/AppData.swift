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
    
    private static let defaults = UserDefaults.standard
    
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
        defaults.set(firstSetting, forKey: FirstSetting)
        defaults.synchronize()
    }
    
    class func getFirstSetting() -> Bool {
        return defaults.bool(forKey: FirstSetting)
    }
    
    class func setSettingExist(isExist:Bool) {
        defaults.set(isExist, forKey: SettingExist)
        defaults.synchronize()
    }
    
    class func getSettingExist() -> Bool {
        return defaults.bool(forKey: SettingExist)
    }
    
    class func setRoundCount(count:Int) {
        defaults.set(count, forKey: RoundCount)
        defaults.synchronize()
    }
    
    class func getRoundCount() -> Int {
        return defaults.integer(forKey: RoundCount)
    }
    
    class func setRoundDuration(count:Int) {
        defaults.set(count, forKey: RoundDuration)
        defaults.synchronize()
    }
    
    class func getRoundDuration() -> Int {
        return defaults.integer(forKey: RoundDuration)
    }
    
    class func setWarnDelay(count:Int) {
        defaults.set(count, forKey: WarnDelay)
        defaults.synchronize()
    }
    
    class func getWarnDelay() -> Int {
        return defaults.integer(forKey: WarnDelay)
    }
    
    
    class func setRestDuration(count:Int) {
        defaults.set(count, forKey: RestDuration)
        defaults.synchronize()
    }
    
    class func getRestDuration() -> Int {
        return defaults.integer(forKey: RestDuration)
    }
    
    class func setCountLM(countLM: [Int]) {
        defaults.set(countLM, forKey: CountLM)
        defaults.synchronize()
    }
    
    class func getCountLM() -> [Int] {
        return defaults.array(forKey: CountLM) as? [Int] ?? []
    }
    
    class func setCountRM(countLM: [Int]) {
        defaults.set(countLM, forKey: CountRM)
        defaults.synchronize()
    }
    
    class func getCountRM() -> [Int] {
        return defaults.array(forKey: CountRM) as? [Int] ?? []
    }
}
