//
//  HomeViewController.swift
//  SubjectMock
//
//  Created by JunHyeok Lee on 2023/06/08.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: HomeViewModel
    
    init() {
        self.viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeCurrentSubject()
        subscribePassthroughSubject()
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.viewModel.appendCurrentSubject()
            self?.viewModel.sendPassthroughSubject()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                self?.viewModel.appendCurrentSubject()
                self?.viewModel.sendPassthroughSubject()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                    self?.viewModel.appendCurrentSubject()
                    self?.viewModel.sendPassthroughSubject()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                        self?.viewModel.sendCurrentSubject()
                        self?.viewModel.sendPassthroughSubject()
                    }
                }
            }
        }
    }
    
    private func subscribeCurrentSubject() {
        viewModel.currentSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { currentSubject in
                print("currentSubject: \(currentSubject)")
            })
            .store(in: &cancellables)
    }
    
    private func subscribePassthroughSubject() {
        viewModel.passthroughSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { passthroughSubject in
                print("passthroughSubject: \(passthroughSubject)")
            })
            .store(in: &cancellables)
    }
}
