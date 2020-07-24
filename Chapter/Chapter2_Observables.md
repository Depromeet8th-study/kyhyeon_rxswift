###Chapter 2. Observables

https://github.com/ReactiveX/RxSwift - swift5.0 임

해당 리포지토리를 받고 `Rx.xcworkspace` 실행해서 빌드 한 다음에
RxExample - Rx.playground 에 접근!

[toc]

**What is an observable?**

- observable 핵심 뽀인트
  - 관찰할 수 있는게 무엇인지?
  - 어떻게 만들 것인지?
  - 어떻게 사용 할건지!?

- ‘observable,” “observable sequence,” and “sequence’이는 다 같은 말

- 중요한 점은 비동기적!

- 일정 기간 동안 emitting(방출)이라는 이벤트를 생성
  일정 시간 동안 이벤트가 1, 2, 3이 방출되었다!

  ![image-20200724160625367](/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200724160625367.png)



**Lifecycle of an observable**

- 완료된(completed) 이벤트

  ![image-20200724160834200](/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200724160834200.png)

- 에러(error) 이벤트

  ![image-20200724160852049](/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200724160852049.png)

```
Observables은 요소(이벤트)를 방출한다. 
종료되는 시점은
- 오류 이벤트 발생 후 종료
- 완료되고 종료
*** 종료가 되면 더이상 요소(이벤트)를 방출 할 수 없다.
```

```swift
/// Represents a sequence event.
///
/// Sequence grammar: 
/// **next\* (error | completed)**
public enum Event<Element> {
    /// Next element is produced.
    case next(Element)

    /// Sequence terminated with an error.
    case error(Swift.Error)

    /// Sequence completed successfully.
    case completed
}
```



**🤟 여기서 정리**
Observables은 이벤트를 생성하는 데이터의 흐름인데
`next` 는 계속해서 Element를 전달하고

`error` 는 데이터 흐름이 종료되고 error 데이터를 전달하고

`completed` 는 데이터 흐름이 종료되고, 아무 데이터를 전달하지 않고



---



####**Creating observables**
🙌 RxSwift 5.0 에서 사용하려면

스킴을 RxExample-macOs - My Mac으로 설정하고 빌드

Creating_and_Subscribing_to_Observables에서 런 고고

```swift
example("of") {
    let disposeBag = DisposeBag()

    let one = 1
    let two = 2
    let three = 3

  	// 데이터 타입을 정확히 옵저버블 인트로 명시
    let observable: Observable<Int> = Observable<Int>.just(one)
  
    // of 연산자를 통해 자동으로 타입 추론
    let observable2 = Observable.of(one, two, three)
  
    // of 연산자를 통해 자동으로 타입 추론
    let observable3 = Observable.of([one, two, three])
  
    // convert various other objects and data types into Observables
		// 콜렉션 타입만 옵저버블로 만든다. 
    let observable4 = Observable.from([one, two, three])
}
```

![image-20200724163236424](/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200724163236424.png)

observable은 인트타입의 옵저버블을 생성 했고 초기화를 just를 통해 '1'를 할당

```
operators - Observable 생성
Just — 객체 하나 또는 객채집합을 Observable로 변환한다. 변환된 Observable은 원본 객체들을 발행한다
From — 다른 객체나 자료 구조를 Observable로 변환한다
http://reactivex.io/documentation/ko/operators.html
```



#### Subscribing to observables

Observable은 실제로 sequence 생성하는 것일뿐! 구독하지 않으면 
**Subscribing** 하지 않으면 아무 의미 없다.

예제 코드를 보면,
아래 코드를 실행하게 되면 next, error, completed 모두 수신함

```swift
example("of") {
    let disposeBag = DisposeBag()

    let one = 1
    let two = 2
    let three = 3

    let observable = Observable.of(one, two, three)
    observable.subscribe { event in
        print(event)
    }
}
/*
next(1)
next(2)
next(3)
completed
*/
```



그리고 일반적으로 onNext만! 처리하는 경우가 많은데 아래와 같은 형태를 취함
error나 completed에 대한 이벤트는 처리 할 수 없다.

```swift
observable.subscribe(onNext: { element in
  print(element)
})
/*
element: 1
element: 2
element: 3
*/
```



**empty**

빈연산자 옵저버블인 경우를 살펴 보면
아래와 같이 결과값이 `Completed` 를 확인 할 수 있다.
근데 빈것을 관찰할 수 있는 용도는?
즉시 종료되는 값 또는 의도적으로 제로 값을 갖는 경우라고 하는데 솔직히 
자주 쓰이는지는 모르겠다

