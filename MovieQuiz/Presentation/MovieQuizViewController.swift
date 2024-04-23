import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
//    private var correctAnswers = 0 // надо будет удалить
    private var questionFactory: QuestionFactoryProtocol? // надо будет удалить
    
    private var statisticService: StatisticService?
    
    private var alertPresenter = AlertPresenter()
    
    private let presenter = MovieQuizPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        questionFactory?.loadData()
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
        presenter.viewController = self
                
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didLoadImageFromServer(with error: Error) {
        showErrorLoadImage(with: error)
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        switchButton(IsEnabled: false)
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        switchButton(IsEnabled: false)
        presenter.yesButtonClicked()
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        self.switchButton(IsEnabled: true)
        hideLoadingIndicator()
    }
    
    func showResultQuiz() {
        let title = "Этот раунд окончен!"
        let buttonText = "Сыграть ещё раз"
        let message = getStatistic()
        
        let model = AlertModel(title: title, message: message, buttonText: buttonText) { [weak self] in
            guard let self = self else { return }
            
            presenter.restartGame()
        }
        alertPresenter.show(in: self, model: model)
        
    }
    
    func getStatistic() -> String {
        var statisticMessage = ""
        if let statisticService = statisticService {
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
            
            let bestGame = statisticService.bestGame
            
            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            statisticMessage = resultMessage
        }
        return statisticMessage
    }
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()

    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func hideBorderPoster() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let title = "Ошибка"
        let buttonText = "Попробовать еще раз"
        
        let model = AlertModel(title: title, message: message, buttonText: buttonText) { [weak self] in
            guard let self = self else { return }
            
            presenter.restartGame()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    private func showErrorLoadImage(with error: Error) {
        hideLoadingIndicator()
        let title = "Ошибка"
        let message = "Изображение не загруженно: \n \(error)"
        let buttonText = "Попробовать еще раз"
        
        let model = AlertModel(title: title, message: message, buttonText: buttonText) { [weak self] in
            guard let self = self else { return }
            
            questionFactory?.requestNextQuestion()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    private func switchButton(IsEnabled: Bool) {
        yesButton.isEnabled = IsEnabled
        noButton.isEnabled = IsEnabled
    } 
}
