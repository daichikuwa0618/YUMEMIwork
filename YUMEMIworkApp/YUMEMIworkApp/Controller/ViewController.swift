//
//  ViewController.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/04.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class ViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        inputTextView.placeholder = "変換したいテキストを入力してください"
        }
    }
    @IBAction func tapConvert(_ sender: Any) {
        let japaneseSentence: String = inputTextView.text ?? ""
        APIClient().convert(japaneseSentence) { text in
            self.outputLabel.text = text
        }
    }
}

