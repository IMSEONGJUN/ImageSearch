//
//  Reactive+Ext.swift
//
//  Created by SEONGJUN on 2020/10/09.
//

import UIKit
import RxSwift
import RxCocoa


func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
  guard let returnValue = object as? T else {
    throw RxCocoaError.castingError(object: object, targetType: resultType)
  }
  return returnValue
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UICollectionView {
    var needToFetchMoreData: ControlEvent<Void> {
        let selector = #selector(UICollectionViewDelegateFlowLayout.scrollViewDidEndDragging(_:willDecelerate:))
        let source = self.delegate.methodInvoked(selector)
            .map{ arg -> Bool in
                let scrollView = try castOrThrow(UIScrollView.self, arg[0])
                let offsetY = scrollView.contentOffset.y
                let totalScrollViewContentHeight = scrollView.contentSize.height
                let deviceViewHeight = scrollView.frame.size.height
                return offsetY > totalScrollViewContentHeight - deviceViewHeight
            }
            .filter { $0 }
            .mapToVoid()
        return ControlEvent(events: source)
    }
}

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension ObservableConvertibleType {
    func catchErrorJustComplete() -> Observable<Element> {
        return asObservable()
            .catch { _ in
                return .empty()
            }
    }
}
