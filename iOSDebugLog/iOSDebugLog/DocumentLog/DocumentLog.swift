//
//  DebugLog.swift
//  iOSDebugLog
//
//  Created by 州 on 2019/08/05.
//  Copyright © 2019 州. All rights reserved.
//

import UIKit

/// - Parameters:
///   - titleName: ファイルタイトル名
///   - isAddDate: ファイルタイトル名の後ろに_Dateを付けるか、通常は未設定を想定
///   - addFileName: テキストの1行目にファイル名の記載、通常は未設定を想定
///   - addFuncName: テキストの2行目にメソッド名の記載、通常は未設定を想定
///   - addLineNo: テキストの3行目に呼び出し元の行数を記載、通常は未設定を想定
///   - description: テキストの4行目に入れたい文字があれば記載、通常は未設定を想定
///   - status: 用途分け、保存するフォルダが変わる
///   - contents: テキストの内容。配列の行が変わると改行する
@inlinable public func DocumentLog(titleName:String,
    _ isAddDate:Bool = true,
    _ addFileName:String = #file,
    _ addFuncName:String = #function,
    _ addLineNo:Int = #line,
    _ description:String = "",
    status:LogStatus,
    contents:[Any]) {
    
    let textStr = ".text"
    let dateFormat = "yyyyMMddHHmmss"
    
    let fileNameArray = addFileName.components(separatedBy: "/")
    guard let addFileName = fileNameArray.last else{
        return
    }
    
    var outputText = "File:" + addFileName + "\n" + "Func:" + addFuncName + "\n" + "Line:\(addLineNo)" + "\n" + description + "\n"
    contents.forEach { outputText = outputText + "\n" + "\($0)" }
    let outputData: Data? = outputText.data(using: .utf8)
    
    
    guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
        print("documentsPathError")
        return
    }
    
    let statusPath = documentsPath + "/\(status.rawValue)"
    let fmDefault = FileManager.default
    do {
        try fmDefault.createDirectory(atPath: statusPath, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Error")
        print("fmDefault.createDirectory")
        return
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let now = Date()
    let fileName = titleName + "_" + dateFormatter.string(from: now)
    let checkfilePath = statusPath + "/" + fileName + textStr
    
    if !fmDefault.fileExists(atPath: checkfilePath) {
        // 同名ファイルがない時、ファイルを作成
        fmDefault.createFile(atPath: checkfilePath, contents: outputData, attributes: [FileAttributeKey.creationDate:Date(),
                                                                                  FileAttributeKey.modificationDate:Date()])
    }else{
        // 同名ファイルがある時、後ろに数字をつけて作成
        var num = 2
        var addNumFilePath = statusPath + "/" + fileName + "(\(num))" + textStr
        // 数字をつけても同名ファイルがある時、数字を足して作成。100件あったら諦める。
        while (fmDefault.fileExists(atPath: addNumFilePath) || (num > 99)) {
            num += 1
            addNumFilePath = statusPath + "/"  + fileName + "(\(num))" + textStr
            if num > 99 {
                print("既に100件の同名ファイルが存在します。テキストファイルの作成は行われません。")
            }
        }
        fmDefault.createFile(atPath: addNumFilePath, contents: outputData, attributes: [FileAttributeKey.creationDate:Date(),
                                                                                  FileAttributeKey.modificationDate:Date()])
    }
}

public enum LogStatus:String {
    case info = "Infomation"
    case warning = "Warning"
    case error = "Error"
}
