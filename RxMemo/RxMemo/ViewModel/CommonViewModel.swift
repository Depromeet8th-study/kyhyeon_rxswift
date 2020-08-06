//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/06.
//  Copyright © 2020 bejewel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    // 오류가 발생하지 x(방출하지 않는거) MainScheduler UI전용
    let title: Driver<String>
    let scenCoordinator: SceneCoordinatorType
    let storage: MemoStorageType

    // 프로퍼티를 초기화 하는 생성자
    init(title: String, scenCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        // error 발생 시 return으로 에러를 없애줌
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.scenCoordinator = scenCoordinator
        self.storage = storage
    }
}
