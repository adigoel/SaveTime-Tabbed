//
//  FirstViewController.swift
//  Save Time Tabbed
//
//  Created by Aditya Goel on 13/01/2017.
//  Copyright © 2017 Aditya Goel. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import MapKit
import CoreLocation
import UserNotifications

var floatTime = Float()
var lockUnlockArray = [Int]()

class FirstViewController: UIViewController {
    
    var playPauseInt: Bool = true
    
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeSpentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    lazy var player: AVQueuePlayer = self.makePlayer()
    
    private lazy var songs: [AVPlayerItem] = {
        let songNames = ["silentAudio", "silentAudio", "silentAudio"]
        return songNames.map {
            let url = Bundle.main.url(forResource: $0, withExtension: "mp3")!
            return AVPlayerItem(url: url)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        
        currentSystemTime = 0
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSessionCategoryPlayAndRecord,
                with: .defaultToSpeaker)
        } catch {
            dateLabel.text = "no work"
        }
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 100), queue: DispatchQueue.main) {
            [weak self] time in
            guard let strongSelf = self else { return }
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            
            floatTime = Float(CMTimeGetSeconds(time))
            print(floatTime)
            print(currentSystemTime)
            var intTime:Int = Int(floatTime)
            
            if UIApplication.shared.applicationState == .active {
                strongSelf.timeLabel.text = "\(currentSystemTime) -- \(timeString)"
                
            } else if UIApplication.shared.applicationState == .background {
                print("Background: \(timeString)")
                print(time)
                var isOtherAudioPlaying = AVAudioSession.sharedInstance().isOtherAudioPlaying
                if isOtherAudioPlaying {
                    print("Other Audio is Playing")
                    print("current system time: \(currentSystemTime)")
                    //some kind of gps transition is necessary
                }
                else {
                    print("No other Audio is Playing")
                }
                    
                }
        }

        
       // timeOnPhoneLabel.backgroundColor = UIColor(patternImage: UIImage(named: "orangeBackground.png")!)
       // let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        //if launchedBefore  {
          //  print("Not first launch.")
            //Flurry of nicely made labels to explain the app
        //} else {
          //  print("First launch, setting UserDefault.")
           // UserDefaults.standard.set(true, forKey: "launchedBefore")
        //}
        
        let date = Date()
        let userCalendar = Calendar.current
        
        let year = userCalendar.component(.year, from: date)
        let month = userCalendar.component(.month, from: date)
        let day = userCalendar.component(.day, from: date)
        
        var firstLandPhoneCallDateComponents = DateComponents()
        firstLandPhoneCallDateComponents.year = year
        firstLandPhoneCallDateComponents.month = month
        firstLandPhoneCallDateComponents.day = day
        let firstLandPhoneCallDate = userCalendar.date(from: firstLandPhoneCallDateComponents)!
        let myFormatter = DateFormatter()
        myFormatter.string(from: firstLandPhoneCallDate)
        myFormatter.dateStyle = .full
        let datePresent:String = myFormatter.string(from: firstLandPhoneCallDate)
        dateLabel.text = datePresent
        timeSpentLabel.text = "23 minutes today"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func makePlayer() -> AVQueuePlayer {
        let player = AVQueuePlayer(items: songs)
        player.actionAtItemEnd = .advance
        player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial] , context: nil)
        return player
}

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem", let player = object as? AVPlayer,
            let currentItem = player.currentItem?.asset as? AVURLAsset {
            songLabel.text = currentItem.url.lastPathComponent
        }
    }
    
    
    @IBAction func playPauseAction(_ sender: Any) {
        
        playPauseActionFunc()
            }
    
    func playPauseActionFunc () {
        if playPauseInt == true{
            playPauseInt = false
            var timer:Timer!
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FirstViewController.updateTimer), userInfo: nil, repeats: true)
            player.play()
            
        }
        else if playPauseInt == false {
            player.pause()
        }
    }

    
    func updateTimer() -> Int {
        currentSystemTime += 1
        return currentSystemTime
        
}
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


