import UIKit

final class MovieQuizViewController: UIViewController {

    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var statisticService: StatisticService?
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        statisticService = StatisticServiceImplementation()
        
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
                
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
        let message = presenter.makeResultMessage()
        
        let model = AlertModel(title: title, message: message, buttonText: buttonText) { [weak self] in
            guard let self = self else { return }
            
            presenter.restartGame()
        }
        alertPresenter.show(in: self, model: model)
        
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
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
    
    
    func showNetworkError(message: String) {
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
            
            presenter.restartGame()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    private func switchButton(IsEnabled: Bool) {
        yesButton.isEnabled = IsEnabled
        noButton.isEnabled = IsEnabled
    } 
}
