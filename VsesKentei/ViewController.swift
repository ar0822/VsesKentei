//
//  ViewController.swift
//  VsesKentei
//
//  Created by RAN on 2015/04/23.
//  Copyright (c) 2015年 nagae. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImgeView: UIImageView!
    @IBOutlet weak var taitleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var creditLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //loadCSVメソッドで配列csvArrayに読み込んだCSVファイルを格納
        let csvArray = loadCSV(filename: "start")

        //BodyTextViewを入力不可にする
        bodyTextView.isEditable = false

        
        
        //ImageViewに画像を格納
        let img:UIImage = UIImage(named: csvArray[0])!
        logoImgeView.image = img
        //titleLabelにアプリ名を設定
        taitleLabel.text = csvArray[1]
        //bodyTextViewにアプリ説明文を設定
        bodyTextView.text = csvArray[2]
        //ボタンのタイトル文字を白色に設定
//        startButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //creditLableにクレジットを設定
        creditLabel.text = (csvArray[3])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var csvArray: [String] = []
    //CSVファイルの読み込みメソッド。引数にファイル名、戻り値にString型の配列。
    func loadCSV(filename :String) -> [String]{
        //CSVファイルの読み込み
        let csvBundle = Bundle.main.path(forResource: filename, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle,encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
             csvArray = lineChange.components(separatedBy: "\n")
        } catch{
            print("エラー")
        }
        
        return csvArray
        
        //エラー値の設定
//        var encodingError:NSError? = nil
//        //csvBundleのパスを読み込み、UTF8に変換して、NSStingに格納
//        let csvData = try String(contentsOfFile: csvBundle!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
//        //改行コードが”\r”で行なわれている場合は”\n”に変更する
//        let lineChange = csvData.stringByReplacingOccurrencesOfString("\r", withString: "\n")
//        //"\n"の改行コードで区切って、配列csvArrayに格納する
//        let csvArray:Array = lineChange.componentsSeparatedByString("\n")
//
//        return csvArray
    }



}

