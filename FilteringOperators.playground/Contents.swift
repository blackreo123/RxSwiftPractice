import UIKit
import Foundation
import RxSwift

let disposeBag = DisposeBag()

print("-----ignoreElements-----")
let sleepMode = PublishSubject<String>()
sleepMode
    .ignoreElements()
    .subscribe { _ in
        print("get up")
    }
    .disposed(by: disposeBag)

sleepMode.onNext("alarm")
sleepMode.onNext("alarm")
sleepMode.onNext("alarm")

sleepMode.onCompleted()

print("-----ElementAt-----")
let getUpAtTwo = PublishSubject<String>()
getUpAtTwo
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

getUpAtTwo.onNext("alarm1") // index0
getUpAtTwo.onNext("alarm2") // index1
getUpAtTwo.onNext("alarm3") // index3

print("-----Filter-----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter {
        $0 % 2 == 0
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----Skip-----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----SkipWhile-----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    .skip(while: {$0 != 11})
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----SkipUntil-----")
let customer = PublishSubject<String>()
let openDoor = PublishSubject<String>()

customer
    .skip(until: openDoor)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

customer.onNext("customer1")
customer.onNext("customer2")
customer.onNext("customer3")
customer.onNext("customer4")
customer.onNext("customer5")

openDoor.onNext("open!")

customer.onNext("customer6")

print("-----take-----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----takeWhile-----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    .take(while: {
        $0 != 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----enumerated-----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----takeUntil-----")
let enroll = PublishSubject<String>()
let end = PublishSubject<String>()

enroll
    .take(until: end)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

enroll.onNext("korean")
enroll.onNext("english")
enroll.onNext("math")
enroll.onNext("science")
end.onNext("enroll end!")
enroll.onNext("give")
enroll.onNext("money")

print("-----distinctUntilChanged-----")
Observable.of("i", "i", "i", "i", "love", "love", "love", "love", "i", "love", "you", "you", "you", "you")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
