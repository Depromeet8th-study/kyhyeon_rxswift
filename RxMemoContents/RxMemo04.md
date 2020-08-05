

'#4'

Rx + MVVM + CoreData 메모장 앱



#### Coordinator



SceneCoordinatorType 

리턴 타입 Completable 

Completable에 구독자를 추가하고 화면 전환이 완료된 후에 우너한는 작업이 가능



```swift
// 서브젝트를 Completable 타입으로 바꿔줌
        return subject.ignoreElements()
```

