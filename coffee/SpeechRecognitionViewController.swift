//
//  SpeechRecognitionViewController.swift
//  coffee
//
//  Created by admin on 11/1/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class SpeechRecognitionViewController: UIViewController {
    

    @IBOutlet weak var xBoxDisplay: UIImageView!
    @IBOutlet weak var checkmarkDisplay: UIImageView!
    @IBOutlet weak var transcriptionText: UITextView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var keyword: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        checkmarkDisplay.isHidden = true
        xBoxDisplay.isHidden = true
        transcriptionText.isHidden = true
        
    }

    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                do {
                    try self.startRecording()
                } catch let error {
                    print("there was a problem starting recording: \(error.localizedDescription)")
                }
                break
            case .denied:
                print("Speech recording has been denied")
                break
            case .restricted:
                print("Speech recognition is not available on this device")
                break
            case .notDetermined:
                print("Not Determined")
                break
            }
            }
            
            
        }
    

    
   fileprivate func startRecording() throws {
        
        guard let node = audioEngine.inputNode else {
            print("Couldn't get an input node")
            return
        }
        let recordingFormat = node.outputFormat(forBus: 0)

        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [unowned self] (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    
    
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [unowned self] (result, _) in
            if let transcription = result?.bestTranscription.formattedString {
                self.transcriptionText.text = transcription
                self.keyword = transcription
            }
        })
        
    }
    
    func stopRecording() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
        print("JETT: Recording Stopped!")
    }
    
    func cancelRecording() {
        audioEngine.stop()
        recognitionTask?.cancel()
    }
   
    @IBAction func recordingButtonTapped(_ sender: AnyObject) {
        activitySpinner.isHidden = false
        checkmarkDisplay.isHidden = false
        xBoxDisplay.isHidden = false
        transcriptionText.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuthorization()
        
    }

    
    
    @IBAction func checkmarkTapped(_ sender: AnyObject) {
        stopRecording()
        performSegue(withIdentifier: "goToMap", sender: transcriptionText.text)
    }
    
    @IBAction func xBoxTapped(_ sender: AnyObject) {
        transcriptionText.text = ""
        stopRecording()
        guard let node = audioEngine.inputNode else {
            print("Couldn't get an input node")
            return
        }
        node.removeTap(onBus: 0)
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            if let restaurantData = sender as? String {
                destination.restaurantData = restaurantData
            }
        }
    }
    
    
}
