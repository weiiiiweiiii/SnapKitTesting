//
//  ViewController.swift
//  SnapClient
//
//  Created by Kei Fujikawa on 2018/06/15.
//  Copyright © 2018年 Kboy. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SCSDKCreativeKit
import SCSDKBitmojiKit

class CameraViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var iconView: UIImageView! {
        didSet {
            iconView.backgroundColor = .white
            iconView.layer.cornerRadius = iconView.frame.width/2
            iconView.clipsToBounds = true
        }
    }
    
    private var bitmojiSelectionView: UIView?
    
    // Control the Image to show the Image Processing Pipline
    private var image_time = -1
    
    // Control the Video to show the Video Processing Pipline
    private var video_time = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
        
        // fetch your avatar image.
        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
            DispatchQueue.main.async {
                if let avatarURL = avatarURL {
                    self.iconView.load(from: avatarURL)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    // MARK: About creating node
    
    private func setImageToScene(image: UIImage) {
        if let camera = sceneView.pointOfView {
            let position = SCNVector3(x: 0, y: 0, z: -0.5)
            let convertedPosition = camera.convertPosition(position, to: nil)
            let node = createPhotoNode(image, position: convertedPosition)
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    private func createPhotoNode(_ image: UIImage, position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let scale: CGFloat = 0.3
        let geometry = SCNPlane(width: image.size.width * scale / image.size.height,
                                height: scale)
        geometry.firstMaterial?.diffuse.contents = image
        node.geometry = geometry
        node.position = position
        return node
    }
    
    @IBAction func snapButtonTapped(_ sender: Any) {
        // Take a SnapShot of the Scene
        let snapshot = sceneView.snapshot()
        let photo = SCSDKSnapPhoto(image: snapshot)
        let snap = SCSDKPhotoSnapContent(snapPhoto: photo)
        
        // Sticker
        // Static Sticker from app
        let sticker = SCSDKSnapSticker(stickerImage: #imageLiteral(resourceName: "snap-ghost"))
        
        // Sticker
        snap.sticker = sticker
        
        // Caption
        snap.caption = "Snap on Snapchat!"
        
        // URL
        snap.attachmentUrl = "https://www.snapchat.com"
        
        let api = SCSDKSnapAPI(content: snap)
        api.startSnapping { error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                // success
            }
        }
    }
    
    @IBAction func snapCameraTapped(_ sender: Any)
    {
        // Use SnapChat's Camera
        let snap = SCSDKNoSnapContent()
        
        // Sticker
        // Server on AWS provides Sticker
        // Chang with different Image
        var url = URL(string: "http://54.215.189.97:5000/get_image?type=1")
        image_time+=1
        if image_time % 2 != 0
        {
            url = URL(string: "http://54.215.189.97:5000/get_image?type=error")
        }
        
        let sticker = SCSDKSnapSticker(stickerUrl: url!, isAnimated: false)
        
        // Set the default value of sticker position
        sticker.posY = 0.8
        sticker.posX = 0.8
        // Chang with different image
        if image_time % 2 != 0
        {
            sticker.posY = 0.2
            sticker.posX = 0.2
        }
        
        // Sticker
        snap.sticker = sticker
        
        // Caption
        snap.caption = "USE SNAPCHAT'S CAMERA WOW!!!!"
        
        // URL
        snap.attachmentUrl = url?.absoluteString
        
        let api = SCSDKSnapAPI(content: snap)
        api.startSnapping { error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                // success
            }
        }
    }
    
    @IBAction func videoTapped(_ sender: Any)
    {
        var video_url = URL(string: "http://54.215.189.97:5000/get_video?name=kobe")
        var sticker_url = URL(string: "http://54.215.189.97:5000/get_image?type=harden")
        var sticker = SCSDKSnapSticker(stickerUrl: sticker_url!, isAnimated: true)
        video_time+=1
        if video_time % 2 != 0
        {
            video_url = URL(string: "http://54.215.189.97:5000/get_video?name=new_york")
            sticker_url = URL(string: "http://54.215.189.97:5000/get_image?type=ok")
            sticker = SCSDKSnapSticker(stickerUrl: sticker_url!, isAnimated: false)
        }
        
        let video = SCSDKSnapVideo(videoUrl: video_url!)
        let videoContent = SCSDKVideoSnapContent(snapVideo: video)
        
        // Sticker
        videoContent.sticker = sticker
        sticker.posY = 0.2
        sticker.posX = 0.8
        
        // Caption
        videoContent.caption = "WOW THIS IS A VIDEO with GIF!"
        
        // URL
        videoContent.attachmentUrl = video_url?.absoluteString
        
        let api = SCSDKSnapAPI(content: videoContent)
        api.startSnapping { error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                // success
            }
        }
    }
    
    @IBAction func bitmojiButtonTapped(_ sender: Any) {
        // Make bitmoji background view
        let viewHeight: CGFloat = 300
        let screen: CGRect = UIScreen.main.bounds
        let backgroundView = UIView(
            frame: CGRect(
                x: 0,
                y: screen.height - viewHeight,
                width: screen.width,
                height: viewHeight
            )
        )
        view.addSubview(backgroundView)
        bitmojiSelectionView = backgroundView
        
        // add child ViewController
        let stickerPickerVC = SCSDKBitmojiStickerPickerViewController()
        stickerPickerVC.delegate = self
        addChildViewController(stickerPickerVC)
        backgroundView.addSubview(stickerPickerVC.view)
        stickerPickerVC.didMove(toParentViewController: self)
    }
}

extension CameraViewController: SCSDKBitmojiStickerPickerViewControllerDelegate {
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String) {
        
        bitmojiSelectionView?.removeFromSuperview()
        
        if let image = UIImage.load(from: bitmojiURL) {
            DispatchQueue.main.async {
                self.setImageToScene(image: image)
            }
        }
    }
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, searchFieldFocusDidChangeWithFocus hasFocus: Bool) {
        
    }
}
