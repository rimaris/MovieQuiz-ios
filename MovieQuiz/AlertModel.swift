//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Мария Солодова on 04.12.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    let completion: () -> Void
}
