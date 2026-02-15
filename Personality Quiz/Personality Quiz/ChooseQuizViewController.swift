//
//  ChooseQuizViewController.swift
//  Personality Quiz
//
//  Created by BP-36-201-18 on 05/02/2026.
//

import UIKit

class ChooseQuizViewController: UIViewController {

    @IBOutlet weak var selectQuizStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for quiz in personalityQuizzes
        {
            
            var buttonconfiguration = UIButton.Configuration.tinted()
            buttonconfiguration.title = quiz.title
            buttonconfiguration.buttonSize = .large
            
            let button = UIButton(configuration: buttonconfiguration, primaryAction: nil)
            button.tag = quiz.id
            button.addTarget(self, action: #selector(enterQuizFromButton), for: .touchUpInside)
            selectQuizStackView.addArrangedSubview(button)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func enterQuizFromButton(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "enterQuizSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "enterQuizSegue", let destinationVC = segue.destination as? IntroductionViewController, let buttonTapped = sender as? UIButton
        {
            destinationVC.quizType = buttonTapped.tag
            print("button tag: \(buttonTapped.tag)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
