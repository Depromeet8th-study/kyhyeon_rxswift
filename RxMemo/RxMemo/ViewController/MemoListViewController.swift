//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/05.
//  Copyright © 2020 bejewel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoListViewModel!

    @IBOutlet weak var listTableView: UITableView!

    @IBOutlet weak var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)

        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) {
                row, memo, cell in
                cell.textLabel?.text = memo.content
        }
        .disposed(by: rx.disposeBag)

        addButton.rx.action = viewModel.makeCreateAction()

        // Rx 제공하는 선택한 인덱스 패스가 필요할 때 itemSelected
        // Rx 제공하는 선택한 데이터가 필요할땐 modelSelected
        // 두 요소를 zip - 두 데이터가 모두 들어오는 시점에 튜플 형태로 데이터를 방출
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            // 선택 되면 바로 해제
            .do(onNext: { [unowned self] (_, idx) in
                self.listTableView.deselectRow(at: idx, animated: true)
            })
            // Memo 데이터를
            .map { $0.0 }
            // viewModel.detailAction.inputs 전달
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
    }
}
