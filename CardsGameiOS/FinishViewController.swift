//
//  EndScreenController.swift
//
//  Created by Nitsan on 05/08/2024.
//

import UIKit

class FinishViewController:UIViewController {
    var isUserWinner: Bool?
    var score: Int = 0
    var winnerLabel: UILabel?
    var scoreLabel: UILabel?

    override func viewDidLoad() {
        let winnerName = UILabel(frame: CGRect(x: 0, y: self.view.frame.midY - 15, width: self.view.frame.width, height: 30))
        winnerName.textAlignment = .center
        winnerName.text = "Winner is \(isUserWinner == true ? UserDefaults.standard.value(forKey: "name") as? String ?? "" : "PC")"
        winnerName.font = UIFont(name: "Optima Regular", size: 24) ?? .systemFont(ofSize: 18)
        
        let winnerScore = UILabel(frame: CGRect(x: 0, y: winnerName.frame.maxY + 10, width: self.view.frame.width, height: 30))
        winnerScore.text = "score: \(score)"
        winnerScore.textAlignment = .center
        winnerScore.font = UIFont(name: "Optima Regular", size: 18) ?? .systemFont(ofSize: 18)

        let returnButton = UIButton(frame: CGRect(x: self.view.midX - 100, y: self.view.frame.height - 70, width: 200, height: 40))
        returnButton.addTarget(self, action: #selector(shouldReturnMain), for:.touchUpInside)
        returnButton.setTitle("Back To Main Menu", for: .normal)
        returnButton.setTitleColor(.blue, for: .normal)
        returnButton.layer.cornerRadius = 10
        returnButton.setTitleColor(.white, for: .normal)
        returnButton.backgroundColor = .red
        returnButton.titleLabel?.font = UIFont(name: "Optima Regular", size: 18) ?? .systemFont(ofSize: 18)
        
        let backgroundView = UIImageView(frame: view.frame)
        backgroundView.contentMode = .scaleToFill
        backgroundView.image = UIImage(named: "background")
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(returnButton)
        self.view.addSubview(winnerName)
        self.view.addSubview(winnerScore)
    }
    
    @objc
    func shouldReturnMain(){
        navigationController?.popToRootViewController(animated: true)
    }
}

