//
//  LocalizedError+Extensions.swift
//  MovieQuiz
//
//  Created by Aleksandr Dugaev on 22.04.2024.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
