import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter?
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButtons()
        
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter.viewController = self
        
        showLoadingIndicator()
    }

    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter?.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter?.noButtonClicked()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertViewModel = AlertModel(title: "Что-то пошло не так(", text: message, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.showLoadingIndicator()
            self.presenter?.loadData()
        }
        alertPresenter.showAlert(model: alertViewModel)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        disableImageBorder()
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
        enableButtons()
    }

    func show(quiz result: QuizResultsViewModel) {
        let alertViewModel = AlertModel(title: result.title, text: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.presenter?.restartGame()
        }
        alertPresenter.showAlert(model: alertViewModel)
    }
    
    
    private func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func disableImageBorder() {
        imageView.layer.borderWidth = 0
    }
}
    
