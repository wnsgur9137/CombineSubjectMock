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
    
    func appendCurrentSubject() {
        self.currentSubject.value.append(1)
    }
    
    func sendCurrentSubject() {
        self.currentSubject.send([1])
    }
    
    func sendPassthroughSubject() {
        self.passthroughSubject.send([1])
    }
}
