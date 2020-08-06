

'#5'

Rx + MVVM + CoreData 메모장 앱



#### MemoListViewModel



의존성을 주입하는 생성자와 바인딩에 사용 되는 속성가 메소드

뷰모델은 화면 전환과 메모장을 모두 처리?

싱코디네이터와 메모리스토리지를 활용함.

생성 시점에 생성자를 통해서 의존성을 주입해야함



앱을 구성하는 모든 화면은 네비게이션 컨트롤러에 임베드 되기때문에

이 구조에서는 네비게이션 타이틀이 필요

NSObject 쓰는 이유??



```swift
// UI 변경점만 MainScheduler
let title: Driver<String>

// 의존성을 쉽게 수정하기 위해 프로토콜 타입으로
let scenCoordinator: SceneCoordinatorType
let storage: MemoStorageType
```



cell Accessory - Disclosure indicator??



<img src="/Users/kyuhyeon/Library/Application Support/typora-user-images/image-20200806225421809.png" alt="image-20200806225421809" style="zoom:50%;" />

**Disclosure Indicator** : Tableview cell을 선택했을 때 데이터 구조상 Lower Level에 해당하는 또 다른 테이블 뷰 화면을 보여주게 됨을 의미합니다.

**Detail Disclosure Butto**n : Detail 옵션과 Disclosure Indicator 옵션이 합쳐진 것으로 Tableview cell을 선택했을 때 그에 대한 상세 내용을 보여주게 됨을 의미하지만, 상세 내용은 Disclosure Indicator와 같이 하위 레벨의 Tableview가 될 수도, Detail과 같이 일반 뷰에 표현된 상세 내용이 될 수도 있습니다.

**Checkmark** : Tableview item의 개별 행을 사용자가 선택했다는 것을 나타낸다. 이런 종류의 테이블 뷰는 대개 선택 목록으로 불리며, 또 다른 선택용 목록인 팝업 목록과 비슷하다. 선택용 목록은 하나만 선택하도록 제한하거나 여러 개를 선택할 수 있도록 허용할 수도 있습니다.

**Detail** : Tableview cell을 선택했을 때 이에 대한 상세 내용을 일반 뷰로 보여주게 됨을 의미합니다.

출처: https://medium.com/@zieunv/ios-tableview-1-ebcf2048e0f3



NSObject_Rx 왜쓰지?



plist  UIWindowSceneSessionRoleApplication 삭제 씬델리게이트 안쓸라고

추가 AppDelegate 클래스에

**var** window: UIWindow?



코디네이터는 쪼금 헷갈리네?!?!?