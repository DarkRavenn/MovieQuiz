import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate, StatisticServiceImplementationDelegate {

    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private let questionAmount: Int = 10
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        let statisticService = StatisticServiceImplementation()
        statisticService.delegate = self
        self.statisticService = statisticService
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
            questionFactory?.requestNextQuestion()
    }
    
    func didLoadDataFromServer(with errorMessage: String) {
        showNetworkError(message: errorMessage)
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    
    // MARK: - AlertPresenterDelegate
    func showAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - StatisticServiceImplementationDelegate
    func transmitting(_ statistic: String) {
        let resultAlertModel: AlertModel = AlertModel(
             title: "Этот раунд окончен!",
             text: statistic,
             buttonText: "Сыграть еще раз",
             completion: {_ in
                 self.restartGame()
             })
        alertPresenter?.requestAlert(with: resultAlertModel)
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        questionFactory?.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        self.enableButtonYesAndNo()
    }
    
    private func disableButtonYesAndNo() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func enableButtonYesAndNo() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtonYesAndNo()
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtonYesAndNo()
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionAmount)
        } else {
            imageView.layer.borderColor = UIColor.clear.cgColor
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func temp(_ statistic: String) {
        
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        
        let errorAlertModel = AlertModel(title: "Ошибка",
                               text: message,
                               buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.requestAlert(with: errorAlertModel)
    }
    
    
}
