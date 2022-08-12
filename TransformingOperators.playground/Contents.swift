import UIKit
import Foundation
import RxSwift

let disposeBag = DisposeBag()

print("-----toArray-----")
Observable.of("a", "b", "c")
    .toArray()
    .subscribe(onSuccess: {
            print($0)
    })
    .disposed(by: disposeBag)

print("-----Map-----")
Observable.of(Date())
    .map { date in
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        dateFomatter.locale = Locale(identifier: "ko_KR")
        return dateFomatter.string(from: date)
    }
    .subscribe(onNext: {
            print($0)
    })
    .disposed(by: disposeBag)

print("-----FlatMap-----")
protocol Player {
    var score: BehaviorSubject<Int> {get}
}

struct Archer: Player {
    var score: BehaviorSubject<Int>
}

let koreaArcher = Archer(score: BehaviorSubject<Int>(value: 10))
let japanArcher = Archer(score: BehaviorSubject<Int>(value: 8))

let Olympic = PublishSubject<Player>()

Olympic
    .flatMap { player in
        return player.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

Olympic.onNext(koreaArcher)
Olympic.onNext(japanArcher)
koreaArcher.score.onNext(9)
japanArcher.score.onNext(9)
Olympic.onCompleted()

print("-----FlatMapLatest-----")

Olympic
    .flatMapLatest { player in
        player.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

Olympic.onNext(koreaArcher)
Olympic.onNext(japanArcher)
//koreaArcher.score.onNext(10)
//japanArcher.score.onNext(9)
