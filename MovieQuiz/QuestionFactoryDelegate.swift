//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Мария Солодова on 04.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
