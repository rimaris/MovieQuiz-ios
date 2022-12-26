import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private let presenter = MovieQuizPresenter()
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButtons()
        
        var questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        alertPresenter.viewController = self
        presenter.viewController = self
        
        questionFactory.loadData()
        showLoadingIndicator()
    }
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter.noButtonClicked()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertViewModel = AlertModel(title: "Ошибка", text: message, buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            self.questionFactory?.loadData()
            self.showLoadingIndicator()
        }
        alertPresenter.showAlert(model: alertViewModel)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            let accuracyStr = String(format: "%.2f", statisticService.totalAccuracy * 100)
            
            let formattedDate = statisticService.bestGame.date.dateTimeString
                
            let text = """
            Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(formattedDate))
            Средняя точность: \(accuracyStr)%
            """
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
       } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
       }
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
        enableButtons()
    }

    func show(quiz result: QuizResultsViewModel) {
        let alertViewModel = AlertModel(title: result.title, text: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.presenter.resetQuestionIndex()

            self.correctAnswers = 0

            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter.showAlert(model: alertViewModel)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    private func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
    
