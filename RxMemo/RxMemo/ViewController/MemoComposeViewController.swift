//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/05.
//  Copyright © 2020 bejewel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoComposeViewModel!

    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)

        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)

        // 해당 액션을 수행할 건데 그건 viewModel의 cancelAction 이다
        cancelButton.rx.action = viewModel.cancelAction

        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 바로 활성화
        contentTextView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 해제
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
