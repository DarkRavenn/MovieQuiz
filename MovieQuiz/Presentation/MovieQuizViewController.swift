import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        
        activityIndicator.hidesWhenStopped = true
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
    
    // MARK: Public methods
    
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
        let title = "Что-то пошло не так("
        let buttonText = "Попробовать еще раз"
        
        let model = AlertModel(title: title, message: message, buttonText: buttonText) { [weak self] in
            guard let self = self else { return }
            
            presenter.skipCurrentQuestion()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    // MARK: - Private methods
    
    private func switchButton(IsEnabled: Bool) {
        yesButton.isEnabled = IsEnabled
        noButton.isEnabled = IsEnabled
    } 
}
