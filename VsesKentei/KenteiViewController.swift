//
//  KenteiViewController.swift
//  VsesKentei
//
//  Created by RAN on 2015/04/23.
//  Copyright (c) 2015年 nagae. All rights reserved.
//

import UIKit

class KenteiViewController: UIViewController {

    @IBOutlet weak var mondaiNumberLabel: UILabel!
    @IBOutlet weak var mondaiTextView: UITextView!
    @IBOutlet weak var judgeImageView: UIImageView!
    @IBOutlet weak var answerBtn1: UIButton!
    @IBOutlet weak var answerBtn2: UIButton!
    @IBOutlet weak var answerBtn3: UIButton!
    @IBOutlet weak var answerBtn4: UIButton!
    
    //kentai.csvファイルを格納する配列csvArray
    var csvArray = [String]()
    
    //csvArrayから取り出した問題を格納する配列mondaiaArray
    var mondaiArray = [String]()
    var mondaiCount = 0    //問題をカウントする変数
    var correctCount = 0   //正解をカウントする変数
    let total = 10         //出題数を管理する定数
    
    //解説バッググラウンド画像
    var kaisetsuBGImageView = UIImageView()
    
    //バックグラウンド画像のＸ座標
    var kaisetsuBGX = 0.0
    
    //正解表示ラベル
    var seikaiLable = UILabel()
    
    //解説テキストビュー
    var kaisetsuTextView = UITextView()
    
    //バックボタン
    var backBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //TextViewを入力不可にする
        kaisetsuTextView.isEditable = false
        mondaiTextView.isEditable = false
        
        //バックグラウンド画像をセット
        kaisetsuBGImageView.image = UIImage(named: "kaisetsuBG.png")
        
        //画面サイズを取得
        let screenSize:CGSize = (UIScreen.main.bounds.size)
        
        //解説バックグラウンド画像のＸ座標（画面の中央になるように設定）
        kaisetsuBGX = Double(screenSize.width/2) - 320/2
        
        //フレームを設定。Y座標に画面の縦サイズを設定して、画面の外に配置する
        kaisetsuBGImageView.frame = CGRect(x: kaisetsuBGX, y: Double(screenSize.height), width: 320, height: 210)
        
        //画面上のタッチ操作を可能にする
        kaisetsuBGImageView.isUserInteractionEnabled = true
        
        //画像をviewに配置
        self.view.addSubview(kaisetsuBGImageView)
        
        //正解表示ラベルのフレームを設定
        seikaiLable.frame = CGRect(x: 20, y: 15, width: 280, height: 30)
        
        //正解表示ラベルのアライメントをセンターに設定
        seikaiLable.textAlignment = .center
        
        //正解表示ラベルのフォントサイズを15ポイント設定
        seikaiLable.font = UIFont.systemFont(ofSize: CGFloat(15))
        
        //正解ラベルを解説バックグランド画像に配置
        kaisetsuBGImageView.addSubview(seikaiLable)
        
        //解説テキストビューのフレームを設定
        kaisetsuTextView.frame = CGRect(x: 20, y: 50, width: 280, height: 130)
        
        //解説テキストビューの背景色を透明に設定
        kaisetsuTextView.backgroundColor = UIColor.clear
        
        //解説テキストビューのフォントサイズを17ポイントに設定
        kaisetsuTextView.font = UIFont.systemFont(ofSize: CGFloat(17))
        
        //解説テキストビューを解説バックグラント画像に設定
        kaisetsuBGImageView.addSubview(kaisetsuTextView)
        
        //バックボタンのフレームを設定
        backBtn.frame = CGRect(x: 10, y: 180, width: 300, height: 30)
        
        //バックボタンに通常時と押下時の画像を設定
        backBtn.setImage(UIImage(named:"kenteiBack.png"), for: [])
        
        backBtn.setImage(UIImage(named: "kenteiBackOn1.png"), for: .highlighted)
        
        //バックボタンにアクションを設定
        //backBtn.addTarget(self, action: Selector(("backBtnTapped")), for: UIControl.Event.touchUpInside)
        
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        //バックボタンを解説バックグランド画像に配置
        kaisetsuBGImageView.addSubview(backBtn)
        
        //変数viewControllerを作成
        let viewController = ViewController()
        
        //loadCSVメソッドを使用し、csvArrayに検定問題を格納
        csvArray = viewController.loadCSV(filename: "kentei")
        
        //シャッフルメソッドを使用し、検定問題を並び替えてcsvArrayに格納
        csvArray = mondaiShuffle()
        
        //csvArrayの0行目を取り出し、カンマを区切りとしてmondaiArrayに格納
        mondaiArray = csvArray[mondaiCount].components(separatedBy: ",")
        
        //変数mondaiCountに1を足してラベルに出題数を設定
        mondaiNumberLabel.text = "第\(mondaiCount+1)問"
        
        //TextViewに問題を設定
        mondaiTextView.text = mondaiArray[0]
        
