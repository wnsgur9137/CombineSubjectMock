//
//  HomeViewController.swift
//  SubjectMock
//
//  Created by JunHyeok Lee on 2023/06/08.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    fileprivate class ActionButton: UIButton {
        init(title: String) {
            super.init(frame: .zero)
            self.setTitle(title, for: .normal)
            self.setTitleColor(.label, for: .normal)
            self.backgroundColor = .systemGray5
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor(ciColor: .black).cgColor
            self.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
            self.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    private let inputDataTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor(ciColor: .black).cgColor
        textField.placeholder = "추가할 데이터(Int)를 넣어주십시오"
        return textField
    }()
    
    private let currentValueSubjectTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CurrentValueSubject"
        label.textColor = .label
        return label
    }()
    
    private let currentValueSubjectButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8.0
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let passthroughSubjectTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PassthroughSubject"
        label.textColor = .label
        return label
    }()
    
    private let passthroughSubjectButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8.0
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
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
        self.view.backgroundColor = .white
        
        configureCurrentValueSubjectStackView()
        configurePassthroughSubjectStackView()
        addSubviews()
        setupLayoutConstraints()
        
        subscribeCurrentSubject()
        subscribePassthroughSubject()
    }
    
    private func getInputDataTextField() -> Int? {
        guard let content = inputDataTextField.text else {
            let notEnterContentError = Message(title: "추가할 내용을 입력해주십시오.")
            self.showAlert(with: notEnterContentError)
            return nil
        }
        guard let convertedCotnent = self.viewModel.stringToInt(with: content) else {
            let invaliedMessage = Message(title: "숫자만을 입력해주십시오.")
            self.showAlert(with: invaliedMessage)
            return nil
        }
        return convertedCotnent
    }
    
    private func configureCurrentValueSubjectStackView() {
        let appendCurrentSubjectButton = ActionButton(title: "Append")
        appendCurrentSubjectButton.addAction(
            UIAction { [weak self] _ in
                if let content = self?.getInputDataTextField() {
                    self?.viewModel.currentSubject(append: content)
                }
            },
            for: .touchUpInside
        )
        let sendCurrentSubjectButton = ActionButton(title: "Send")
        sendCurrentSubjectButton.addAction(
            UIAction { [weak self] _ in
                if let content = self?.getInputDataTextField() {
                    self?.viewModel.currentSubject(send: [content])
                }
            },
            for: .touchUpInside
        )
        let injectionCurrentSubjectButton = ActionButton(title: "Injection")
        injectionCurrentSubjectButton.addAction(
            UIAction { [weak self] _ in
                if let content = self?.getInputDataTextField() {
                    self?.viewModel.currentSubject(injection: [content])
                }
            },
            for: .touchUpInside
        )
        
        [
            appendCurrentSubjectButton,
            sendCurrentSubjectButton,
            injectionCurrentSubjectButton
        ].forEach { currentValueSubjectButtonStackView.addArrangedSubview($0) }
    }
    
    private func configurePassthroughSubjectStackView() {
        let sendPassthroughSubjectButton = ActionButton(title: "Send\nPassthroughSubject")
        sendPassthroughSubjectButton.addAction(
            UIAction { [weak self] _ in
                if let content = self?.getInputDataTextField() {
                    self?.viewModel.passthroughSubject(send: [content])
                }
            },
            for: .touchUpInside
        )
        
        [
            sendPassthroughSubjectButton
        ].forEach { passthroughSubjectButtonStackView.addArrangedSubview($0) }
    }
}

// MARK: - Binding
extension HomeViewController {
    private func subscribeCurrentSubject() {
        viewModel.currentSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { currentSubject in
                self.resultLabel.text = String(describing: currentSubject)
            })
            .store(in: &cancellables)
    }
    
    private func subscribePassthroughSubject() {
        viewModel.passthroughSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { passthroughSubject in
                self.resultLabel.text = String(describing: passthroughSubject)
            })
            .store(in: &cancellables)
    }
}

extension HomeViewController {
    private func showAlert(with message: Message) {
        let alert = UIAlertController(title: message.title, message: message.content, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Layout
extension HomeViewController {
    private func addSubviews() {
        self.view.addSubview(contentView)
        contentView.addSubview(inputDataTextField)
        contentView.addSubview(currentValueSubjectTitleLabel)
        contentView.addSubview(currentValueSubjectButtonStackView)
        contentView.addSubview(passthroughSubjectTitleLabel)
        contentView.addSubview(passthroughSubjectButtonStackView)
        contentView.addSubview(resultLabel)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            inputDataTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            inputDataTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            inputDataTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.7),
            
            currentValueSubjectTitleLabel.topAnchor.constraint(equalTo: inputDataTextField.bottomAnchor, constant: 32.0),
            currentValueSubjectTitleLabel.centerXAnchor.constraint(equalTo: inputDataTextField.centerXAnchor),
            
            currentValueSubjectButtonStackView.topAnchor.constraint(equalTo: currentValueSubjectTitleLabel.bottomAnchor, constant: 8.0),
            currentValueSubjectButtonStackView.centerXAnchor.constraint(equalTo: inputDataTextField.centerXAnchor),
            
            passthroughSubjectTitleLabel.topAnchor.constraint(equalTo: currentValueSubjectButtonStackView.bottomAnchor, constant: 24.0),
            passthroughSubjectTitleLabel.centerXAnchor.constraint(equalTo: inputDataTextField.centerXAnchor),
            
            passthroughSubjectButtonStackView.topAnchor.constraint(equalTo: passthroughSubjectTitleLabel.bottomAnchor, constant: 8.0),
            passthroughSubjectButtonStackView.centerXAnchor.constraint(equalTo: inputDataTextField.centerXAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: passthroughSubjectButtonStackView.bottomAnchor, constant: 32.0),
            resultLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            resultLabel.centerXAnchor.constraint(equalTo: inputDataTextField.centerXAnchor),
        ])
    }
}
