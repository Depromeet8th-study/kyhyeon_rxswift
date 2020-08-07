

'#8'

Rx + MVVM + CoreData 메모장 앱



씬 코디네이터를 구현 할때 가장 주의 해야하는 것은

뷰 컨트롤러를 임베드 하고 있는 컨트롤러가 아닌

실제 화면에 표시되어 있는 뷰컨트롤러 기준으로 전환을 처리해야함.



SceneCoordinator 현재 구현 코드

```swift
 func transition(to scene: Scene, using style: TransititionStyle, animated: Bool) -> Completable {
   			/*
   			 ...
				*/
        case .push:
            /*
             currentVC에 네비게이션컨트롤러가 찍힘
             Scene instantiate .list의 리턴 값은 nav
             */
```



```swift
extension UIViewController {
    /*
     실제로 화면에 표시되어 있는 화면을 리턴하는 속성
     현재는 네비게이션컨트롤러만 고려함.
     탭바 컨트롤이나 다른 컨테이너 컨트롤러라면 해당에 맞게 수정해야함
     */
    var sceneViewController: UIViewController {
        return self.children.first ?? self
    }
}
```



메모 리스트 - 메모 선택 -메모 상세 - 네비게이션 컨트롤러가 제공하는 뒤로가기 클릭 - 다시 메모 선택 - 메모 상세 이동 불가

네비게이션 컨트롤러가 제공하는 뒤로가기는 SceneCoordinator와 연관없음

currentVC는 업데이트 되지 않음

SceneCoordinator - subject.onError로 종료 됨

```swift
guard let nav = currentVC.navigationController else {
                // 네비에 임베드 되어 있지 않다면
                subject.onError(TransititionError.navigationControllerMissing)
                break
            }
```



#### 교체하는 경우

네비게이션 뎁스가 들어가는 경우
백버튼을 대체하는 코드는 부모 컨트롤러에서 구현
바 버튼 아이템을 설정하는 코드는 해당 뷰컨트롤러에서 구현

```swift
// 새로운 바 버튼 생성
        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)

        // 뷰모델에 저장되어 있는 타이틀과 버튼 타이틀을 바인딩
        // 뷰모델에 저장되어 있는 타이틀이 title: Driver<String> 형태임으로 바인딩을 통해 해야함.
        viewModel.title
            .drive(backButton.rx.title)
            .disposed(by: rx.disposeBag)
        backButton.rx.action = viewModel.popAcion

        // 기본 액션은 대체 되지 않음
//        navigationItem.backBarButtonItem = backButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
```



#### 동일한 디자인의 백버튼과 동일한 애니메이션을 원하는 경우

MemoDetailViewController의 UIBarButtonItem 생성 바인딩 제거

SceneCoordinator

https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate



**UINavigationControllerDelegate**

역활 : 탐색 컨트롤러가보기 컨트롤러의보기 및 탐색 항목 속성을 표시하기 직전에 호출됩니다

```swift
func navigationController(UINavigationController, willShow: UIViewController, animated: Bool)
```

같은 기능으로 rxcocoa가 rx.willShow로 제공함

**SceneCoordinator** - 델리게이트로 처리

```swift
// 델리게이트 메소드가 호출되는 시점마다 Next이벤트를 방출하는 속성
            // UINavigationControllerDelegate.navigationController(_:willShow:animated:)
            nav.rx.willShow
                .subscribe(onNext: { [unowned self] evt in
                    self.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: bag)

```

