import UIKit
import Foundation
import RxSwift

let disposeBag = DisposeBag()

print("-----publish subject-----")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("hello")

let subscriber = publishSubject.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

publishSubject.onNext("see this")
publishSubject.onNext("see this222")


print("-----behavior subject-----")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "init")

behaviorSubject.onNext("1")

behaviorSubject.subscribe {
    print("1Sub : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("2Sub : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

//let value = try behaviorSubject.value()
//print(value)

print("-----replay subject-----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("11111")
replaySubject.onNext("22222")
replaySubject.onNext("33333")

replaySubject.subscribe {
    print("1Sub : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("2Sub : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("44444")

replaySubject.subscribe {
    print("3Sub : ", $0.element ?? $0)
}
.disposed(by: disposeBag)
