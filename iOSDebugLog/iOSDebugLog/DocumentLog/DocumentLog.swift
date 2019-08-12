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
    isAddDate:Bool = true,
    addFileName:String = #file,
    addFuncName:String = #function,
    addLineNo:Int = #line,
    description:String = "",
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
    
    var fileName = titleName
    if isAddDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let now = Date()
        fileName += "_" + dateFormatter.string(from: now)
    }
    
    let checkfilePath = statusPath + "/" + fileName + textStr
    
    if !fmDefault.fileExists(atPath: checkfilePath) {
        // 同名ファイルがない時、ファイルを作成
        fmDefault.createFile(atPath: checkfilePath, contents: outputData, attributes: [FileAttributeKey.creationDate:Date(),
                                                                                  FileAttributeKey.modificationDate:Date()])
    }else{
        // 同名ファイルがある時、後ろに数字をつけて作成
        var num = 2
        var addNumFilePath = statusPath + "/" + fileName + "(\(num))" + textStr
        // 同名ファイルがあり、100件未満の時、数字を足して再作成。
        // 同名ファイルがないか、100件すでにあるならループから外れる
        while (fmDefault.fileExists(atPath: addNumFilePath) && (num < 100)) {
            num += 1
            addNumFilePath = statusPath + "/"  + fileName + "(\(num))" + textStr
            if num > 99 {
                break
            }
        }
        // 同名ファイルがない時、ファイルを作成
        if !fmDefault.fileExists(atPath: addNumFilePath){
            fmDefault.createFile(atPath: addNumFilePath, contents: outputData, attributes: [FileAttributeKey.creationDate:Date(),
                                                                                            FileAttributeKey.modificationDate:Date()])
        }else{
            // 同名ファイルがある時、同名ファイルが100件以上ある。
            print("既に100件の同名ファイルが存在します。テキストファイルの作成は行われません。")
            
        }
    }
}

public enum LogStatus:String {
    case info = "Infomation"
    case warning = "Warning"
    case error = "Error"
}

