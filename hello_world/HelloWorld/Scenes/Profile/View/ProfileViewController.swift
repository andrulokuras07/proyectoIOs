//
//  ProfileViewController.swift
//  HelloWorld
//
//  Created by Alumnos on 27/03/26.
//

import UIKit
import AVKit
import AVFoundation

class ProfileViewController: UIViewController {
    
    var player: AVPlayer? // Reproductor de música
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var searchImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helpButton = UIBarButtonItem(title: "Hello", style: .plain, target: self, action: #selector(didTapHelp))
        
        let audioButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didTapAudio))
        audioButton.tintColor = .green
        let stopButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(didTapStop))
        stopButton.tintColor = .red
        
        navigationItem.rightBarButtonItems = [helpButton]
        navigationItem.leftBarButtonItems = [stopButton, audioButton]
        
    }
    
    @objc func viewWillDisappear( animated: Bool) {
        super.viewWillDisappear(animated)
        didTapStop()
    }
    
    @objc func didTapHelp() {
        let videoURLString = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        guard let videoURL = URL(string: videoURLString) else {
            print("Invalida video URL")
            return
        }
        
        let player = AVPlayer(url: videoURL)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true)
    }
    
    @objc func didTapAudio() {
        let audioURLString = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
        
        guard let audioURL = URL(string: audioURLString) else {
            print("Invalid audio URL")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = AVPlayer(url: audioURL)
            
            guard let player = self.player else {
                print("Player is null")
                return
            }
            
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func didTapStop() {
        guard let player = self.player else {
            print("Player is nil")
            return
        }
        player.pause()
        self.player = nil
    }
        
    @IBAction func photoTapped() {
        let alert = UIAlertController(title: "Select image from:", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.allowsEditing = true
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }
        
        let fototecaAction = UIAlertAction(title: "Fototeca", style: .default) { (action) in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }
        alert.addAction(cameraAction)
        alert.addAction(fototecaAction)
        self.present(alert, animated: true)
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // Validar que se seleccionó una imagen
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.image.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
