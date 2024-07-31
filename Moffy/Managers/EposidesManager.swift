//
//  EposidesManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 10/04/2024.
//

import Foundation

class EposidesManager {
    static var shared = EposidesManager()
    @Published private(set) var eposides: Eposides?
}

extension EposidesManager {
    func fetch(_ idTV: String, _ seasonNumber: Int) {
        eposides = nil
        Task {
            do {
                let eposidesResponse = try await APIManager.shared.getEposodesList(idTV, seasonNumber)
                self.eposides = eposidesResponse
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
