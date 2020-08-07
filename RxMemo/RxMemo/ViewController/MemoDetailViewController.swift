//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/05.
//  Copyright © 2020 bejewel. All rights reserved.
//

import UIKit

class MemoDetailViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoDetailViewModel!

    @IBOutlet weak var listTableView: UITableView!

    @IBOutlet weak var deleteButton: UIBarButtonItem!

    @IBOutlet weak var editButton: UIBarButtonItem!

    @IBOutlet weak var shareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)

        viewModel.contents
            .bind(to: listTableView.rx.items) { tableview, row, value in
                switch row {
                case 0:
                    let cell = tableview.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableview.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell

                default:
                    fatalError()
                }
        }
        .disposed(by: rx.disposeBag)
        
        // 새로운 바 버튼 생성
        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)

        // 뷰모델에 저장되어 있는 타이틀과 버튼 타이틀을 바인딩
        // 뷰모델에 저장되어 있는 타이틀이 title: Driver<String> 형태임으로 바인딩을 통해 해야함.
        viewModel.title
            .drive(backButton.rx.title)
            .disposed(by: rx.disposeBag)
        backButton.rx.action = viewModel.popAcion

        // 기본 액션은 대체 되지 않음
        // navigationItem.backBarButtonItem = backButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
}
