//
//  SummaryViewController.swift
//  flex-mitt
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Flex-Sports. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var labelTotalLM: UILabel!
    @IBOutlet weak var labelTotalRM: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    
    var totalLM = 0
    var totalRM = 0
    var total = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    var summaryLM = [0,0,0,0,0,0,0,0,0,0,0,0]
    var summaryRM = [0,0,0,0,0,0,0,0,0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryLM = AppData.getCountLM()
        summaryRM = AppData.getCountRM()
        
        let cellNib = UINib(nibName: "SummaryCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SummaryCell")
        
        updateTotal()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.getRoundCount() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
        
        cell.roundName.text = "Round# \(indexPath.row + 1)"
        cell.label1.text = "\(summaryLM[indexPath.row])"
        cell.label2.text = "\(summaryRM[indexPath.row])"
        cell.label3.text = "\(summaryLM[indexPath.row] + summaryRM[indexPath.row])"
        
        return cell
    }
    
    func updateTotal() {
        for index in 0...11 {
            totalLM += summaryLM[index]
            totalRM += summaryRM[index]
        }
        total = totalLM + totalRM
        
        labelTotalLM.text = ("\(totalLM)")
        labelTotalRM.text = ("\(totalRM)")
        labelTotal.text = ("\(total)")
        
    }
}
