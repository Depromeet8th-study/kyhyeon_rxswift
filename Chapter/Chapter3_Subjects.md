---

---

###Chapter 3. Subjects

[toc]

Subjects는 http://reactivex.io/ 에서 한자리 떡하니 차이할만큼 중요함
Observable은 생성자 오퍼레이터를 통해 그때 그때 만들어서 사용했는데
실제로 앱환경에서는 안써!
아니면 별도로 메소드 껍데기 씌워서 Observable은 리턴할 때 말고는 
대부분 Subjects를 통해 생성!
왜냐하면 말이 쫌 난해한대
데이터 흐름을 제공하는 옵저버블이자 이를 구독하는 구독자이자!?@#!?#!
`Observable` 이자 `Observer` 인게 `Subjects` !!! ?! 나니?



![image-20200724183938151](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh27qtbtygj304i05imx3.jpg)



코드를 보면 
`Observable` 이미 데이터가 생성되어 있기 때문에 `subscribe` 하게 되면 바로바로 이벤트가 나옴
`Subject` 는 내가 어떤 데이터를 받을 `Observable` 이다 생성하고
내가 `subscribe` 하면 뭘 처리하겠다 선언하고
`subject.onNext("2")` 통해 데이터가 들어오면 그때 `subscribe` 에 정의된 코드를 처리한다.

```swift
example("PublishSubject") {

   // 1 - PublishSubject 생성 == `Observable` 이자 `Observer`
    let subject = PublishSubject<String>()

    // 2 - PublishSubject야!!! Is anyone listening? 이벤트를 발생 시켜줘
    // 응 안돼 돌아가! 출력 없어!
    subject.onNext("Is anyone listening?")

    // 3 - 구독하면 나오겠지 !?!? 응 아니야!
    let subscriptionOne = subject
        .subscribe(onNext: { (string) in
            print(string)
        })

    // 4 - 이제 출력 
    subject.on(.next("1"))        //Print: 1

    // 5 - 축약형
    subject.onNext("2")        //Print: 2
}
```



#### What are subjects?

총 4가지의 `Subjects` 가 존재함
이건 교재가 쫌 옛날 꺼라 http://reactivex.io/documentation/ko/subject.html 여기로
마블다이어그램 보면서 보는게 좋음

중요한 점

`차가운 Observable Subjects` : `subscribe` 이전의 데이터를 보장한다.

`뜨거운 Observable Subjects` : `subscribe` 이전의 데이터를 보장하지 않는다



**PublishSubject**
![image-20200724185322989](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh27qqhyf7j30er09iq3f.jpg)

**BehaviorSubject**
![image-20200724185455185](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh27qsfe7gj30do09maap.jpg)





**ReplaySubject**
![image-20200724185524256](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh27qrg25uj30ea09cjrz.jpg)



**AysncSubject**
![image-20200724185614368](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh27qsuwl3j30du09agm1.jpg)



#### 도전 과제

1. 
2.  