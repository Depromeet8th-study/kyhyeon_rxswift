//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/05.
//  Copyright © 2020 bejewel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoListViewModel: CommonViewModel {
    // 테이블뷰와 바인딩 할 수 있는 속성 - 왜 Read-Only Computed Properties일까?
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }

    // 입력 값으로 메모 업뎃
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            // 리턴 값은 Void라 맵 연산자로 매핑 .map { _ in }
            return self.storage.update(memo: memo, content: input).map { _ in }
        }
    }

    // CocoaAction 입력값도 없고 리턴 값도 없는거
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map { _ in }
        }
    }


    func makeCreateAction() -> CocoaAction {

        return CocoaAction { _ in
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.scenCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))

                    let composrScene = Scene.compose(composeViewModel)

                    return self.scenCoordinator.transition(to: composrScene, using: .modal, animated: true).asObservable().map { _ in }
            }
        }
    }

}
