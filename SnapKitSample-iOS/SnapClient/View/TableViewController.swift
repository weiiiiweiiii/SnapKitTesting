//
//  ViewController.swift
//  SnapClient
//
//  Created by YuLiangze on 2/14/19.
//  Copyright © 2019 Kboy. All rights reserved.
//

import UIKit
import SceneKit
import SCSDKCreativeKit
import SCSDKBitmojiKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var items: [String] = ["ok", "error","miao","harden","webp_sample","kobe","clock"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    private func goToClock(){
        let storyboard = UIStoryboard(name: "Clock", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Clock")
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)! "+self.items[indexPath.row])
        
        if self.items[indexPath.row] == "clock"{
            goToClock()
        }
        else{
            // Use SnapChat's Camera
            let snap = SCSDKNoSnapContent()
            
            // Sticker
            // Server on AWS provides Sticker
            // Chang with different Image
            let url = URL(string: "http://54.215.189.97:5000/select_image?name="+self.items[indexPath.row])
            
            // Trash code for testing purpose
            var animated = false
            if self.items[indexPath.row] == "harden" || self.items[indexPath.row] == "miao" || self.items[indexPath.row] == "webp_sample"{
                animated = true
            }
            let sticker = SCSDKSnapSticker(stickerUrl: url!, isAnimated: animated)
            
            // Set the default value of sticker position
            sticker.posY = 0.2
            sticker.posX = 0.5
            // Chang with different image
            
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
    }
}