```swift
example("empty") {

    let observable = Observable<Void>.empty()

    observable
        .subscribe(
            // 1
            onNext: { element in
                print(element)
        },
            // 2
            onCompleted: {
                print("Completed")
        }
    )
}
/*
Completed
*/
```



**never**

절대 연산자를 뱉지 않는 경우, 종료되 지 않는 걸 관찰 할때의 경우도 있는데
무한한 지소식간을 나타내기 위해 사용된다고 한다는데 잘 모르겠네
생각 해보면 
지속이 되야하는 스톱워치 처럼 지속이 되야하는 타이머가 있는데
이게 onError로 체크해서 끊기는 경우 다시 요청 하는 방식은 생각 해 볼 수 있을거 같다.

```swift
example("never") {

  let observable = Observable<Any>.never()

  observable
    .subscribe(
      onNext: { element in
        print(element)
    },
      onCompleted: {
        print("Completed")
    }
  )
}
/*
결과 값이 없다.
*/
```



**range**

값의 범위에서 관측을 할 수 있는데
**pow를 사용하기 위해서는 `import Foundation`  명시해줘야함

1부터 10까지 이벤트가 발생되고, 방출된 이벤트의 n번째 피보나치 수열을 출력
** Ch7. Transforming Operators에서 onNext의 이벤트를 변형할 수 있는 좋은 방법이 나옴

```swift
example("range") {

  // 1
  let observable = Observable<Int>.range(start: 1, count: 10)

  observable
    .subscribe(onNext: { i in

      // 2
      let n = Double(i)
      let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
      print(fibonacci)
  })
}
```



#### Disposing and terminating

아주 중요한 개념이자 쉽게 놓치는 부분 Disposing 제대로 하지 않으면 메모리 릭릭릭!!@#!@

**subscription** 는 error 또는 completed가 발생하지 않으면 종료 되지 않고 메모리에 상주하게 된다
이를 수동으로 취소 할 수 있게 설정 할 수 있다.

타입 1의 경우 subscription 이 끝나면 종료되는 시점에 dispose() 통해 구독을 취소하는 케이스이고
타입 2의 경우 `.disposed(by: disposeBag)` 오퍼레이터를 통해 subscribe를 시점에 
이를 담는 disposeBag 만들어 해당 담아 둔다.
그리고 일반적으로 이를 class가 deinit될 때 초기화하여 구독을 모두 취소 함으로써 메모리릭을 방지 할수있다. **그냥 일반적으로는 타입2 처럼 쓰면 된다**



타입 1

```swift
example("dispose") {
  // 1
  let observable = Observable.of("A", "B", "C")

  // 2
  let subscription = observable.subscribe { event in

    // 3
    print(event)
  }
    subscription.dispose()
}
```

타입 2

```swift
example("DisposeBag") {

  // 1
  let disposeBag = DisposeBag()

  // 2
  Observable.of("A", "B", "C")
    .subscribe { // 3
      print($0)
    }
    .disposed(by: disposeBag) // 4
}
```



**create**

of, just, from 오퍼레이터가 아닌 create 연산자로 옵저버블을 만드는 방법이다.

아래 코드를 봤을 때 두 번째 onNext 요소(?)가 이벤트가 구독자들에게 방출 될 수 있을 까요?!
나는 "아니다"  왜? onCompleted() 때문에 안되지 않을까?!

```swift
example("create") {
    let disposeBag = DisposeBag()
    
    // create는 escaping closer로 AnyObserver를 인자로 주고 Disposable 리턴한다.
    // Observable sequence == AnyObserver를
    Observable<String>.create({ (observer) -> Disposable in
        // 1 - 문자열 1를 onNext를 통해 이벤트를 발생 시킨다
        observer.onNext("1")

        // 2 observer에 onCompleted 이벤트를 추가 한다
        observer.onCompleted()

        // 3 - 문자열 ?를 onNext를 통해 이벤트를 발생 시킨다
        observer.onNext("?")

        // 4 - disposable 리턴 한다
        return Disposables.create()
    })
}
```

확인을 위해 코드를 수정하면

응! observer.onCompleted() 해서 안나와

```swift
example("create") {
    let disposeBag = DisposeBag()
    
    Observable<String>.create({ (observer) -> Disposable in
        // 1
        observer.onNext("1")

        // 2
        observer.onCompleted()

        // 3
        observer.onNext("?")

        // 4
        return Disposables.create()
    }).subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
    )
        .disposed(by: disposeBag)
}
/*
1
Completed
Disposed
*/
```



여기에 에러 체크 기능을 넣어보면

```swift
example("create") {
    let disposeBag = DisposeBag()

    Observable<String>.create({ (observer) -> Disposable in
        // 1
        observer.onNext("1")

        observer.onError(MyError.anError)

        // 2
        observer.onCompleted()

        // 3
        observer.onNext("?")

        // 4
        return Disposables.create()
    }).subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
    )
        .disposed(by: disposeBag)
}
/*
1
anError
Disposed
*/
```



