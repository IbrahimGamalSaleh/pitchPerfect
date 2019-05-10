//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by IbrahimGamal on 5/21/1440 AH.
//  Copyright © 1440 AH IbrahimGamal. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
    

    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled=false
    }
   
    @IBAction func recordAudio(_ sender: Any) {
        configerUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    func configerUI(isRecording:Bool)
    {
        if isRecording
        {
            recordingLabel.text="Recording in Progress"
            recordingButton.isEnabled=false
            stopRecordingButton.isEnabled=true
        }
        else
        
        {
            recordingButton.isEnabled=true
            stopRecordingButton.isEnabled=false
            recordingLabel.text="Tap to Record"
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configerUI(isRecording: false)
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
      else
        {
            print("something wrong!")
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording"
        {
        let playSoundsVC=segue.destination as!PlaySoundsViewController
        
        let recordedAudioURL=sender as! URL
        playSoundsVC.recordedAudioURL=recordedAudioURL
        }
    }


}
