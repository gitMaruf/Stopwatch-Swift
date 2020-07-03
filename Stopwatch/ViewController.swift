//
//  ViewController.swift
//  Stopwatch
//
//  Created by Maruf Howlader on 7/2/20.
//  Copyright © 2020 Creative Young. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    // MARK: - Variables
    var lap: [String] = []
    var isPlay: Bool = false
    var mainStopwatch: Stopwatch = Stopwatch()
    var lapStopwatch: Stopwatch = Stopwatch()
    
    // MARK: - UI components
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapTimerLabel: UILabel!
    @IBOutlet weak var playPushButton: UIButton!
    @IBOutlet weak var lapResetButton: UIButton!
    @IBOutlet weak var lapTableView: UITableView!
    
    let initCircleButton: (UIButton) -> Void = { button in
        button.layer.cornerRadius = 0.5 * button.bounds.size.height   
        button.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lapTableView.delegate = self
        lapTableView.dataSource = self
        lapTableView.rowHeight = 44
        lapResetButton.isEnabled = false
        initCircleButton(playPushButton)
        initCircleButton(lapResetButton)
    }
    
    @IBAction func playPushButtonPressed(_ sender: Any) {
        lapResetButton.isEnabled = true
        if !isPlay{
            unowned let weakSelf = self
                  mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.mainTimer, userInfo: nil, repeats: true)
            RunLoop.current.add(mainStopwatch.timer, forMode: .common)
                  
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.lapTimer, userInfo: nil, repeats: true)
            RunLoop.current.add(lapStopwatch.timer, forMode: .common)
            isPlay = true
            changeButton(playPushButton, title: "Stop", color: UIColor.red)
            changeButton(lapResetButton, title: "Lap", color: UIColor.black)
        }else{
            isPlay = false
            changeButton(playPushButton, title: "Start", color: UIColor.green)
            changeButton(lapResetButton, title: "Reset", color: UIColor.red)
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
        }
    }
    
    @IBAction func lapRestButtonPressed(_ sender: Any) {
        if isPlay{
            if let currentTimerValue = timerLabel.text{
                lap.append(currentTimerValue)
            }
            resetLapTimer()
            
            unowned let weakSelf = self
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.lapTimer, userInfo: nil, repeats: true)
            RunLoop.current.add(lapStopwatch.timer, forMode: .common)
            lapTableView.reloadData()
            
        }else{
            changeButton(playPushButton, title: "Start", color: UIColor.green)
            changeButton(lapResetButton, title: "lap", color: UIColor.gray)
            lapResetButton.isEnabled = false
            resetMainTimer()
            resetLapTimer()
            
            lap.removeAll()
            lapTableView.reloadData()
        }
    }
    func resetMainTimer(){
        resetTimer(mainStopwatch, label: timerLabel)
    }
    func resetLapTimer(){
        resetTimer(lapStopwatch, label: lapTimerLabel)
    }
    func resetTimer(_ stopwatch: Stopwatch, label: UILabel){
        stopwatch.timer.invalidate()
        stopwatch.counter = 0
        label.text = "00:00:00"
    }
    @objc func updateMainTimer(){
        updateTimer(mainStopwatch, label: timerLabel)
    }
    @objc func updateLapTimer(){
        updateTimer(lapStopwatch, label: lapTimerLabel)
    }
    func updateTimer(_ stopwatch: Stopwatch, label: UILabel){
        
            stopwatch.counter = stopwatch.counter + 0.035
            var minutes = String((Int)(stopwatch.counter / 60))
            if (Int)(stopwatch.counter / 60) < 10{
                minutes = "0\(minutes)"
            }
            var second = String(format: "%.2f", stopwatch.counter.truncatingRemainder(dividingBy: 60))
            if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
                second = "0" + second
            }
            label.text = minutes + ":" + second
            //print(minutes + ":" + second)
            
        
    }
    
    
    }

    //MARK: -Private Function
fileprivate func changeButton(_ button: UIButton, title: String, color: UIColor){
    button.setTitle(title, for: .normal)
    button.setTitleColor(color, for: .normal)
}

    extension Selector {
        static let mainTimer = #selector(ViewController.updateMainTimer)
        static let lapTimer = #selector(ViewController.updateLapTimer)
    }
    
    
    
extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lap.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        let labelForLap = cell.viewWithTag(11) as? UILabel
        
        let labelForTime = cell.viewWithTag(12) as? UILabel
        let noOfIndex = lap.count
        let currentRows = indexPath.row   // Start from ZERO (0)
        labelForLap?.text = String("Lap \(noOfIndex - currentRows)")
        labelForTime?.text = lap[noOfIndex - currentRows - 1]
        //print(noOfIndex, currentRows)
        return cell
       }
}
