//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/05.
//  Copyright © 2020 bejewel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoComposeViewModel: CommonViewModel {
    // 저장할 속성 옵셔널 타입이니깐 새 메모는 nil 편집할 내용은 tmxmfld
    private let content: String?

    // 뷰 바인딩 용 타입
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }

    // 저장
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction

    // 일반적으로 해당 액션을 뷰모델에서 처리해도 되지만
    // 아래와 같이 파라미터로 받게 되면 이전 화묜 즉 의존성을 주입하는 시점에서
    // 처리 방식을 동적으로 할 수 있음? ? ?
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content

        self.saveAction = Action<String, Void> { input in
            // 액션이 있으며 익스큐트
            if let action = saveAction {
                action.execute(input)
            }

            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }

        self.cancelAction = CocoaAction {
            // 액션이 있으며 익스큐트
            if let action = cancelAction {
                action.execute(())
            }

            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }

        super.init(title: title, scenCoordinator: sceneCoordinator, storage: storage)
    }
}
