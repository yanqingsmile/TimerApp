//
//  ViewController.swift
//  TimerApp
//
//  Created by Vivian Liu on 11/17/19.
//  Copyright © 2019 Vivian Liu. All rights reserved.
//

import UIKit

enum TimerState {
    case canceled, active, paused
}

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var StartResumeButton: UIButton!
    @IBOutlet weak var timePickerView: UIPickerView!
    
    /// Properties for pickerView
    private let timeSource = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9 , 10],
                              [0, 1, 2, 3, 4, 5, 6, 7, 8, 9 , 10],
                              [0, 1, 2, 3, 4, 5, 6, 7, 8, 9 , 10]]
    private var selectedTime = [0, 0, 0]
    
    /// Properties for timer
    private var timer: Timer?
    private var timeLeft: Double?
    private var timerState: TimerState = .canceled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.dataSource = self
        timePickerView.delegate = self
        setupUI()
    }
    
    @IBAction func StartResumeButtonTapped(_ sender: Any) {
        if timerState == .canceled {
            startTimer()
        } else if timerState == .active {
            pauseTimer()
        } else if timerState == .paused {
            resumeTimer()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancelTimer()
    }
    
    private func setupUI() {
        StartResumeButton.setTitle("Start", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        timeLabel.text = "00 : 00 : 00"
    }
    
    private func startTimer() {
        let timeSet = getSetTime()
        if timeSet <= 0.0 { return }
        timeLeft = timeSet
        runTimer()
        timerState = .active
        StartResumeButton.setTitle("Pause", for: .normal)
    }
    
    private func resumeTimer() {
        runTimer()
        timerState = .active
        StartResumeButton.setTitle("Pause", for: .normal)
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.updateTime()
        })
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        timerState = .paused
        StartResumeButton.setTitle("Resume", for: .normal)
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timerState = .canceled
        timeLeft = nil
        setupUI()
    }
    
    private func updateTime() {
        timeLeft = (timeLeft ?? 0.0) - 1.0
        timeLabel.text = getFormattedStringFromTimeInterval(timeLeft!)
        if timeLeft! < 0.0 {
            cancelTimer()
            presentAlert()
        }
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Time Out!", message: nil, preferredStyle: .alert)
        let stopAction = UIAlertAction(title: "Stop", style: .cancel, handler: nil)
        alertVC.addAction(stopAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func getSetTime() -> Double {
        let seconds = selectedTime[0] * 60 * 60 + selectedTime[1] * 60 + selectedTime[2]
        return Double(seconds)
    }
    
    private func getFormattedStringFromTimeInterval(_ timeInterval: Double) -> String {
        let time = Int(timeInterval)
        let sec = time % 60
        let min = (time / 60) % 60
        let hour = time / 3600
        return String(format: "%02d : %02d : %02d", hour, min, sec)
    }
}


extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeSource[component].count
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let suffix = ["hours", "min", "sec"]
        let title = String(timeSource[component][row]) + " " + suffix[component]
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime[component] = timeSource[component][row]
    }
}

