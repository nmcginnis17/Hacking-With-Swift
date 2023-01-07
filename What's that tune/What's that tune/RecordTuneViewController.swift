//
//  RecordTuneViewController.swift
//  What's that tune
//
//  Created by Nicholas McGinnis on 1/5/23.
//

import AVFoundation
import UIKit

class RecordTuneViewController: UIViewController, AVAudioRecorderDelegate {
    
    var stackView: UIStackView!
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var tuneRecorder: AVAudioRecorder!
    var playButton: UIButton!
    var tunePlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Record your tune"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }
    }
    
    func loadRecordingUI() {
        recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        stackView.addArrangedSubview(recordButton)
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Tap to Play", for: .normal)
        playButton.isHidden = true
        playButton.alpha = 0
        playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        stackView.addArrangedSubview(playButton)
    }
    
    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        failLabel.text = "Recording failed: please ensure the app has access to your microphone."
        failLabel.numberOfLines = 0
        stackView.addArrangedSubview(failLabel)
    }
    
    override func loadView() {
        view = UIView()
        
        view.backgroundColor = UIColor.gray
        
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getTuneURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("tune.m4a")
    }
    
    func startRecording() {
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        
        recordButton.setTitle("Tap to Stop", for: .normal)
        
        let audioURL = RecordTuneViewController.getTuneURL()
        print(audioURL.absoluteString)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            tuneRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            tuneRecorder.delegate = self
            tuneRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        tuneRecorder.stop()
        tuneRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            
            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your tune. Please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        if playButton.isHidden {
            UIView.animate(withDuration: 0.35) { [weak self] in
                self?.playButton.isHidden = false
                self?.playButton.alpha = 1
            }
        }
    }

    @objc func nextTapped() {
        let vc = SelectGenreViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func recordTapped() {
        if tuneRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
        
        if !playButton.isHidden {
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.playButton.isHidden = true
                self.playButton.alpha = 0
            }
        }
    }
    
    @objc func playTapped() {
        let audioURL = RecordTuneViewController.getTuneURL()
        
        do {
            tunePlayer = try AVAudioPlayer(contentsOf: audioURL)
            tunePlayer.play()
        } catch {
            let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your tune. Please try re-recording.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
