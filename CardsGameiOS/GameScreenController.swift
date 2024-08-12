//
//  GameScreenController.swift
//
//  Created by Nitsan on 07/08/2024.
//

import UIKit

class GameScreenController:UIViewController, CountdownDelegate{
    var names: [String]?
    var direction: String = "east"
    var points: [Int] = [0, 0]

    var countdown: CountdownManager?
    var cardImageLeft:UIImageView?
    var cardImageRight:UIImageView?
    var timeIndicator: UILabel?
    
    var leftPoints: UILabel?
    var rightPoints: UILabel?
    var gamesPlayedLabel: UILabel?
    var countdownLabel: UILabel?

    let Max_Games = 10
    var gamesDone = 0

    override func viewDidLoad() {
        let rightName = direction == "east" ? names?[0] : names?[1]
        let leftName = direction == "east" ? names?[1]: names?[0]
        
        let safeInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let imageWidth = self.view.frame.width / 4
        
        let font = UIFont(name: "Optima Regular", size: 20)
        
        let rightSideName = UILabel(frame: CGRect(x: self.view.frame.width - safeInsets.right - imageWidth, y: safeInsets.top + 5, width: imageWidth, height: 30))
        rightSideName.textAlignment = .center
        rightSideName.text = rightName ?? ""
        
        let leftSideName = UILabel(frame: CGRect(x: safeInsets.left, y: safeInsets.top + 5, width: imageWidth, height: 30))
        leftSideName.textAlignment = .center
        leftSideName.text = leftName ?? ""
        
        rightPoints = UILabel(frame: CGRect(x: self.view.frame.width - safeInsets.right - imageWidth, y: rightSideName.frame.maxY + 5, width: imageWidth, height: 30))
        rightPoints?.textAlignment = .center
        rightPoints?.text = "0 Points"
        leftPoints = UILabel(frame: CGRect(x: safeInsets.left, y: leftSideName.frame.maxY + 5, width: imageWidth, height: 30))
        leftPoints?.textAlignment = .center
        leftPoints?.text = "0 Points"
        countdownLabel = UILabel(frame: CGRect(x: self.view.midX - 50, y: self.view.frame.midY - 25, width: 100, height: 50))
        countdownLabel?.textAlignment = .center
        
        let countdownWidth:CGFloat = 50
        let countdownImage = UIImageView(frame: CGRect(x: CGFloat(countdownLabel!.midX) - countdownWidth/2, y: countdownLabel!.frame.minY - countdownWidth - 10, width: countdownWidth, height: countdownWidth))
        countdownImage.image = UIImage(named: "countdown")
        countdownImage.alpha = 0
        countdownImage.transform.ty = 20
        
        gamesPlayedLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height - safeInsets.bottom - 40, width: self.view.frame.width, height: 50))
        gamesPlayedLabel?.textAlignment = .center
        cardImageLeft = UIImageView(frame: CGRect(x: safeInsets.left, y: leftPoints!.frame.maxY, width: self.view.frame.width / 4, height: self.view.frame.height * 3/5))
        cardImageLeft?.image = UIImage(named: "cardback")
        cardImageRight = UIImageView(frame: CGRect(x: self.view.frame.width - safeInsets.right - imageWidth, y: leftPoints!.frame.maxY, width: self.view.frame.width / 4, height: self.view.frame.height * 3/5))
        cardImageRight?.image = UIImage(named: "cardback")
        countdown = CountdownManager()
        countdown?.delegate = self
        countdown?.start()
        
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.85, blue: 0.85, alpha: 1)
        self.view.addSubview(countdownImage)
        self.view.addSubview(rightSideName)
        self.view.addSubview(leftSideName)
        self.view.addSubview(countdownLabel!)
        self.view.addSubview(rightPoints!)
        self.view.addSubview(leftPoints!)
        self.view.addSubview(cardImageLeft!)
        self.view.addSubview(cardImageRight!)
        self.view.addSubview(gamesPlayedLabel!)
        
        for view in self.view.subviews {
            (view as? UILabel)?.font = font
        }
        
        UIView.animate(withDuration: 1){
            countdownImage.alpha = 1
            countdownImage.transform.ty = 0
        }
    }
 
    func didUpdateTime(time: Int) {
        countdownLabel?.text = "\(time >= 5 ? 0 : 5 - time)"
        if(time == 5){
            showCards()
            gamesDone += 1;
            gamesPlayedLabel?.text = "Games played: \(gamesDone)"
        }else if time == 8{
            if(gamesDone == Max_Games){
                countdown?.stop()
                navigateToFinish()
            }else{
                resetCards()
            }
        }
    }
    
    func navigateToFinish(){
        let finishViewController = FinishViewController()
        var isUserWinner = false
        
        if(points[0] < points[1] && direction == "east")
            || (points[0] > points[1] && direction == "west")
            || (points[0] == points[1]){
                isUserWinner = true
        }
        
        finishViewController.isUserWinner = isUserWinner
        finishViewController.score = max(points[0], points[1])
        self.navigationController?.pushViewController(finishViewController, animated: true)
    }
    
    func showCards(){
        let cards = randomCards
        
        //0 is the left side
        let result = cards[0].compare(secondCard: cards[1])

        switch result{
        case .larger:
            points[0] += 1
            leftPoints?.text = "\(points[0]) Points"
            break
        case .smaller:
            points[1] += 1
            rightPoints?.text = "\(points[1]) Points"
            break
        default:
            points[0] += 1
            points[1] += 1
            leftPoints?.text = "\(points[0]) Points"
            rightPoints?.text = "\(points[1]) Points"
            break
        }
        changeCards(to: ["\(cards[0].number)","\(cards[1].number)"])
    }
    
    func changeCards(to images:[String]){
        UIView.animate(withDuration: 0.5, animations: {
            //Makes card invisible
            self.cardImageLeft?.layer.transform = CATransform3DMakeRotation(Double.pi/2, 0, 1, 0)
            self.cardImageRight?.layer.transform = CATransform3DMakeRotation(Double.pi/2, 0, 1, 0)
        }){
            _ in
            //Set to new image
            self.cardImageLeft?.image = UIImage(named: images[0])
            self.cardImageRight?.image = UIImage(named: images[1])
            UIView.animate(withDuration: 0.5){
                self.cardImageLeft?.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
                self.cardImageRight?.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
            }
        }
    }
        
    func resetCards(){
        changeCards(to: ["back","back"])
    }
    
    private var randomCards:[Card] {
        get{
             [Card(number: Int.random(in: 1...13)), Card(number: Int.random(in: 1...13))]
        }
    }
}

enum CardCompare {
   case tie, larger, smaller
}

struct Card {
    var number: Int
    
    func compare(secondCard: Card)->CardCompare{
        if number == secondCard.number{
            return .tie
        }else if number > secondCard.number{
            return .larger
        }
        return .smaller
    }
}

protocol CountdownDelegate {
    func didUpdateTime (time: Int)-> Void
}

class CountdownManager {
    var timer: Timer?
    var timeLapsed = 0
    var delegate: CountdownDelegate?
    
    @objc func fire(){
        timeLapsed += 1;
        delegate?.didUpdateTime(time: timeLapsed)
        if(timeLapsed == 8){
           reset()
        }
    }
    
    func reset(){
        timeLapsed = 0
    }
    
    func start(){
        timer = Timer(timeInterval: 1, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode:.common)
    }
    
    func stop(){
        timer?.invalidate()
    }
}
