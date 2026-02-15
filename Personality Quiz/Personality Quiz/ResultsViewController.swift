//
//  ResultsViewController.swift
//  Personality Quiz
//
//  Created by BP-36-201-17 on 02/02/2026.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var lblResultAnswer: UILabel!
    @IBOutlet weak var lblResultDefinition: UILabel!
    @IBOutlet weak var imgFinalPersona: UIImageView!
    
    var responses: [Answer]
    var selectedQuizTitle: String
    var selectedQuiz: PersonalityQuizType
    
    init?(coder: NSCoder, responses: [Answer], selectedQuiz: PersonalityQuizType)
    {
        self.responses = responses
        self.selectedQuizTitle = selectedQuiz.title
        self.selectedQuiz = selectedQuiz
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatePersonalityResult()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    func calculatePersonalityResult()
    {
        if responses.count == 0
        {
            lblResultAnswer.text = "Who Are you❓"
            lblResultDefinition.text = ""
        }
        else
        {
            let frequencyOfAnswers = responses.reduce(into: [:]) {
                (counts, answer) in counts[answer.type, default: 0] += 1
            }
            
            let frequentAnswersSorted = frequencyOfAnswers.sorted(by: { (pair1, pair2) in return pair1.value > pair2.value })
            
            let mostCommonAnswer = frequentAnswersSorted.first!.key
            
            let personaImage = selectedQuiz.images[mostCommonAnswer]
            imgFinalPersona.image = personaImage as? UIImage
            
            lblResultAnswer.text = "You are a \(mostCommonAnswer.rawValue)"
            lblResultDefinition.text = mostCommonAnswer.definition
            
            
            let result = QuizResult(
                quizType: selectedQuizTitle,
                result: lblResultAnswer.text ?? "",
                date: Date()
            )
            saveResult(result)
        }
        
    }
    func saveResult(_ result: QuizResult) {
        var results = loadResults()
        results.append(result)
        
        if let data = try? JSONEncoder().encode(results) {
            UserDefaults.standard.set(data, forKey: "quiz_results")
        }
    }
    func loadResults() -> [QuizResult] {
        guard let data = UserDefaults.standard.data(forKey: "quiz_results"),
              let results = try? JSONDecoder().decode([QuizResult].self, from: data) else {
            return []
        }
        return results
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
