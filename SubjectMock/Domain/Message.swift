//
//  Message.swift
//  SubjectMock
//
//  Created by JunHyeok Lee on 2023/06/09.
//

import Foundation

struct Message {
    let title: String
    let content: String?
    
    init(title: String, content: String? = nil) {
        self.title = title
        self.content = content
    }
}
