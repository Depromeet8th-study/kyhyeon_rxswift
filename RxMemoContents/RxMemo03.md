

'#3'

Rx + MVVM + CoreData 메모장 앱



#### 씬구성

스토리보드에서는 세그웨이로 연결해서 처리

의존성 주입 코드가 복잡?

rx는 생성자를 통해 주입

의존성 주입이 단순해진다?!

씬코디네이터로 컨트롤러

기본씬은 플레이스홀더?!?! 



네비게이션 ListNav가 생성되면 릴레이셥 세그웨이에 연결 클래스가 생성

화면 전환을 씬코디네이터



ComposeNav - 수정용

뷰컨 	- 	뷰모델

MemoListViewController				-		MemoListViewModel

MemoDetailViewController			-		MemoDetailViewModel

MemoComposeViewController	 -		MemoComposeViewModel



뷰모델은 뷰컨의 속성으로 추가함.

그런 다음 뷰모델과 뷰를 바인딩 함. 

이를 수행하는 프로토콜을 생성( 동일)

ViewModelBindableType 

: 왜냐면 공통적으로 사용하니깐~ 그리고 메소드를 놓치지 않게, 뷰마다 기능이 다를 수 있으니깐

**extension** ViewModelBindableType **where** Self: UIViewController

뷰모델 속성의 실제 뷰모델을 저장

바인드 뷰모델의 메소드를 자동으로 호출하는 메소드

```swift
extension ViewModelBindableType where Self: UIViewController {
    // self.viewModel가 수정 됨으로 mutating 선언해줘야함
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        // loadView() -> loadViewIfNeeded() -> viewDidLoad()
        // TODO: 이걸 호출하는 이유가 뭐지?!
        loadViewIfNeeded()

        bundViewModel()
    }
}
```

