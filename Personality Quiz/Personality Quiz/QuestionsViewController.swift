//
//  QuestionsViewController.swift
//  Personality Quiz
//
//  Created by JAGmer J on 06/02/2026.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var multipleAnswerStackView: UIStackView!
    @IBOutlet weak var singleAnswerStackView: UIStackView!
    
    @IBOutlet weak var rangedAnswerStackView: UIStackView!
    @IBOutlet weak var rangedSlider: UISlider!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    
    
    var questionIndex: Int = 0
    var quesionsTimeInSeconds: Int = 0
    var selectedQuiz : PersonalityQuizType!
    var shuffledQuestions : [Question]! = []
    var currentQuestion : Question!
    var answersChosen: [Answer] = []
    var selectedMultipleAnswers : [Int] = []
    var questionCountDownTimer: Timer?
    var remainingSeconds: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(selectedQuiz.title)
        
        shuffledQuestions = selectedQuiz.questions.shuffled()
        print("Total Questions \(shuffledQuestions.count)")
        updateUI()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton)
    {
        let currentAnswers = currentQuestion.answers
        answersChosen.append(currentAnswers[sender.tag])
        
        print(currentAnswers[sender.tag].text)
        
       /* switch sender
        {
            case singleButton1:
                answersChosen.append(currentAnswers[0])
                break;
            case singleButton2:
                answersChosen.append(currentAnswers[1])
                break;
            case singleButton3:
                answersChosen.append(currentAnswers[2])
                break;
            case singleButton4:
                answersChosen.append(currentAnswers[3])
                break;
            default:
                break;
        }*/
        
        nextQuestion()
    }
    @objc func multipleAnswerSwitchValueChanged(_ sender: UISwitch) {

        if sender.isOn
        {
            if !selectedMultipleAnswers.contains(sender.tag) {
                selectedMultipleAnswers.append(sender.tag)
                    }
        } else
        {
            selectedMultipleAnswers.removeAll { $0 == sender.tag }
        }

        print("Selected count:", selectedMultipleAnswers.count)
    }
    @IBAction func multipleAnswerButtonPressed()
    {
        let currentAnswers = currentQuestion.answers
        if(selectedMultipleAnswers.count == 0)
        {
            print("tstsViewController: Line 103\nDEBUG: User did not chose an answer.")
            
            let alert = UIAlertController(title: "No answer chosen!", message: "Please Choose an option.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        for i in 0..<selectedMultipleAnswers.count
        {
            answersChosen.append( currentAnswers[selectedMultipleAnswers[i]])
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed()
    {
        let currentAnswers = currentQuestion.answers
        let index = Int(round(rangedSlider.value * Float (currentAnswers.count - 1)))
        
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
    func nextQuestion()
    {
        questionCountDownTimer?.invalidate() // stop timer if running
        questionIndex += 1
        print("nextQuestion \(questionIndex):")
        if(questionIndex < shuffledQuestions.count)
        {
            updateUI()
        }
        else
        {
            
           	 performSegue(withIdentifier: "Results", sender: nil)
        }
    }
    
    func updateUI()
    {
        print("Question \(questionIndex):")
        
        singleAnswerStackView.isHidden = true;
        multipleAnswerStackView.isHidden = true;
        rangedAnswerStackView.isHidden = true;
        let quizImage = selectedQuiz.images.shuffled().first
        imgBackground.image = quizImage?.value
        
        questionCountDownTimer?.invalidate() // stop timer if running
        
        navigationItem.title = "Question \(questionIndex + 1)"
       
        currentQuestion = shuffledQuestions[questionIndex]
        lblQuestion.text = currentQuestion.text
        
        let shuffledImages = selectedQuiz.images.values.compactMap {$0}.shuffled()
        
        if let image = shuffledImages.first
        {
            imgBackground.image = image
        }
        
        // shuflle answers for single- and multiple-answer questions.
        // for ranged questions, answers need to maintain thier orders
        if currentQuestion.type != .ranged
        {
            currentQuestion.answers.shuffle()
        }
        
        
        
        let currentAnswers = currentQuestion.answers
            
        let totalProgress = Float(questionIndex) / Float(shuffledQuestions.count)
        
        lblQuestion.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type
        {
        case .single:
            updateSingleStack(using: currentAnswers)
        case .multiple:
            updateMultipleStack(using: currentAnswers)
        case .ranged:
            updateRangedStack(using: currentAnswers)
        }
        
        startTimer(timeInSeconds: currentQuestion.timeInSeconds)
    }
    
    func startTimer(timeInSeconds: Int) {
        
        questionCountDownTimer?.invalidate()   // stop previous timer if running
        remainingSeconds = timeInSeconds
        timerLabel.text = "\(remainingSeconds)"
        timerLabel.isHidden = false
        questionCountDownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.remainingSeconds -= 1
            self.timerLabel.text = "\(self.remainingSeconds)"

            if self.remainingSeconds <= 0 {
                timer.invalidate()
                self.questionTimesUp()
            }
        }
    }
    
    func questionTimesUp() {
        nextQuestion()
    }
    func updateSingleStack(using answers: [Answer])
    {
        clearStackView(singleAnswerStackView)
        
        singleAnswerStackView.isHidden = false;
        
        let answersCount = answers.count
        
        for i in 0..<answersCount
        {
            let answer = answers[i]
            var buttonconfiguration = UIButton.Configuration.filled()
            buttonconfiguration.title = answer.text
            buttonconfiguration.buttonSize = .medium
            
            let button = UIButton(configuration: buttonconfiguration, primaryAction: nil)
            button.tag = i
            button.addTarget(self, action: #selector(singleAnswerButtonPressed), for: .touchUpInside)
            singleAnswerStackView.addArrangedSubview(button)
        }
        // Do any additional setup after loading the view.
    }
    
   
    
    func updateMultipleStack(using answers: [Answer])
    {
        clearStackView(multipleAnswerStackView)
        multipleAnswerStackView.isHidden = false;
        
        selectedMultipleAnswers = [] // clear the answers array
         
         let answersCount = answers.count
        
        
         
        for i in 0..<answersCount
        {
            let answer = answers[i]
            let answerLabel = UILabel()
            let answerSwitch = UISwitch()
            
            answerLabel.text = answer.text
            
            answerSwitch.tag = i
            answerSwitch.addTarget(self, action: #selector(multipleAnswerSwitchValueChanged), for: .valueChanged)

            let answerStackView = UIStackView(arrangedSubviews: [answerLabel, answerSwitch])
            answerStackView.axis = .horizontal
            answerStackView.alignment = .center
            answerStackView.spacing = 8
            multipleAnswerStackView.addArrangedSubview(answerStackView)
            
         }
       
        var buttonconfiguration = UIButton.Configuration.filled()
        buttonconfiguration.title = "Submit Answer"
        buttonconfiguration.buttonSize = .medium
        
        let submitMultipleAnswerButton = UIButton(configuration: buttonconfiguration, primaryAction: nil)
        
        submitMultipleAnswerButton.addTarget(self, action: #selector(multipleAnswerButtonPressed), for: .touchUpInside)
        multipleAnswerStackView.addArrangedSubview(submitMultipleAnswerButton)
    }
    
    func clearStackView(_ stackView: UIStackView) {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func updateRangedStack(using answers: [Answer])
    {
        rangedAnswerStackView.isHidden = false;
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }
    
    @IBSegueAction func showResultsSegue(_ coder: NSCoder) -> ResultsViewController? {
        return ResultsViewController(coder: coder, responses: answersChosen, selectedQuiz: selectedQuiz)
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
