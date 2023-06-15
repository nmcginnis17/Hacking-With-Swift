//
//  MemoriesViewController.swift
//  Happy Days
//
//  Created by Nicholas McGinnis on 6/13/23.
//

import AVFoundation
import Photos
import Speech
import UIKit

class MemoriesViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var memories = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermissions()
        loadMemories()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
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
        // reload our memories list
        collectionView?.reloadSections(IndexSet(integer: 1))
    }
    
    @objc func addTapped() {
        let vc = UIImagePickerController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        navigationController?.present(vc, animated: true)
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
            
            // create thumbnail here
            
        } catch {
            print("Failed to save to disk")
        }
    }

}
