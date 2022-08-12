import UIKit
import RxSwift

let disposeBag = DisposeBag()

print("---------- startWith ----------")

let childGroup = Observable<String>.of("👦🏻", "🧒🏼", "👦🏽")

childGroup
    .enumerated()
    .map({ index, element in
        return element + "child" + "\(index)"
    })
    .startWith("👨🏻teacher") // String type
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---------- concat1 ----------")
let childGroup2 = Observable<String>.of("👦🏻", "🧒🏼", "👦🏽")
let teacher = Observable<String>.of("👨🏻")
let lineUp = Observable
    .concat([teacher, childGroup2])

lineUp
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---------- same result concat1 ----------")
teacher
    .concat(childGroup2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---------- concatMap ----------")
let careCenter: [String: Observable<String>] = [
    "childGroup": Observable<String>.of("👦🏻", "🧒🏼", "👦🏽"),
    "babyGroup": Observable<String>.of("👶🏻", "👶🏿")
]

Observable<String>.of("childGroup", "babyGroup")
    .concatMap { group in
        careCenter[group] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
