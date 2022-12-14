import UIKit
import RxSwift

let disposeBag = DisposeBag()

print("---------- startWith ----------")

let childGroup = Observable<String>.of("๐ฆ๐ป", "๐ง๐ผ", "๐ฆ๐ฝ")

childGroup
    .enumerated()
    .map({ index, element in
        return element + "child" + "\(index)"
    })
    .startWith("๐จ๐ปteacher") // String type
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---------- concat1 ----------")
let childGroup2 = Observable<String>.of("๐ฆ๐ป", "๐ง๐ผ", "๐ฆ๐ฝ")
let teacher = Observable<String>.of("๐จ๐ป")
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
    "childGroup": Observable<String>.of("๐ฆ๐ป", "๐ง๐ผ", "๐ฆ๐ฝ"),
    "babyGroup": Observable<String>.of("๐ถ๐ป", "๐ถ๐ฟ")
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
let kanto = Observable.from(["ๆฑไบฌ","ๅ่","ๅผ็","็ฅๅฅๅท","็พค้ฆฌ","ๆ ๆจ","่จๅ","ๅฑฑๆขจ"])
let tohoku = Observable.from(["้ๆฃฎ","็ง็ฐ","ๅฒฉๆ","ๅฑฑๅฝข","ๅฎฎๅ","็ฆๅณถ"])

Observable.of(kanto, tohoku)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// ๋จธ์ง๋ ์ต์ ธ๋ฒ๋ธ์ค ํ๋๋ผ๋ ์๋ฌ๊ฐ ๋ฐ์ํ๋ฉด ๋จธ์ง๋ ์ต์ ธ๋ฒ๋ธ ์ ์ฒด ์๋ฌ
// ๋ฐฉ์ถ๋๋ ๊ฐ์ ์ ํด์ง ์์๊ฐ ์๋ค

print("---------- merge2 ----------")
Observable.of(kanto, tohoku)
    .merge(maxConcurrent: 1) // ไธๅใซๅฆ็ใใobervableใฎๆฐ
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

// zipใฎไธญใฎไธใคใงใๅฎไบใใใๅจไฝใ็ตไบ

print("---------- withLatestFrom ----------")
let trigger = PublishSubject<Void>()
let bullet = PublishSubject<String>()

trigger
    .withLatestFrom(bullet)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

bullet.onNext("bullet1")
bullet.onNext("bullet1, bullet2")
bullet.onNext("bullet1, bullet2, bullet3")

trigger.onNext(Void())
trigger.onNext(Void())

print("---------- sample ----------")
let start = PublishSubject<Void>()
let F1Player = PublishSubject<String>()

F1Player
    .sample(start)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

F1Player.onNext("player1")
F1Player.onNext("player1, player2")
F1Player.onNext("player1, player2, player3")

start.onNext(Void())
start.onNext(Void())
start.onNext(Void())

print("---------- amb ----------")
let bus1 = PublishSubject<String>()
let bus2 = PublishSubject<String>()

let station = bus1.amb(bus2)

station
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

bus2.onNext("bus2: person1")
bus1.onNext("bus1: person2")
bus1.onNext("bus1: person3")
bus2.onNext("bus2: person4")
bus1.onNext("bus1: person5")
bus2.onNext("bus2: person6")

print("---------- switchLatest ----------")
let student1 = PublishSubject<String>()
let student2 = PublishSubject<String>()
let student3 = PublishSubject<String>()

let handsUp = PublishSubject<Observable<String>>()

let voice = handsUp.switchLatest()

voice
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

handsUp.onNext(student1)
student1.onNext("student1 :im student1")
student2.onNext("student2 :me first!")

handsUp.onNext(student2)
student2.onNext("student2 :im student2!")
student1.onNext("student1: my turn...")

handsUp.onNext(student3)
student2.onNext("student2: wait!")
student1.onNext("student1: no you wait")
student3.onNext("student3: i think my turn now")

handsUp.onNext(student1)
student1.onNext("student1: no i win")
student2.onNext("student2: no way")
student3.onNext("student3: no way")

print("---------- reduce ----------")
Observable.from((1...10))
//    .reduce(0) { summary, newValue in
//        return summary + newValue
//    }
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("---------- scan ----------")
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
