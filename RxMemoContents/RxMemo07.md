

'#7'

Rx + MVVM + CoreData 메모장 앱



#### MemoDetailViewModel



```swift
// 메모 내용 - 마지막 데이터를 받기 위해 Behavior
    var contents: BehaviorSubject<[String]>
```



####MemoDetailViewController

테이블뷰 바인딩 - 흠 섹션은?

```swift
viewModel.contents
            .bind(to: listTableView.rx.items) { tableview, row, value in
                switch row {
                case 0:
                    let cell = tableview.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableview.dequeueReusableCell(withIdentifier: "dataCell")!
                    cell.textLabel?.text = value
                    return cell

                default:
                    fatalError()
                }
        }
        .disposed(by: rx.disposeBag)
```



####MemoListViewController

```swift
// Rx 제공하는 선택한 인덱스 패스가 필요할 때 itemSelected
        // Rx 제공하는 선택한 데이터가 필요할땐 modelSelected
        // 두 요소를 zip - 두 데이터가 모두 들어오는 시점에 튜플 형태로 데이터를 방출
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            // 선택 되면 바로 해제
            .do(onNext: { [unowned self] (_, idx) in
                self.listTableView.deselectRow(at: idx, animated: true)
            })
            // Memo 데이터를
            .map { $0.0 }
            // viewModel.detailAction.inputs 전달
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
```

