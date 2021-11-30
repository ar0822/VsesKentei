//
//  ScoreViewController.swift
//  VsesKentei
//
//  Created by RAN on 2015/04/23.
//  Copyright (c) 2015年 nagae. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    //KenteiViewControllerの生活数を受け取るメンバ変数
    var correct = 0
    
    //正解数を表示するラベル
    @IBOutlet var scoreLable: UILabel!
    
    //よくできました！のイメージビュー
    @IBOutlet var yokudekimasitaImageView: UIImageView!
    
    //合格 or 不合格画像を表示する画像
    @IBOutlet var judgeImageView: UIImageView!
    
    @IBOutlet var goukakuTimesLabel: UILabel! //合格回数を表示する変数
    @IBOutlet var rankLabel: UILabel! //ランクを表示する変数
    var goukakuTimes = 0
    var rankString = "見習いの補佐"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //合格回数を保存するNSUserDefaults
        let goukakuUd = UserDefaults.standard
        
        //合格回数をgoukakuUdというキー値で変数goukakuTimesに格納
        goukakuTimes = goukakuUd.integer(forKey: "goukaku")
        
        //正解数を表示
        scoreLable.text = "正解数は\(correct)問です。"

        // Do any additional setup after loading the view.
        
        //正解数を表示
        scoreLable.text = "正解数は\(correct)問です"
        
        //合格・不合格を判定
        if correct >= 7 {
            
            judgeImageView.image = UIImage(named: "juken_goukakuhappyou_happy.png")!
            yokudekimasitaImageView.image = UIImage(named: "grade1_taihenyoku.png")!
            
            goukakuTimes += 1
            
            //goukakuキー値を使って合格回数（goukakuTimes）を保存
            goukakuUd.set(goukakuTimes, forKey: "goukaku")
            
            
        } else {
            
            judgeImageView.image = UIImage(named: "juken_goukakuhappyou_cry.png")!
            yokudekimasitaImageView.image = UIImage(named: "grade4_mousukoshi.png")!
            
        }
        
        //合格回数を表示
        goukakuTimesLabel.text = "合格回数は\(goukakuTimes)回です。"
        
        //合格回数によってランクを決定
        if goukakuTimes >= 50 {
            
            rankString = "達人"
            
        } else if goukakuTimes >= 40 {
            
            rankString = "師匠"
            
        } else if goukakuTimes >= 30 {
            
            rankString = "師範代"
            
        } else if goukakuTimes >= 20 {
            
            rankString = "上級者"
            
        } else if goukakuTimes >= 10 {
            
            rankString = "見習い"
            
        } else if goukakuTimes >= 0 {
            
            rankString = "見習いの補佐の付き人"
            
        }
        
        //ランクラベルに称号を設定
        rankLabel.text = "ランクは\(rankString)！"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
