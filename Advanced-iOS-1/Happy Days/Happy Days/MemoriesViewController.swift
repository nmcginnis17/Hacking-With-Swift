//
//  MemoriesViewController.swift
//  Happy Days
//
//  Created by Nicholas McGinnis on 6/13/23.
//

import AVFoundation
import CoreSpotlight
import MobileCoreServices
import Photos
import Speech
import UIKit

class MemoriesViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, AVAudioRecorderDelegate {
    
    var memories = [URL]()
    var activeMemory: URL!
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL!
    var audioPlayer: AVAudioPlayer?
    var filteredMemories = [URL]()
    var searchQuery: CSSearchQuery?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMemories()
        recordingURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkPermissions()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return filteredMemories.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Memory", for: indexPath) as! MemoryCell
        
        let memory = filteredMemories[indexPath.row]
        let imageName = thumbnailURL(for: memory).path
        let image = UIImage(contentsOfFile: imageName)
        cell.imageView.image = image
        
        if cell.gestureRecognizers == nil {
            let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(memoryLongPress))
            recognizer.minimumPressDuration = 0.25
            cell.addGestureRecognizer(recognizer)
            
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 3
            cell.layer.cornerRadius = 10
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memory = filteredMemories[indexPath.row]
        let fm = FileManager.default
        
        do {
            let audioName = audioURL(for: memory)
            let transcriptionName = transcriptionURL(for: memory)
            
            if fm.fileExists(atPath: audioName.path) {
                audioPlayer = try AVAudioPlayer(contentsOf: audioName)
                audioPlayer?.play()
            }
            
            if fm.fileExists(atPath: transcriptionName.path) {
                let contents = try String(contentsOf: transcriptionName)
                print(contents)
            }
        } catch {
            let ac = UIAlertController(title: "Error", message: "Could not load audio", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            print("Error loading audio")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize.zero
        } else {
            return CGSize(width: 0, height: 50)
        }
    }

    
    func checkPermissions() {
        let photosAuthorized = PHPhotoLibrary.authorizationStatus() == .authorized
        let recordingAuthorized = AVAudioSession.sharedInstance().recordPermission == .granted
        let transcribeAutorized = SFSpeechRecognizer.authorizationStatus() == .authorized
        
        let authorized = photosAuthorized && recordingAuthorized && transcribeAutorized
        
        if authorized == false {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FirstRun") {
                navigationController?.present(vc, animated: true)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func loadMemories() {
        memories.removeAll()
        
        // attempt to load all memories in our documents directory
        guard let files = try? FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil, options: []) else { return }
        
        // loop over every file found
        for file in files {
            let filename = file.lastPathComponent
            
            // check it ends with ".thumb" to avoid duplicates
            if filename.hasSuffix(".thumb") {
                
                // get root name
                let noExtension = filename.replacingOccurrences(of: ".thumb", with: "")
                
                // create full path from the memory
                let memoryPath = getDocumentsDirectory().appendingPathComponent(noExtension)
                
                // add to array
                memories.append(memoryPath)
            }
        }
        filteredMemories = memories
        // reload our memories list
        collectionView?.reloadSections(IndexSet(integer: 1))
    }
    
    @objc func addTapped() {
        let vc = UIImagePickerController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
    @objc func memoryLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let cell = sender.view as! MemoryCell
            
            if let index = collectionView?.indexPath(for: cell) {
                activeMemory = filteredMemories[index.row]
                recordMemory()
            }
        } else {
            finishRecording(success: true)
        }
    }
    
    func recordMemory() {
        audioPlayer?.stop()
        // set background color to red so user knows their microphone is recording
        collectionView?.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1)
        
        let recordingSession = AVAudioSession.sharedInstance()

        do {
            // configure session for recording and playback through speaker
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
            
            // set up recording session using high-quality AAC recording
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            // create AVAudioRecorded instance pointing at recordingURL
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            let ac = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            print("Failed to record: \(error.localizedDescription)")
            finishRecording(success: false)
        }
        