여기서 onError, onCompleted, disposed 제거해보면
next 이벤트는 정상적으로 1, 2 나오지만 메모리 릭이 발생한다!

```swift
example("create") {
    let disposeBag = DisposeBag()

    Observable<String>.create({ (observer) -> Disposable in
        // 1
        observer.onNext("1")

//        observer.onError(MyError.anError)

        // 2
//        observer.onCompleted()

        // 3
        observer.onNext("?")

        // 4
        return Disposables.create()
    }).subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
    )
//        .disposed(by: disposeBag)
}
/*
1
?
*/
```



#### Creating. observable factories

이건 좀 애매한데, 팩토리 패턴 한번 보자
Observable은 subscribe를 해야 의미가 있는 데이터가 되는데
`deferred`  오퍼레이터를 통해 `subscriber`:  subscribe를 해야하는 주체에게 Observable 항목을 제공하는 Obaservable factory를 제공하는 방법이다. 
그냥 이런 방법도 있구나 하면 될 듯, !?!?!?!?!?!?

```swift
example("deferred") {
    let disposeBag = DisposeBag()

    // 1 - Observable이 리턴할 값 false를 미리 생성
    var flip = false

    // 2 - Observable 생성
    let factory: Observable<Int> = Observable.deferred{

        // 3 - 토글
        flip = !flip

        // 4 - 조건문에 따라 미리 할당된 옵저버블 값을 리턴
        if flip {
            return Observable.of(1,2,3)
        } else {
            return Observable.of(4,5,6)
        }
    }
	
   // factory.subscribe에서 이벤트가 발생 할때마다 (1,2,3), (4,5,6) 가 순차적으로 발생됨 
    for _ in 0...3 {
        factory.subscribe(
            onNext: {
                print($0, terminator: "")
           })
            .disposed(by: disposeBag)

        print()
    }
}
```



#### Using Traits

Observable를 선택적으로 사용할 수 있는 개념
아래는 옵져버블을 subscribe 했을 때 모두 명시해줘야하는 기본 형태임
이를 심플하게 필요한 것만 취한 것이 Using Tarits 이고

‘Single, Maybe, and Completable’ 이렇게 3가지가 있음

```swift
let observable: Observable<Int> = Observable<Int>.just(one)

observable.subscribe(onNext: { (int) in
    // onNext
}, onError: { (error) in
    // onError
}, onCompleted: {
    // onCompleted
}) {
    // onDisposed
}
```

**Single** 은 `.success(value)` 와 `.error` 이벤트만 방출
success는 next와 completed의 조합으로 성공 또는 실패, 이분법적인 일회성으로 사용 된다.
API 받는 건 싱글로 하면 된

**Completable** 은 `.completed` 또는 `.error` 이벤트만
그냥 요청이 제대로 되었는지 여기서는 파일 쓰기가 제대로 된것지 체크하는 용도로 사용 됨

**Maybe** 는 `.success(값)`, `.completed(완료)` 또는 `.error(오류)` 이벤트만 방출
자세한 내용은 ch4에서!

```swift
example("Single") {

    // 1 -  disposeBag 생성
    let disposeBag = DisposeBag()

    // 2 - 에러 정의
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }

    // 3 - 텍스트를 로드 하고 싱글을 리턴
    func loadText(from name: String) -> Single<String> {
        // 4
        return Single.create { single in
            // 1 - create 니깐 반드시 Disposables.create 생성
            let disposable = Disposables.create()

            // 2 - 가드문으로 안전하게 체크하는데 파일이 없으면 에러를 뱉고 disposable
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
              single(.error(FileReadError.fileNotFound))
              return disposable
            }

            // 3 - 동일하게 데이터를  불러오는데 읽을 수 없으면 에러를 뱉고 disposable
            guard let data = FileManager.default.contents(atPath: path) else {
              single(.error(FileReadError.unreadable))
              return disposable
            }

            // 4 - 동일하게 .utf8로 인코딩 했는데 실패하면 에러를 뱉고 disposable
            guard let contents = String(data: data, encoding: .utf8) else {
              single(.error(FileReadError.encodingFailed))
              return disposable
            }

            // 5 - 성공!
            single(.success(contents))
            return disposable
        }
    }

    loadText(from: "Copyright")
    .subscribe{
        switch $0 {
        case .success(let string):
            print(string)
        case .error(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
}
/*
fileNotFound 응 파일 찾을 수 없어
*/
```



**도전 과제**

1. 사이드 이펙트 `.do` 연산자

2. 디버깅 정보 출력 `.debug` 연산자

   