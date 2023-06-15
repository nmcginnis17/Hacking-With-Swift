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

class MemoriesViewController: UICollectionViewController {
    
    var memories = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermissions()
        loadMemories()
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

}
