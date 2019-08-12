//
//  ViewController.swift
//  iOSDebugLog
//
//  Created by 州 on 2019/08/05.
//  Copyright © 2019 州. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for _ in 0 ..< 200{
            DocumentLog(titleName: "100件テスト", isAddDate: false ,status: .error, contents: [])
        }
        DocumentLog(titleName: "BlankContents", status: .info, contents: [])
        DocumentLog(titleName: "", status: .error, contents: [])
        DocumentLog(titleName: "", status: .info, contents: ["hello","world"])
        DocumentLog(titleName: "", status: .warning, contents: [])
    }
}