        // set MemoriesViewController as recording delegate, so we know when its stopped
    }
    
    func finishRecording(success: Bool) {
        // set background color back to normal
        collectionView?.backgroundColor = UIColor.darkGray
        
        // stop recording if not already stopped
        audioRecorder?.stop()
        
        if success {
            do {
                // if successful, create file URL out of active memory URL plus "m4a"
                let memoryAudioURL = activeMemory.appendingPathExtension("m4a")
                let fm = FileManager.default
                
                // if recording already exists, need to delete because can't move file over one that already exists
                if fm.fileExists(atPath: memoryAudioURL.path) {
                    try fm.removeItem(at: memoryAudioURL)
                }
                
                // Move our recorded file(stored at the URL put in recordingURL) into memory's audio URL
                try fm.moveItem(at: recordingURL, to: memoryAudioURL)
                
                // Start transcription
                transcribeAudio(memory: activeMemory)
            } catch let error {
                let ac = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                print("Failure finishing recording: \(error)")
            }
        }
    }
    
    func transcribeAudio(memory: URL) {
        // get paths to where the audio is, where the transcription should be
        let audio = audioURL(for: memory)
        let transcription = transcriptionURL(for: memory)
        
        // create new recognizer and point it at our audio
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: audio)
        
        // start recognition
        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                let ac = UIAlertController(title: "Error", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                print("There was an error: \(String(describing: error))")
                return
            }
            
            // if we got final transcription back, write to disk
            if result.isFinal {
                // pull out best transcription
                let text = result.bestTranscription.formattedString
                
                // write it to disk at the correct filename for this memory
                do {
                    try text.write(to: transcription, atomically: true, encoding: String.Encoding.utf8)
                    self.indexMemory(memory: memory, text: text)
                } catch {
                    let ac = UIAlertController(title: "Error", message: "Failed to save transcription", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                    print("Failed to save transcription")
                }
            }
        }
    }
    
    func indexMemory(memory: URL, text: String) {
        // create basic attribute set
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = "Happy Days Memory"
        attributeSet.contentDescription = text
        attributeSet.thumbnailURL = thumbnailURL(for: memory)
        
        // wrap it in a searchable item, using memory's full path as its unique identifier
        let item = CSSearchableItem(uniqueIdentifier: memory.path, domainIdentifier: "com.sinnigmedia", attributeSet: attributeSet)
        
        // make it never expire
        item.expirationDate = Date.distantFuture
        
        // ask spotlight to index the item
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed: \(text)")
            }
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMemories(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func filteredMemories(text: String) {
        guard text.count > 0 else {
            filteredMemories = memories
            
            UIView.performWithoutAnimation {
                collectionView?.reloadSections(IndexSet(integer: 1))
            }
            
            return
        }
        
        var allItems = [CSSearchableItem]()
        searchQuery?.cancel()
        
        let queryString = "contentDescription == \"*\(text)*\"c"
        searchQuery = CSSearchQuery(queryString: queryString, attributes: nil)
        
        searchQuery?.foundItemsHandler = { items in
            allItems.append(contentsOf: items)
        }
        
        searchQuery?.completionHandler = { error in
            DispatchQueue.main.async { [unowned self] in
                self.activateFilter(matches: allItems)
            }
        }
        
        searchQuery?.start()
    }
    
    func activateFilter(matches: [CSSearchableItem]) {
        filteredMemories = matches.map { item in
            return URL(fileURLWithPath: item.uniqueIdentifier)
        }
        
        UIView.performWithoutAnimation {
            collectionView?.reloadSections(IndexSet(integer: 1))
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        if let possibleImage = info[.originalImage] as? UIImage {
            saveNewMemory(image: possibleImage)
            loadMemories()
        }
    }
    
    func saveNewMemory(image: UIImage) {
        // create a unique name for memory
        let memoryName = "memory-\(Date().timeIntervalSince1970)"
        
        // use unique name to create filename for full size & thumbnail
        let imageName = memoryName + ".jpg"
        let thumbnailName = memoryName + ".thumb"
        
        do {
            // create URL where we can write the JPEG to
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            
            // convert UIImageto a JPEG data object
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                // write data to URL we created
                try jpegData.write(to: imagePath, options: [.atomicWrite])
            }
            
            // create thumbnail
            if let thumbnail = resize(image: image, to: 200) {
                let imagePath = getDocumentsDirectory().appendingPathComponent(thumbnailName)
                if let jpegData = thumbnail.jpegData(compressionQuality: 0.8) {
                    try jpegData.write(to: imagePath, options: [.atomicWrite])
                }
            }
            
        } catch {
            print("Failed to save to disk")
        }
    }
    
    func imageURL(for memory: URL) -> URL {
        return memory.appendingPathExtension("jpg")
    }
    
    func thumbnailURL(for memory: URL) -> URL {
        return memory.appendingPathExtension("thumb")
    }
    
    func audioURL(for memory: URL) -> URL {
        return memory.appendingPathExtension("m4a")
    }
    
    func transcriptionURL(for memory: URL) -> URL {
        return memory.appendingPathExtension("txt")
    }
    
    func resize(image: UIImage, to width: CGFloat) -> UIImage? {
        // calculate how much to bring the width down to match target size
        let scale = width / image.size.width
        
        // bring height down by same amount to maintain aspect ratio
        let height = image.size.height * scale
        
        // create new image context we can draw into
        // change parameter 2 to true for transparent background
        // parameter 3 is scale factor - controls retina graphics
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        
        // draw original image into context
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // pull out resized version
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end context so UIKit can clean up
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
