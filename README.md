# iOSDebugLog
iOSのApp"ファイル"より確認できるログのレポジトリ

## 利用方法
#### 1.iOSDebugLog⁩ ▸ ⁨iOSDebugLog⁩ ▸ ⁨DocumentLog の中身を自分のプロジェクトにコピー

#### 2.ログを作成したい箇所で下記メソッドを呼ぶ
DocumentLog(titleName: "Title", status: .info, contents: [])
※引数の詳細はソース内コメントを参照

#### 3.info.plistに下記項目を追加、trueに設定する
Supports opening documents in place
Application supports iTunes file sharing
参考:"info.plist設定.png"

## 確認方法
"ファイル"→"このiPhone内"→(自分のプロジェクト名)
参考:"参考画像1"~"参考画像4"を参照
