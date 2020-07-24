# kyhyeon_rxswift
rxswift 스터디 내용 정리

[Chapter 1. Hellow RxSwift](/Chapter/Chapter1_Hellow_RxSwift.md)





###Chapter 1. Hellow RxSwift

**코코아 프레임워크에서의 비동기 처리**

- NotificationCenter
- delegate pattern
- Grand Central Dispatch 
  `DispatchQueue.main.async`
- Closures 
  `var handler: (() -> Void)?`, `@escaping`



**비동기식 프로그래밍 용어**

- State, and specifically, shared mutable state

  - State: 상태
  - specifically: 특별한?!
  - shared mutable state: 공유하는 불변의 객체

  ```
  RxSwift는 비동기 구성요성을 공유 할때, 상태를 관리 할 때가 중요한 포인트
  ```

  

- Imperative(명령형) programming

  - 명령형 프로그램은 "엎드려!", "죽은척해" 같이 명령 코드를 사용하여 앱에게 정확히 뭘해야하는지 알려준다

  - 아래의 코드의 경우 순차적으로 동작하면 아무 이상이 없지만
    공유된 돌연변이 상태, 여러 곳에서 접근하여 사용하는 경우 꼬임, 문제가 발생하여
    원하는 동작이 발생할 수 있다

    ```swift
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
    
      setupUI()
      connectUIControls()
      createDataSource()
      listenForChanges()
    }
    
    ```

  

- Side effects

  - 위 두가지 shared mutable state, 명령적 프로그램의 부작용, 즉 사이드 이펙트는
    - 현재 범위를 벗어난 [ { } 스코프 ], 예측 불가능한 상태
    - ex) 내가 원하는 건 해당 뷰의 카운터만 변경 시키는 부분인데, 추가로 다른영역을 Updata를 진행하여,
      내가 예측하지 못한 상태가 되는 부분
    - 각 코드가, 어떤 사이드이펙드를 발생시킬 수 있는지, 결과값만 발생시키는 지 정확히 인지하고 있는것이 중요
  - RxSwift는 이러한 이슈를 추적 가능하지롱 ?!?!?!?!?!



-  Declarative(선언형) code

  - 명령형 프로그램은 상태 변화가 자유롭고, 함수형 코드에서는 사이드 이펙드가 없다

  - 불변 데이터로 작업하고, 순차적인 결과적인 방식으로 코드를 실행 할 수 있다

    

- Reactive systems

  - Responsive: UI를 항상 최신 상태(State)
  - Resilient: 유연한 오류 복구
  - Elastic: 다양한 워크로드를 처리, lazy pull-driven data 수집, 이벤트 조절, 리소드 구현
    ?? 뭔소리: 다양하게 데이터를 처리 할 수 있다는건가?
  - Message driven: 메시지 기반의 아키텍처를 사용하여 클래스의 라이프 사이클과 구현을 분히

  

  

**여기까지 체크사항 **

- Message Driven : Message Driven 아키텍처는 반응형의 기초!
  responsiveness가 매우 중요 포인트

  

  <img src="/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200724123045807.png" alt="image-20200724123045807" style="zoom:50%;" />

- 왜냐면 세상은 비동기적! 앱도 웹도 비동기
  아래 처럼 뭔가 액션은 동시 다발적으로 할 수 있기 때문에 하나하나 기다려서 처리하기엔 
  내가 속이 터진다.
  Message Driven는 결국 시간, 공간에서 사용자를 분리하는 비동기 경계를 처리하는?! 

  ```
  월드)
  - 식당에 간다
  - 주문을 한다
  - 테이블로 간다
  - 밖에 나가서 담배를 핀다
  - 식당에 돌아와서 메뉴를 받는다
  - 먹는다
  - 먹으면서 핸드폰을 본다 (만지작 반지작)
  
  앱) 
  - 인스타그램을 킨다
  - 이미지가 로딩이 된다
  - 로딩을 기다릴 수 없다, 스크롤를 한다
  - 뭐야 피드?를 누른다
  - 좋아요를 누른다 
  - 댓글를 쓴다
  - 뒤로 간다
  ```



- 결론: 지속적으로 UX를 제공하기 위해 모든 사용자 에 빠르게 반응하고 제공 해야하니깐 너도 RxSwift 쓰라!

  

--------



**Foundation of RxSwift**

https://rxmarbles.com/ 마블다이어그램을 보라!

Rx는 observables, operators, schedulers 세 가지로 구성되어 있다능!

#### Observables (라디오)

비동기적으로 발생하는 데이터(불변)를 데이터스트림(**Observable Sequences**)으로 전달 할 수 있는 기능!

