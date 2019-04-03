//
//  ViewController.swift
//  BinaryImage
//
//  Created by Tseng, TaiWei | Davis | TWR on 2019/04/02.
//  Copyright © 2019 Davis. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var loadingSpinner: NSProgressIndicator!
    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var pixelTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
        loadingSpinner.isHidden = true
    }
}

extension ViewController: DragViewDelegate {
    func dragView(didDragFileWith URL: NSURL) {
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimation(self.view)
        do {
            let imgData = try Data.init(contentsOf: URL as URL)
            var imgStr = ""
            var needPixel = Int(pixelTextField.stringValue)
            if(needPixel == nil) {
                needPixel = 1000
            }
            for i in 0 ..< 3 * needPixel! {
                imgStr = imgStr + String(imgData[i], radix: 2)
            }
            let newURL = URL.deletingPathExtension! as NSURL
            let baseSixFourImg = imgData.base64EncodedData()
            let radixTwoURL = newURL.appendingPathExtension("txt")! as NSURL
            let baseSixFourURL = newURL.appendingPathExtension("64.txt")! as NSURL
            try imgStr.write(to: radixTwoURL.absoluteURL!, atomically: false, encoding: .utf8)
            try baseSixFourImg.write(to: baseSixFourURL.absoluteURL!, options: NSData.WritingOptions.atomic)
            loadingSpinner.isHidden = true
            loadingSpinner.stopAnimation(self.view)
            showSuccessAlert(url: newURL.absoluteString!)
        } catch {
            print("Error info: \(error)")
        }
    }
    
    fileprivate func showSuccessAlert(url: String) {
        let alert = NSAlert()
        alert.messageText = url
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Done")
        alert.runModal()
    }
}

