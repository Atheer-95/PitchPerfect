//
//  RecordSoundsViewController.swift
//  PictPerfect
//
//  Created by Eth Os on 04/08/1442 AH.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLable.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
    }
    
    @IBAction func stopRecord(_ sender: Any) {
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
            recordingLable.text = "Tap to Record"
        
         audioRecorder.stop()
         let audioSession = AVAudioSession.sharedInstance()
         try! audioSession.setActive(false)
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag : Bool){
        if flag{
        performSegue(withIdentifier:"stopRecord", sender: audioRecorder.url)
        }else{
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "stopRecord"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

