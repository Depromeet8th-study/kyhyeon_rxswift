//
//  Memo.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/05.
//  Copyright © 2020 bejewel. All rights reserved.
//

import Foundation

struct Memo: Equatable {
    var content: String
    var insertDate: Date    // 생성 날짜
    var identity: String    // 메모 구분

    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }

    // 업데이트 내용으로 새로운 인스턴스를 만들 때 사용
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
}
