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
    }
}
