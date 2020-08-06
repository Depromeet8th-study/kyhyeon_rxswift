

'#6'

Rx + MVVM + CoreData 메모장 앱



#### MemoComposeViewModel



Action 라이브러리의 사용

추상화 나머지는 쫌 다시 MemoComposeViewController - MemoComposeViewModel 보면서



입력 값으로 스트링이고 리턴 값으로 보이드!

Action<String, Void>

CocoaAction  == <Void, Void> 가 생략

타입이 안맞을 떈

asObservable 리턴 값은 Observable<Element>  
map { _ in } 매핑 하여 Void로 맞춤

```swift
return sceneCoordinator.close(animated: true).asObservable().map { _ in }
```