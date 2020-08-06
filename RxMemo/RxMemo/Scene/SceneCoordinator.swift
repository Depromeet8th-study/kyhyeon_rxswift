//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 이규현 on 2020/08/05.
//  Copyright © 2020 bejewel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()

    // 윈도우 인스턴스
    private let window: UIWindow

    // 현재 표시되고 있는
    private var currentVC: UIViewController

    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }

    @discardableResult
    func transition(to scene: Scene, using style: TransititionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        // 실제 생성자
        let target = scene.instantiate()

        switch style {
        case .root:
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()

        case .push:
            guard let nav = currentVC.navigationController else {
                // 네비에 임베드 되어 있지 않다면
                subject.onError(TransititionError.navigationControllerMissing)
                break
            }

            nav.pushViewController(target, animated: animated)
            currentVC = target
            subject.onCompleted()

        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target

        }

        // 서브젝트를 Completable 타입으로 바꿔줌
        return subject.ignoreElements()
    }

    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransititionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransititionError.unknown))
            }
            return Disposables.create()
        }
    }


}
