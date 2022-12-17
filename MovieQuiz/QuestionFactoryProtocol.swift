//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Мария Солодова on 04.12.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
    var delegate: QuestionFactoryDelegate? { get set }
}
