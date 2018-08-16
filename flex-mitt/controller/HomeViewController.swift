//
//  HomeViewController.swift
//  flex-mitt
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Flex-Sports. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD
import AVFoundation
import Crashlytics


class HomeViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    // Round
    let roundNumber = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 15]
    let roundMinutes = [2, 3, 5]
    let roundBell = [10, 20, 30]
    let restTime = [15, 30, 60, 120, 180]
    
    let LongPeriod:Double = 1
    let ShortPeriod:Double = 0.25
    var rubberBellTimer = Timer()
    var rubberDelay = 1.6
    
    var fleshPeriod:Int = 0
    
    var timer = Timer()
    var seconds = 0
    
    var curRound: Int = 0
    var summaryLM = [0,0,0,0,0,0,0,0,0,0,0,0]
    var summaryRM = [0,0,0,0,0,0,0,0,0,0,0,0]
    let roundMax: Int = 12
    
    var rest = true
    var paused = false
    var started = false
    
    
    var boxBell: AVAudioPlayer?
    var rubberHammerBell: AVAudioPlayer?
    
    
    // Bluetouth
    let LeftServiceUUID = CBUUID(string: "0000FF20-0000-1000-8000-00805F9B34FB")
    let RightServiceUUID = CBUUID(string: "0000FF10-0000-1000-8000-00805F9B34FB")
    
    
    let STATE_CHARACTERISTIC_UUID_LEFT:CBUUID = CBUUID(string: "0000FF22-0000-1000-8000-00805F9B34FB")
    let STATE_CHARACTERISTIC_UUID_RIGHT:CBUUID  = CBUUID(string: "0000FF12-0000-1000-8000-00805F9B34FB")
    //let CLIENT_CHARACTERISTIC_CONFIG:CBUUID = CBUUID(string: "00002902-0000-1000-8000-00805F9B34FB")
    
    var manager:CBCentralManager? = nil
    var leftPeripheral:CBPeripheral? = nil
    var rightPeripheral:CBPeripheral? = nil

    var bluetoothAvailable = false
    let scanPeriod = 10
    var progressHub: MBProgressHUD? = nil
    var scanTimer = Timer()
    var scanSeconds = 10
    
    // portrait
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leftMittLabel: UILabel!
    @IBOutlet weak var rightMittLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    // landscape
    @IBOutlet weak var LandscapeView: UIView!
    @IBOutlet weak var roundLabel1: UILabel!
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var leftMittLabel1: UILabel!
    @IBOutlet weak var rightMittLabel1: UILabel!
    @IBOutlet weak var leftLabel1: UILabel!
    @IBOutlet weak var rightLabel1: UILabel!
    @IBOutlet weak var totalLabel1: UILabel!
    
    @IBOutlet weak var startButton1: UIButton!
    @IBOutlet weak var pauseButton1: UIButton!
    @IBOutlet weak var restButton1: UIButton!
    @IBOutlet weak var settingButton1: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !AppData.getSettingExist() {
            AppData.setDefault()
            AppData.setCountLM(countLM: summaryLM)
            AppData.setCountRM(countLM: summaryRM)
        }
        
        reset()
        initBell()
        initView()
        
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if manager != nil {
            if leftPeripheral != nil && rightPeripheral != nil {
                return
            }
            startBLEScan()
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.rotationScreen()
        })
    }
    

    func rotationScreen() {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            LandscapeView.isHidden = true
        } else {
            LandscapeView.isHidden = false
        }
        
    }

    func initView() {
        
        rotationScreen()
        updatePunchCount()
        
        roundLabel.text = "ROUND: \(curRound + 1)"
        roundLabel1.text = "ROUND: \(curRound + 1)"
        
        timeLabel.text = timeString(time: TimeInterval(seconds))
        timeLabel.isHidden = false
        timeLabel1.text = timeString(time: TimeInterval(seconds))
        timeLabel1.isHidden = false
        
        
        if (curRound > 0) {
            roundLabel.text = "SESSION IS OVER!"
            roundLabel1.text = "SESSION IS OVER!"
        }
        
    }
    
    func startRound() {
        started = true
        rest = false
        paused = false
        fleshPeriod = (Int)(LongPeriod / ShortPeriod)
        
        roundLabel.text = "ROUND: \(curRound + 1)"
        roundLabel1.text = "ROUND: \(curRound + 1)"
        seconds = roundMinutes[AppData.getRoundDuration()] * 60
        startTimer(interval: LongPeriod)
        playOneBoxingBell()
    }
    
    func updatePunchCount() {
        let countLM = getCountForRoundLM(round: curRound)
        let countRM = getCountForRoundRM(round: curRound)
        leftMittLabel.text = "\(countLM)"
        rightMittLabel.text = "\(countRM)"
        leftMittLabel1.text = "\(countLM)"
        rightMittLabel1.text = "\(countRM)"
        totalLabel.text = "Total: \(countLM + countRM)"
        totalLabel1.text = "Total: \(countLM + countRM)"
    }
    
    
    @IBAction func clickedStartButton(_ sender: Any) {
        if !bluetoothAvailable {
            showAlert(msg: "BLE Not Supported")
            return
        }
        
        startButton.setTitle("RUNNING", for: UIControlState.normal)
        startButton1.setTitle("RUNNING", for: UIControlState.normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startButton1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startButton.isEnabled = false
        startButton1.isEnabled = false
        roundLabel.isHidden = false
        roundLabel1.isHidden = false
        settingButton.isHidden = true
        settingButton1.isHidden = true
        
        
        reset()
        startRound()
    }

    @IBAction func clickedPauseButton(_ sender: Any) {
        
        if !started {
            return
        }
        
        
        if paused {
            pauseButton.setTitle("PAUSE", for: UIControlState.normal)
            pauseButton1.setTitle("PAUSE", for: UIControlState.normal)
            pauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            pauseButton1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            startTimer(interval: LongPeriod)
            paused = false
        } else {
            pauseButton.setTitle("RESUME", for: UIControlState.normal)
            pauseButton1.setTitle("RESUME", for: UIControlState.normal)
            pauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            pauseButton1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            timer.invalidate()
            paused = true
        }
    }

    @IBAction func clickedResetButton(_ sender: Any) {
        
        reset()
        
        startButton.isEnabled = true
        startButton1.isEnabled = true
        startButton.setTitle("START", for: UIControlState.normal)
        startButton1.setTitle("START", for: UIControlState.normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startButton1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        pauseButton.setTitle("PAUSE", for: UIControlState.normal)
        pauseButton1.setTitle("PAUSE", for: UIControlState.normal)
        pauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        pauseButton1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        settingButton.isHidden = false
        settingButton1.isHidden = false
        initView()
    }
    
    @IBAction func clickedRescanButton(_ sender: Any) {
        manager = CBCentralManager(delegate: self, queue: nil)
        startBLEScan()
    }
    
    func connectLeftMitt() {
        leftLabel.textColor = UIColorFromRGB(rgbValue: 0xFF4081)
        leftMittLabel.textColor = UIColorFromRGB(rgbValue: 0xFF4081)
        leftLabel1.textColor = UIColorFromRGB(rgbValue: 0xFF4081)
        leftMittLabel1.textColor = UIColorFromRGB(rgbValue: 0xFF4081)
    }
    
    func connectRightMitt() {
        rightLabel.textColor = UIColorFromRGB(rgbValue: 0x3F51B5)
        rightMittLabel.textColor = UIColorFromRGB(rgbValue: 0x3F51B5)
        rightLabel1.textColor = UIColorFromRGB(rgbValue: 0x3F51B5)
        rightMittLabel1.textColor = UIColorFromRGB(rgbValue: 0x3F51B5)
    }
    
    func disconnectLeftMitt() {
        leftLabel.textColor = UIColorFromRGB(rgbValue: 0x808080)
        leftMittLabel.textColor = UIColorFromRGB(rgbValue: 0x808080)
        leftLabel1.textColor = UIColorFromRGB(rgbValue: 0x808080)
        leftMittLabel1.textColor = UIColorFromRGB(rgbValue: 0x808080)
    }
    
    func disconnectRightMitt() {
        rightLabel.textColor = UIColorFromRGB(rgbValue: 0x808080)
        rightMittLabel.textColor = UIColorFromRGB(rgbValue: 0x808080)
        rightLabel1.textColor = UIColorFromRGB(rgbValue: 0x808080)
        rightMittLabel1.textColor = UIColorFromRGB(rgbValue: 0x808080)
    }
    
    
    // Bluetouth
    
    func startBLEScan() {
        progressHub = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHub?.label.text = "Scanning devices"
        scanSeconds = scanPeriod
        startScanTimer()
    }
    
    func stopBLEScan() {
        
        if self.manager != nil {
            self.manager?.stopScan()
        }
        
        scanTimer.invalidate()
        if progressHub != nil {
            progressHub?.hide(animated: true)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        print("Checking bluetouth state")
        

        switch (central.state)
        {
        case .poweredOff:
            print("CoreBluetooth BLE hardware is powered off")
            
        case .poweredOn:
            print("CoreBluetooth BLE hardware is powered on and ready")
            bluetoothAvailable = true
            
        case .resetting:
            print("CoreBluetooth BLE hardware is resetting")
            
        case .unauthorized:
            print("CoreBluetooth BLE state is unauthorized")
            
        case .unknown:
            print("CoreBluetooth BLE state is unknown")
            
        case .unsupported:
            print("CoreBluetooth BLE hardware is unsupported on this platform")
            
        }
        
        if bluetoothAvailable == true {
            print("Discovering devices")
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            stopBLEScan()
        }
    }



    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
        let serviceUUIDs = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataServiceUUIDsKey)
            as? NSArray
        
        if serviceUUIDs != nil {
            for item in serviceUUIDs! {
                if item as! CBUUID == LeftServiceUUID {
                    print("discovered the left device!")
                    leftPeripheral = peripheral
                    leftPeripheral?.delegate = self
                    manager?.connect(leftPeripheral!, options: nil)
                    
                } else if (item as! CBUUID == RightServiceUUID) {
                    print("discovered the right device!")
                    rightPeripheral = peripheral
                    rightPeripheral?.delegate = self
                    manager?.connect(rightPeripheral!, options: nil)
                }
                
            }
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        print("connected to peripheral")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
            if manager != nil {
                if (peripheral == leftPeripheral) {
                    disconnectLeftMitt()
                    //manager?.cancelPeripheralConnection(leftPeripheral!)
                } else if (peripheral == rightPeripheral) {
                    disconnectRightMitt()
                    //manager?.cancelPeripheralConnection(rightPeripheral!)
                }
            }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed connection to Peripheral")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            let thisService = service as CBService
            print("Discovered service : \(service.uuid)")
            
            if service.uuid == LeftServiceUUID {
                leftPeripheral?.discoverCharacteristics(nil, for: thisService)
            } else if (service.uuid == RightServiceUUID) {
                rightPeripheral?.discoverCharacteristics(nil, for: thisService)
            }
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            print("\(thisCharacteristic)")
            if thisCharacteristic.uuid == STATE_CHARACTERISTIC_UUID_LEFT {
                leftPeripheral?.setNotifyValue(true, for: thisCharacteristic)
                connectLeftMitt()
                
            } else if (thisCharacteristic.uuid == STATE_CHARACTERISTIC_UUID_RIGHT) {
                rightPeripheral?.setNotifyValue(true, for: thisCharacteristic)
                connectRightMitt()
            }
        }
    }
    

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("error:  (error)")
        }
        else {
            if peripheral == leftPeripheral {
                addCountForCurRoundLeft()
            } else if (peripheral == rightPeripheral) {
                addCountForCurRoundRight()
            }
        }
    }
    
    func addCountForCurRoundLeft() {
        if paused {
            return
        }
        
        if !rest {
            summaryLM[curRound] += 1
            AppData.setCountLM(countLM: summaryLM)
            updatePunchCount()
        }
    }
    
    func  addCountForCurRoundRight() {
        if paused {
            return
        }
        
        if !rest {
            summaryRM[curRound] += 1
            AppData.setCountRM(countLM: summaryRM)
            updatePunchCount()
        }
    }
    
    
    func startScanTimer() {
        scanTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(HomeViewController.updateScanTimer), userInfo: nil, repeats: true)
    }
    
    func updateScanTimer() {
        scanSeconds -= 1
        if scanSeconds < 0 {
            stopBLEScan()
        }
    }
    
    
    
    // Timer
    
    func startTimer(interval: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self,   selector: #selector(HomeViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
 
    func updateTimer() {
        
        if (!rest || fleshPeriod == (Int)(LongPeriod / ShortPeriod)) {
            fleshPeriod = 0
            seconds -= 1
        }
        
        if (seconds < 0) {
            
            timer.invalidate()
            let totalRounds = roundNumber[AppData.getRoundCount()]
            
            if (rest) {
                if (curRound < totalRounds - 1) {
                    curRound += 1
                    startRound()
                }
            } else {
                fleshPeriod = (Int)(LongPeriod / ShortPeriod)
                rest = true
                
                if (curRound < totalRounds - 1) {
                    playOneBoxingBell()
                    seconds = restTime[AppData.getRestDuration()]
                    startTimer(interval: ShortPeriod)
                } else {
                    playTwoBoxingBell()
                    sessionEnd()
                    started = false
                    seconds = 0
                }
            }
        } else {
            if (rest) {
                
                fleshPeriod += 1
                if (timeLabel.isHidden == true) {
                    timeLabel.isHidden = false
                    timeLabel1.isHidden = false
                } else {
                    timeLabel.isHidden = true
                    timeLabel1.isHidden = true
                }
                
            } else if (seconds == roundBell[AppData.getWarnDelay()]) {
                playWarnBell()
            }
            
            timeLabel.text = timeString(time: TimeInterval(seconds))
            timeLabel1.text = timeString(time: TimeInterval(seconds))
        }

    }
    
    func timeString(time: TimeInterval) -> String {
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    
    
    // Round
    func reset() {
        
        timer.invalidate()
        seconds = 0
        curRound = 0
        
        for index in 0...11 {
            summaryLM[index] = 0
            summaryRM[index] = 0
        }
        
        AppData.setCountLM(countLM: summaryLM)
        AppData.setCountRM(countLM: summaryRM)
        
        rest = true
        started = false
    }
    
    func sessionEnd() {
        startButton.isEnabled = true
        startButton1.isEnabled = true
        startButton.setTitle("START", for: UIControlState.normal)
        startButton1.setTitle("START", for: UIControlState.normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startButton1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        pauseButton.setTitle("PAUSE", for: UIControlState.normal)
        pauseButton1.setTitle("PAUSE", for: UIControlState.normal)
        pauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        pauseButton1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        settingButton.isHidden = false
        settingButton1.isHidden = false
        roundLabel.text = "SESSION IS OVER!"
        roundLabel1.text = "SESSION IS OVER!"
    }

    
    func getCountForRoundLM(round: Int) -> Int {
        return round >= roundNumber[AppData.getRoundCount()] ? 0 : summaryLM[round]
    }
    
    func getCountForRoundRM(round: Int) -> Int {
        return round >= roundNumber[AppData.getRoundCount()] ? 0 : summaryRM[round]
    }
    
    
    func getTotalCountLM() -> Int {
        
        var res: Int = 0;
        
        for index in 0...11 {
            res += summaryLM[index]
        }
        return res;
    }
    
    func getTotalCountRM() -> Int {
        
        var res: Int = 0
        
        for index in 0...11 {
            res += summaryRM[index]
        }
        return res;
    }

    // Bell
    func initBell() {
        let url = Bundle.main.url(forResource: "boxingbell", withExtension: "wav")!
        
        do {
            boxBell = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let url1 = Bundle.main.url(forResource: "rubberbell", withExtension: "wav")!
        
        do {
            rubberHammerBell = try AVAudioPlayer(contentsOf: url1)
        } catch let error {
            print(error.localizedDescription)
        }

        
    }
    
    func playBoxBell() {
        
        let url = Bundle.main.url(forResource: "boxingbell", withExtension: "wav")!
        
        do {
            boxBell = try AVAudioPlayer(contentsOf: url)
            guard let boxBell = boxBell else { return }
            boxBell.prepareToPlay()
            boxBell.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playOneBoxingBell() {
        guard let boxBell = boxBell else { return }
        boxBell.currentTime = 1.55
        boxBell.prepareToPlay()
        boxBell.play()
    }
    
    func playTwoBoxingBell() {
        guard let boxBell = boxBell else { return }
        boxBell.currentTime = 1.39
        boxBell.prepareToPlay()
        boxBell.play()
    }
    
    
    
    func playWarnBell() {
        guard let rubberHammerBell = rubberHammerBell else { return }
        rubberHammerBell.currentTime = 0.1
        rubberHammerBell.prepareToPlay()
        rubberHammerBell.play()
        startRubberHammerBellTimer()
    }
    
    func startRubberHammerBellTimer() {
        rubberBellTimer = Timer.scheduledTimer(timeInterval: 1.6, target: self,   selector: #selector(HomeViewController.stopRubberBell), userInfo: nil, repeats: false)
    }
    
    func stopRubberBell() {
        guard let rubberHammerBell = rubberHammerBell else { return }
        rubberHammerBell.stop()
        
    }
    

    // Utils
    
    func showAlert(msg: NSString) {
        let alertController = UIAlertController(title: "Confirm", message: msg as String, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
}
