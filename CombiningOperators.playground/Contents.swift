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

print("---------- merge1 ----------")
let kanto = Observable.from(["東京","千葉","埼玉","神奈川","群馬","栃木","茨城","山梨"])
let tohoku = Observable.from(["青森","秋田","岩手","山形","宮城","福島"])

Observable.of(kanto, tohoku)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// 머지된 옵져버블중 하나라도 에러가 발생하면 머지된 옵져버블 전체 에러
// 방출되는 값은 정해진 순서가 없다

print("---------- merge2 ----------")
Observable.of(kanto, tohoku)
    .merge(maxConcurrent: 1) // 一回に処理するobervableの数
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//print("---------- combineLatest1 ----------")
//let firstName = PublishSubject<String>()
//let lastName = PublishSubject<String>()
//
//let fullName = Observable
//    .combineLatest(firstName, lastName) { firstName, lastName in
//        firstName + lastName
//    }
//
//fullName
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
//
//firstName.onNext("Yoon")
//lastName.onNext("jiha")
//lastName.onNext("jihye")
//firstName.onNext("Bae")
//firstName.onNext("Kim")

print("---------- combineLatest2 ----------")
let firstName = PublishSubject<String>()
let lastName = PublishSubject<String>()

let fullName = Observable
    .combineLatest([firstName, lastName]) { name in
        name.joined(separator: " ")
    }
fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

firstName.onNext("Yoon")
lastName.onNext("jiha")
lastName.onNext("jihye")
firstName.onNext("Bae")
firstName.onNext("Kim")

print("---------- combineLatest3 ----------")
let dateStyle = Observable<DateFormatter.Style>.of(.short, .long)
let today = Observable<Date>.of(Date())

let makeToday = Observable
    .combineLatest(dateStyle, today) { dateStyle, today -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        return dateFormatter.string(from: today)
    }
    
makeToday
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---------- zip ----------")
enum WinOrLose {
    case win
    case lose
}

let match = Observable<WinOrLose>.of(.lose, .lose, .win, .win, .win)
let player = Observable<String>.of("korea", "japan", "USA", "UK", "brazil", "india")

let matchResult = Observable
    .zip(match, player) { result, player in
        return player + " \(result)"
    }

matchResult
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// zipの中の一つでも完了したら全体が終了

