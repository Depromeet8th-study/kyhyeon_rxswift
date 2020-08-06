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

class MemoListViewModel: CommonViewModel {
    // 테이블뷰와 바인딩 할 수 있는 속성 - 왜 Read-Only Computed Properties일까?
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }

}
