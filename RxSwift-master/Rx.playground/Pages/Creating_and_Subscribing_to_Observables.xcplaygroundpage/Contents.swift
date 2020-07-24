/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxExample-macOS** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator** (under RxExample project).
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ----
 [Previous](@previous) - [Table of Contents](Table_of_Contents)
 */
import RxSwift
import Foundation
/*:
 # Creating and Subscribing to `Observable`s
 There are several ways to create and subscribe to `Observable` sequences.
 ## never
 Creates a sequence that never terminates and never emits any events. [More info](http://reactivex.io/documentation/operators/empty-never-throw.html)
 */

// 내가 작성
example("of") {
    let disposeBag = DisposeBag()

    let one = 1
    let two = 2
    let three = 3

    let observable: Observable<Int> = Observable<Int>.just(one)
    let observable2 = Observable.of(one, two, three)
    let observable3 = Observable.of([one, two, three])
    let observable4 = Observable.from([one, two, three])
}

// Subscribing to observables
example("of") {
    let disposeBag = DisposeBag()

    let one = 1
    let two = 2
    let three = 3

    let observable = Observable.of(one, two, three)
    observable.subscribe { event in
        print(event)
    }

    observable.subscribe(onNext: { element in
        print("element: \(element)")
    })
}

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


enum MyError: Error {
    case anError
}

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

example("deferred") {
    let disposeBag = DisposeBag()

    // 1
    var flip = false

    // 2
    let factory: Observable<Int> = Observable.deferred{

        // 3
        flip = !flip

        // 4
        if flip {
            return Observable.of(1,2,3)
        } else {
            return Observable.of(4,5,6)
        }
    }

    for _ in 0...3 {
        factory.subscribe(
            onNext: {
                print($0, terminator: "")
        })
            .disposed(by: disposeBag)

        print()
    }
}

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



// ------------ 기존 코드
example("never") {
    let disposeBag = DisposeBag()
    let neverSequence = Observable<String>.never()
    
    let neverSequenceSubscription = neverSequence
        .subscribe { _ in
            print("This will never be printed")
    }
    
    neverSequenceSubscription.disposed(by: disposeBag)
}
/*:
 ----
 ## empty
 Creates an empty `Observable` sequence that only emits a Completed event. [More info](http://reactivex.io/documentation/operators/empty-never-throw.html)
 */
example("empty") {
    let disposeBag = DisposeBag()
    
    Observable<Int>.empty()
        .subscribe { event in
            print(event)
    }
    .disposed(by: disposeBag)
}
/*:
 > This example also introduces chaining together creating and subscribing to an `Observable` sequence.
 ----
 ## just
 Creates an `Observable` sequence with a single element. [More info](http://reactivex.io/documentation/operators/just.html)
 */
example("just") {
    let disposeBag = DisposeBag()
    
    Observable.just("🔴")
        .subscribe { event in
            print(event)
    }
    .disposed(by: disposeBag)
}
/*:
 ----
 ## of
 Creates an `Observable` sequence with a fixed number of elements.
 */
example("of") {
    let disposeBag = DisposeBag()
    
    Observable.of("🐶", "🐱", "🐭", "🐹")
        .subscribe(onNext: { element in
            print(element)
        })
        .disposed(by: disposeBag)
}
/*:
 > This example also introduces using the `subscribe(onNext:)` convenience method. Unlike `subscribe(_:)`, which subscribes an _event_ handler for all event types (Next, Error, and Completed), `subscribe(onNext:)` subscribes an _element_ handler that will ignore Error and Completed events and only produce Next event elements. There are also `subscribe(onError:)` and `subscribe(onCompleted:)` convenience methods, should you only want to subscribe to those event types. And there is a `subscribe(onNext:onError:onCompleted:onDisposed:)` method, which allows you to react to one or more event types and when the subscription is terminated for any reason, or disposed, in a single call:
 ```
 someObservable.subscribe(
 onNext: { print("Element:", $0) },
 onError: { print("Error:", $0) },
 onCompleted: { print("Completed") },
 onDisposed: { print("Disposed") }
 )
 ```
 ----
 ## from
 Creates an `Observable` sequence from a `Sequence`, such as an `Array`, `Dictionary`, or `Set`.
 */
example("from") {
    let disposeBag = DisposeBag()
    
    Observable.from(["🐶", "🐱", "🐭", "🐹"])
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 > This example also demonstrates using the default argument name `$0` instead of explicitly naming the argument.
 ----
 ## create
 Creates a custom `Observable` sequence. [More info](http://reactivex.io/documentation/operators/create.html)
 */
example("create") {
    let disposeBag = DisposeBag()
    
    let myJust = { (element: String) -> Observable<String> in
        return Observable.create { observer in
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        }
    }

    myJust("🔴")
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## range
 Creates an `Observable` sequence that emits a range of sequential integers and then terminates. [More info](http://reactivex.io/documentation/operators/range.html)
 */
example("range") {
    let disposeBag = DisposeBag()
    
    Observable.range(start: 1, count: 10)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## repeatElement
 Creates an `Observable` sequence that emits the given element indefinitely. [More info](http://reactivex.io/documentation/operators/repeat.html)
 */
example("repeatElement") {
    let disposeBag = DisposeBag()
    
    Observable.repeatElement("🔴")
        .take(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 > This example also introduces using the `take` operator to return a specified number of elements from the start of a sequence.
 ----
 ## generate
 Creates an `Observable` sequence that generates values for as long as the provided condition evaluates to `true`.
 */
example("generate") {
    let disposeBag = DisposeBag()
    
    Observable.generate(
        initialState: 0,
        condition: { $0 < 3 },
        iterate: { $0 + 1 }
    )
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## deferred
 Creates a new `Observable` sequence for each subscriber. [More info](http://reactivex.io/documentation/operators/defer.html)
 */
example("deferred") {
    let disposeBag = DisposeBag()
    var count = 1
    
    let deferredSequence = Observable<String>.deferred {
        print("Creating \(count)")
        count += 1
        
        return Observable.create { observer in
            print("Emitting...")
            observer.onNext("🐶")
            observer.onNext("🐱")
            observer.onNext("🐵")
            return Disposables.create()
        }
    }
    
    deferredSequence
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    deferredSequence
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## error
 Creates an `Observable` sequence that emits no items and immediately terminates with an error.
 */
example("error") {
    let disposeBag = DisposeBag()

    Observable<Int>.error(TestError.test)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## doOn
 Invokes a side-effect action for each emitted event and returns (passes through) the original event. [More info](http://reactivex.io/documentation/operators/do.html)
 */
example("doOn") {
    let disposeBag = DisposeBag()
    
    Observable.of("🍎", "🍐", "🍊", "🍋")
        .do(onNext: { print("Intercepted:", $0) }, afterNext: { print("Intercepted after:", $0) }, onError: { print("Intercepted error:", $0) }, afterError: { print("Intercepted after error:", $0) }, onCompleted: { print("Completed")  }, afterCompleted: { print("After completed")  })
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
//: > There are also `doOnNext(_:)`, `doOnError(_:)`, and `doOnCompleted(_:)` convenience methods to intercept those specific events, and `doOn(onNext:onError:onCompleted:)` to intercept one or more events in a single call.

//: [Next](@next) - [Table of Contents](Table_of_Contents)
