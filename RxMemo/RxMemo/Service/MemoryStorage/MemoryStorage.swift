//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/05.
//  Copyright © 2020 bejewel. All rights reserved.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {

    // 더미 데이터
    private var list = [
        Memo(content: "냐니", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "니냐뇨", insertDate: Date().addingTimeInterval(-20)),
    ]

    // lazy가 아닌 경우 BehaviorSubject 마지막 데이터가 호출 됨으로
    // lazy를 통해 사용 될때 초기값을 list로 유지하기 위함
    private lazy var store = BehaviorSubject<[Memo]>(value: list)

    // 프로토콜에 해놨는데 왜 또하는거지?
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        list.insert(memo, at: 0)
        store.onNext(list)

        return Observable.just(memo)
    }

    @discardableResult
    // 외부 클래스에서는 memoList() 통해 서브젝트 store에 접근함
    func memoList() -> Observable<[Memo]> {
        return store
    }

    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)

        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
            list.insert(updated, at: index)
        }

        store.onNext(list)

        return Observable.just(updated)
    }

    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }

        store.onNext(list)

        return Observable.just(memo)
    }
}
