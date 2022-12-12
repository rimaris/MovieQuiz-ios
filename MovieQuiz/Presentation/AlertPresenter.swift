//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Мария Солодова on 04.12.2022.
//

import Foundation
import UIKit


class AlertPresenter {
    weak public var viewController: UIViewController?
    
    func showAlert(model: AlertModel) {
        guard let viewController = viewController else { return }
        
        let alert = UIAlertController(title: model.title, message: model.text, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
