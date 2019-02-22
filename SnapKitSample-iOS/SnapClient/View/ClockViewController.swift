//
//  ClockViewController.swift
//  SnapClient
//
//  Created by YuLiangze on 2/21/19.
//  Copyright © 2019 Kboy. All rights reserved.
//

import UIKit
import SceneKit
import SCSDKCreativeKit
import SCSDKBitmojiKit

class ClockViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var confirm: UIButton!
    
    var pickerData: [[Int]] = [[Int]]()
    var hr = 0
    var min = 0
    var total_min = 0
    
    let hr_range = [Int](0...99)
    let min_range = [Int](0...59)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = [hr_range,min_range]

        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Times New Roman", size: 30)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = String(pickerData[component][row])
        
        return pickerLabel!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var range = 0
        if component == 0{
            range = hr_range.count
        }
        else if component == 1{
            range = min_range.count
        }
        return range
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[component][row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("You selected component #\(component)! "+"row #\(row)! "+"\(self.pickerData[component][row])")
        if component == 0{
            hr = self.pickerData[component][row]
        }
        else if component == 1{
            min = self.pickerData[component][row]
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        total_min = hr*60+min
        print("Hour:\(hr), Min:\(min), Total Min:\(total_min)")
        
        /*
        // Use SnapChat's Camera
        let snap = SCSDKNoSnapContent()
        
        // Sticker
        // Server on AWS provides Sticker
        // Chang with different Image
        let url = URL(string: "http://54.215.189.97:8080/animations/clock.html?m=\(total_min)")
        
        let sticker = SCSDKSnapSticker(stickerUrl: url!, isAnimated: true)
        
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
        */
    }
}