        //選択肢ボタンのタイトルに選択肢を設定
        answerBtn1.setTitle(mondaiArray[2], for: [])
        answerBtn2.setTitle(mondaiArray[3], for: [])
        answerBtn3.setTitle(mondaiArray[4], for: [])
        answerBtn4.setTitle(mondaiArray[5], for: [])
        
    }
    
    //四択ボタンを押した時のメソッド
    @IBAction func btnAction(sender: UIButton){
        
        //正解番号とボタンのtagが同じなら正解
        if sender.tag == Int(mondaiArray[1]){
            //○を表示
            judgeImageView.image = UIImage(named: "maru.png")!
            //正解カウントを増やす
            correctCount += 1
        } else {
            //間違っていたら×を表示
            judgeImageView.image = UIImage(named: "batsu.png")!
        }
        
        //judgeImageViewを表示
        judgeImageView.isHidden = false
        
        //kaisetsuメソッドの呼び出し
        kaisetsu()
    }
    
    //次の問題を表示するメソッド
    func nextProblem(){
        
        //問題カウント変数をカウントアップ
        mondaiCount += 1
        
        //mondaiArrayに格納されている問題配列を削除
        mondaiArray.removeAll(keepingCapacity: true)
        
        //if-else文を追加。mondaiCountがtotalに達したら画面遷移
        if mondaiCount < total {
        
            //csvArrayから次の問題配列をmondaiArrayに格納
            mondaiArray = csvArray[mondaiCount].components(separatedBy: ",")
        
            //問題数ラベル、問題表示テキストビュー、選択肢ボタンに情報をセット
            mondaiNumberLabel.text = "第\(mondaiCount+1)問"
            mondaiTextView.text = mondaiArray[0]
            answerBtn1.setTitle(mondaiArray[2], for: [])
            answerBtn2.setTitle(mondaiArray[3], for: [])
            answerBtn3.setTitle(mondaiArray[4], for: [])
            answerBtn4.setTitle(mondaiArray[5], for: [])
            
        } else {
            
            //Storyboard SegueのIdentifierを引数に設定して画面遷移
            performSegue(withIdentifier: "score", sender: nil)
        }
        
    }
    
    //解説表示メソッド
    func kaisetsu() {
        
        //正解表示ラベルのテキストを問題Arrayから取得
        seikaiLable.text = mondaiArray[6]
        
        //解説テキストビューのテキストをmondaiArrayから取得
        kaisetsuTextView.text = mondaiArray[7]
        
        //answerBtn1のｙ座標を取得
        let answerBtnY = answerBtn1.frame.origin.y
        
        //解説バックグランド画像を表示させるアニメーション
        UIView.animate(withDuration: 0.5, animations: { () -> Void in self.kaisetsuBGImageView.frame = CGRect(x: self.view.bounds.width/2 - 320/2, y: answerBtnY, width: 320, height: 210);})
        
        //選択肢ボタンの停止
        answerBtn1.isEnabled = false
        answerBtn2.isEnabled = false
        answerBtn3.isEnabled = false
        answerBtn4.isEnabled = false
        
    }
    
    //バックボタンメソッド
    @objc func backBtnTapped() {
        
        //画面サイズを取得
        let scrrenHeight = Double(UIScreen.main.bounds.size.height)
        
        //解説バックグランド画像を枠外に移動さ得るアニメーション
        UIView.animate(withDuration: 0.5, animations: {() -> Void in self.kaisetsuBGImageView.frame = CGRect(x: self.kaisetsuBGX, y: scrrenHeight, width: 320, height: 210); })

        //選択肢ボタンの使用を再開
        answerBtn1.isEnabled = true
        answerBtn2.isEnabled = true
        answerBtn3.isEnabled = true
        answerBtn4.isEnabled = true
        
        //正誤表示画像を隠す
        judgeImageView.isHidden = true
        
        //nextProblemメソッドを呼び出す
        nextProblem()
        
    }
    
    //得点画面へ値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sVC = segue.destination as! ScoreViewController
        sVC.correct = correctCount
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //配列シャッフルメソッド
    func mondaiShuffle()->[String]{
        
        var array = [String]() //String型の配列を宣言
        
        //csvArrayをNSMutableArrayに変換してsortedArrayに格納
        let sortedArray = NSMutableArray(array: csvArray)
        
        //sortedArrayの配列数を取得
        var arrayCount = sortedArray.count
        
        //while文で配列の要素数だけ繰り返し処理をする
        while(arrayCount > 0){
            
            //ランダムなインデックス番号を取得するため配列数の範囲で乱数を作る
            let randomIndex = arc4random() % UInt32(arrayCount)
            
            //sortedArrayのarrayCount番号とランダム番号を入れ替える
            sortedArray.exchangeObject(at: (arrayCount-1), withObjectAt: Int(randomIndex))
            
            //arrayCountを1減らす
            arrayCount = arrayCount - 1
            
            //sortedArrayのarrayCount番号の要素をarrayに追加
            array.append(sortedArray[arrayCount] as! String)
            
        }
        
        //arrayを戻り値にする
        return array
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
