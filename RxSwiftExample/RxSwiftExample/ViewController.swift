//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by 이규현 on 2020/07/24.
//  Copyright © 2020 bejewel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func loadView() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.a
        @escaping
        setUI()
        setLayout()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .yellow
        return cell
    }
}

extension ViewController {

    private func setUI() {
        view.addSubview(tableView)
        tableView.delegate = self
    }

    private func setLayout() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
