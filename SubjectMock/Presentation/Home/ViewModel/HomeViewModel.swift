//
//  HomeViewModel.swift
//  SubjectMock
//
//  Created by JunHyeok Lee on 2023/06/08.
//

import Foundation
import Combine

final class HomeViewModel {
    
    private(set) var currentSubject: CurrentValueSubject<[Int], Never>
    private(set) var passthroughSubject: PassthroughSubject<[Int], Never>
    
    init() {
        self.currentSubject = CurrentValueSubject([])
        self.passthroughSubject = PassthroughSubject()
    }
    
    func stringToInt(with text: String) -> Int? {
        guard let converted = Int(text) else {
            return nil
        }
        return converted
    }
    
    func currentSubject(append content: Int) {
        self.currentSubject.value.append(content)
    }
    
    func currentSubject(send contents: [Int]) {
        self.currentSubject.send(contents)
    }
    
    func currentSubject(injection contents: [Int]) {
        self.currentSubject.value = contents
    }
    
    func passthroughSubject(send contents: [Int]) {
        self.passthroughSubject.send(contents)
    }
}
