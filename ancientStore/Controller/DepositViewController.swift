//
//  DepositViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/27.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit
import AVFoundation

class DepositViewController: UIViewController {
    
    var bankView: UIImageView!
    var fireButton: UIButton!
    let totalCoinCount           = 300
    var lastFinishedCoinNumber   = 0
    var animationDuration:Double = 1.5
    var coinNumbers              = [Int]()
    
    var audioPlayer : AVAudioPlayer!
    
    let tokens = SavedToken.shared
    var receivedInfor: GetBankInfor?
    
    @IBOutlet weak var handMoneyLabel: UILabel!
    @IBOutlet weak var bankMoneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getBankMoney()
        handMoneyLabel.text = "\(tokens.savedToken!.balance) 元"
    }
    
    func voicePlay() {
        let soundURL = Bundle.main.url(forResource: "coinMusic", withExtension: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    fileprivate func setupView() {
//        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        let screen = UIScreen.main.bounds
        
        bankView = UIImageView(image: UIImage(named:"moneyBag"))
        bankView.center = CGPoint(x: screen.midX, y: 400)
        view.addSubview(bankView)
        
        fireButton = UIButton()
        fireButton.setImage(UIImage(named: "sheep"), for: .normal)
        fireButton.center = CGPoint(x: screen.midX, y: screen.height * 0.25)
        fireButton.bounds.size = CGSize(width: screen.midX, height: screen.height * 0.2)
        //        fireButton.backgroundColor = UIColor(red: 11/255, green: 155/255, blue: 169/255, alpha: 1.0)
        //        fireButton.setTitle("Show me the money", for: .normal)
        //        fireButton.setTitleColor(UIColor.white, for: .normal)
        fireButton.addTarget(self, action: #selector(fireButtonClickHandler), for: .touchUpInside)
        view.addSubview(fireButton)
    }
    
    @objc fileprivate func fireButtonClickHandler() {
        startCoinanimation()
        voicePlay()
    }
    
    fileprivate func shakeBank() {
        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        shake.fromValue = -0.2
        shake.toValue = 0.2
        shake.duration = 0.1
        shake.autoreverses = true
        shake.repeatCount = 3
        
        bankView.layer.add(shake, forKey: "bankShakeAnimation")
    }
    
    fileprivate func shakeSheep() {
        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        shake.fromValue = -0.2
        shake.toValue = 0.2
        shake.duration = 0.1
        shake.autoreverses = true
        shake.repeatCount = 3
        
        fireButton.layer.add(shake, forKey: "bankShakeAnimation")
    }
    
    fileprivate func startCoinanimation() {
        //        fireButton.isHidden = true
        lastFinishedCoinNumber = 0
        for i in 0...totalCoinCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.01, execute: {
                self.initCoinWith(number: i)
            })
        }
    }
    
    // 飛到位置
    fileprivate func initCoinWith(number:Int) {
        let coinImageName = "icon_coin_\(number % 2 + 1)"
        let coinView = UIImageView(image: UIImage(named:coinImageName))
        let x = bankView.center.x
        let y = bankView.center.y - 50
        coinView.center = CGPoint(x: x , y: y)
        
        // plus 1 since view's tag default is 0 includingUIViewController.view's tag is 0
        coinView.tag = number + 1
        
        coinNumbers.append(coinView.tag)
        animate(coinView: coinView)
        view.addSubview(coinView)
    }
    
    fileprivate func animate(coinView:UIView) {
        let targetX = coinView.layer.position.x
        let targetY = coinView.layer.position.y
        
        let path = CGMutablePath()
        let fromX = CGFloat(arc4random() % 400)
        let fromY = CGFloat(arc4random() % 2)
        let height = UIScreen.main.bounds.height + coinView.frame.size.height
        
        let cpx = targetX + (fromX - targetX)/2
        let cpy = fromY / 2 - targetY
        
        // position where animation start
        path.move(to: CGPoint(x: fromX, y: fireButton.center.y))
        path.addQuadCurve(to: CGPoint(x:targetX, y:targetY), control: CGPoint(x: cpx, y: cpy))
        shakeSheep()
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.path = path
        
        // animate from big to small
        let from3DScale:CGFloat = 1 + CGFloat(arc4random() % 10) * 0.1
        let to3DScale:CGFloat = from3DScale * 0.5
        let scaleAniamtion = CAKeyframeAnimation(keyPath: "transform")
        scaleAniamtion.values = [
            CATransform3DMakeScale(from3DScale, to3DScale, from3DScale),
            CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)
        ]
        scaleAniamtion.timingFunctions = [
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        ]
        
        // combine animations
        let animationGroup = CAAnimationGroup()
        animationGroup.delegate = self
        animationGroup.duration = animationDuration
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.isRemovedOnCompletion = false
        animationGroup.animations = [positionAnimation, scaleAniamtion]
        coinView.layer.add(animationGroup, forKey: "coin animation group")
    }
}

extension DepositViewController {
    
    func getBankMoney() {
        
        let passingData = GetBankRequired(userID: "arcadia@camp.com", key: "956275912")
        guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
        
        let url = URL(string: "https://c1b4390d.ngrok.io/api/shop/watch")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
                self.decodeData(data!)
                DispatchQueue.main.async {
                    self.bankMoneyLabel.text = "\(self.receivedInfor!.message.balance) 元"
                }
            }
        }
        task.resume()
    }
    
    func decodeData(_ data: Data) {
        let decoder = JSONDecoder()
        if let data = try? decoder.decode(GetBankInfor.self, from: data) {
            receivedInfor = data
        }
    }
}

extension DepositViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            lastFinishedCoinNumber += 1
            view.viewWithTag(coinNumbers.first!)?.removeFromSuperview()
            coinNumbers.removeFirst()
            
            if lastFinishedCoinNumber == totalCoinCount {
                shakeBank()
                fireButton.isHidden = false
            }
            
        }
    }
}
