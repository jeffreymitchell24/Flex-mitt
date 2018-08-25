//
//  SettingViewController.swift
//  flex-mitt
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Flex-Sports. All rights reserved.
//

import UIKit
import DropDown

class SettingViewController: UIViewController {
    
    @IBOutlet weak var roundNumberLabel: UILabel!
    @IBOutlet weak var roundNumberButton: UIButton!
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var minuteButton: UIButton!
    
    @IBOutlet weak var bellLabel: UILabel!
    @IBOutlet weak var bellButton: UIButton!
    
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var restButton: UIButton!
    
    let RoundNumberDropDown = DropDown()
    let RoundMinuteDropDown = DropDown()
    let RoundBellDropDown = DropDown()
    let RoundRestDropDown = DropDown()
    
    let roundNumber = ["1", "2", "3", "4","5", "6", "7", "8","10", "12", "15"]
    let roundMinutes = ["2", "3", "5"]
    let roundBell = ["10", "20", "30"]
    let restTime = ["15 sec", "30 sec", "1 min", "2 min", "3 min"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem?.title = ""
        roundNumberLabel.text = roundNumber[AppData.getRoundCount()]
        minuteLabel.text = roundMinutes[AppData.getRoundDuration()]
        bellLabel.text = roundBell[AppData.getWarnDelay()]
        restLabel.text = restTime[AppData.getRestDuration()]
        
        setupDropList()
    }
    
    func setupDropList() {
        RoundNumberDropDown.anchorView = roundNumberButton
        RoundNumberDropDown.bottomOffset = CGPoint(x: 0, y: roundNumberButton.bounds.height)
        RoundNumberDropDown.dataSource = roundNumber
        DropDown.appearance().textColor = UIColor(rgbValue: 0xff8c46)
        DropDown.appearance().textFont = .boldSystemFont(ofSize: 17)
        RoundNumberDropDown.selectionAction = { [unowned self] (index, item) in
            self.roundNumberLabel.text = item
            AppData.setRoundCount(count: index)
        }
        
        RoundMinuteDropDown.anchorView = minuteButton
        RoundMinuteDropDown.bottomOffset = CGPoint(x: 0, y: minuteButton.bounds.height)
        RoundMinuteDropDown.dataSource = roundMinutes
        RoundMinuteDropDown.selectionAction = { [unowned self] (index, item) in
            self.minuteLabel.text = item
            AppData.setRoundDuration(count: index)
        }
        
        RoundBellDropDown.anchorView = bellButton
        RoundBellDropDown.bottomOffset = CGPoint(x: 0, y: bellButton.bounds.height)
        RoundBellDropDown.dataSource = roundBell
        RoundBellDropDown.selectionAction = { [unowned self] (index, item) in
            self.bellLabel.text = item
            AppData.setWarnDelay(count: index)
        }
        
        RoundRestDropDown.anchorView = restButton
        RoundRestDropDown.bottomOffset = CGPoint(x: 0, y: restButton.bounds.height)
        RoundRestDropDown.dataSource = restTime
        RoundRestDropDown.selectionAction = { [unowned self] (index, item) in
            self.restLabel.text = item
            AppData.setRestDuration(count: index)
        }
    }
    
    @IBAction func clickedRoundNumberButton(_ sender: Any) {
        RoundNumberDropDown.show()
    }
    
    @IBAction func clickedMinuteButton(_ sender: Any) {
        RoundMinuteDropDown.show()
    }
    
    @IBAction func clickedBellButton(_ sender: Any) {
        RoundBellDropDown.show()
    }
    
    @IBAction func clickedRestButton(_ sender: Any) {
        RoundRestDropDown.show()
    }
}