ex) 내 라디오에서는 "라, 라라!, 랄라랄!, 라라, 라라라 ..... 라라라라" 내맘대로 송신하고 있으니깐 들을 사람 들으세요

- A next event: 새로운 이벤트가 "랄랄!"이 추가 되었습니다, 이벤트 구독자(수신자)에게 전달

- A completed event: 모든 이벤트가 종료되었습니다, 완료 이벤트르 전달

- An error event: 에러가 발생했습니다. 에러 이벤트 전달

  

- **Finite(유한성) observable sequences**

  - 0, 1 과 같이 이분법 적인 것 들 
    ex) API가 정상 응답으로 떨어지냐 아니면 서버에러인가!

    ```swift
    API.download(file: "http://www...")
      .subscribe(onNext: { data in
        ... append data to temporary file
      },
      onError: { error in
        ... display error to user
      },
      onCompleted: {
        ... use downloaded file
      })
    ```

  

- **Infinite**(무한성) observable sequences

  - UI 이벤트(터치 이벤트)와 같이 지속적인 것들

    ```swift
    followBtn.rx
        .controlEvent(.touchUpInside)
        .throttle(TagDimens.CLICK_TIME_INTERVAL, latest: false, scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.eventFollowBtn?()
        })
        .disposed(by: disposeBag)
    ```



**여기까지 체크사항 **



------

####Operators (연산자)

observable sequences를 통해 들어오는 데이터를 어떻게 처리 할지를 해주는 것들의 집합
아래 흔히 쓰이는 `throttle` 도 하나의 Operators

해당 링크에 연산자는 겁나리 많으니깐 그때 그때 필요한거 찾아서 쓰긔
http://reactivex.io/documentation/ko/operators.html

```swift
followBtn.rx
    .controlEvent(.touchUpInside)
    .throttle(TagDimens.CLICK_TIME_INTERVAL, latest: false, scheduler: MainScheduler.instance)
    .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.eventFollowBtn?()
    })
    .disposed(by: disposeBag)
```



---

####Schedulers

아래와 같이 이미 사전에 정의된 스케줄러와 제공 되어 자동적으로 쓰레드에서 알아서 처리해준다
RxSwift 버전이 올라감에 따라 Operators 메소드 중에서는
`scheduler: MainScheduler.instance` 같이 명시해줘야하는 부분도 있다.
대게 UI의 경우 `MainScheduler.instance`ㅇㅔ서 처리

![image-20200724143049122](/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200724143049122.png)



----



#### App architecture

RxSwift는 아키텍처와 관계없이 이벤트, 비동기 데이터 시퀀스, 통신 처리를 다루므로 기존에 앱 아키텍쳐에 영향을 주지 않음. RxSwift는 단방향 데이터 흐름 아키텍처를 구현하는 데에도 매우 유용



**🙌여기서 체크**

- 데이터 바인딩
  모델 데이터를 UI에 반영하는 흐름?!
  데이터 바인딩은 KVO, Delegate, RxSwift, Property Observer 등을 사용함.

- 양방향 데이터 흐름

  모델 데이터를 UI에 전달하고 특정 이벤트 시 모델에 데이터를 갱신

  ```swift
  class model { 
    var text = "메롱"
  }
  
  class xxxVC {
    label.text = model.text
    
    func save() {
      model.text = label.text
    }
  }
  ```

  

- 단방향 데이터 흐름
  단순하게 모델 데이터를 UI에 전달

  ```swift
  class model { 
    var text = "메롱"
  }
  
  class xxxVC {
    label.text = model.text
  }
  ```



Rx의 시발점은 마이크로소프트의 MVVM 아키텍처는 데이터 바인딩을 제공하는 플랫폼에서 생성된 이벤트 중심 소프트웨어를 위해 시작되었다. 그래서 일반적으로 MVVM 아키텍처와 잘 어울린다.
왜냐면, ViewModel 통해 Observable<T> propertie를 제공 할 수 있어 VC에 바인딩 하기가 쉽다.

![image-20200724150159183](/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200724150159183.png)



----



#### RxCocoa

RxSwift는 반응형을 Swift에서 쓸수 있게 제공하는 라이브러리.
RxCocoa는 코코아프레임워크에서 Rx를 제공하는 라이브러리!
UIKit 객체에 .rx만 붙히면 땅땅 해결

```swift
toggleSwitch.rx.isOn
  .subscribe(onNext: { enabled in
    print( enabled ? "it's ON" : "it's OFF" )
})
```

![image-20200724150430257](/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200724150430257.png)
