//
//  IntroductionViewController.swift
//  Personality Quiz
//
//  Created by BP-36-201-17 on 02/02/2026.
//

import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet weak var quizStackView: UIStackView!
    @IBOutlet weak var lblQuizTitle: UILabel!
    @IBOutlet weak var lblIcon1: UILabel!
    @IBOutlet weak var lblIcon2: UILabel!
    @IBOutlet weak var lblIcon3: UILabel!
    @IBOutlet weak var lblIcon4: UILabel!
    
    var quizType: Int = 0
    var quizQuestions: [PersonalityQuizType] = []
    var selectedPersonalityQuiz : PersonalityQuizType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateIntroUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToQuizIntroduction(segue: UIStoryboardSegue)
    {
        
    }
    
    func updateIntroUI()
    {
        lblIcon1.isHidden = true;
        lblIcon2.isHidden = true;
        lblIcon3.isHidden = true;
        lblIcon4.isHidden = true;
        
        quizQuestions = personalityQuizzes.filter{$0.id == quizType}
        
        
        if ( quizQuestions.count == 0 )
        {
            lblQuizTitle.text = "What [Type] are you?"
        }
        else
        {
            lblIcon1.isHidden = false;
            lblIcon2.isHidden = false;
            lblIcon3.isHidden = false;
            lblIcon4.isHidden = false;
            selectedPersonalityQuiz = quizQuestions.first
            lblQuizTitle.text = selectedPersonalityQuiz?.title
            lblIcon1.text = selectedPersonalityQuiz?.icon1
            lblIcon2.text = selectedPersonalityQuiz?.icon2
            lblIcon3.text = selectedPersonalityQuiz?.icon3	
            lblIcon4.text = selectedPersonalityQuiz?.icon4
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if let navController = segue.destination as? UINavigationController, let questionVC = navController.topViewController as? QuestionsViewController
        {
           print("prepare for QuestionsViewController")
           questionVC.selectedQuiz = self.selectedPersonalityQuiz
         //  questionVC.questions = self.selectedPersonalityQuiz!.questions
        }
    }
}
