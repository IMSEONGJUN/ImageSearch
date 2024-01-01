//
//  ImageSearchViewModel.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import Foundation
import RxSwift
import RxCocoa

final class ImageSearchViewModelNew: ViewModelable {
    enum DataPresentType {
        case append
        case refresh
    }
    
    struct Input {
        let searchKeyword: Observable<String>
        let favoriteButtonSelected: Observable<(ImageSearchResultItem, PersistenceUpdateType)>
        let didScrollToBottom: Observable<Void>
        let searchButtonTapped: Observable<Void>
    }
    
    struct Output {
        let dataLoaded: Driver<([ImageSearchResultSectionModel], DataPresentType)>
        let updateFavorite: Driver<ImageSearchResultItem>
    }
    
    private let useCase: any ImageSearchUseCasable
    
    init(useCase: some ImageSearchUseCasable) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let useCase = self.useCase
        var isEnd = false
        var page = 1
        var dataPresentType = DataPresentType.refresh
        
        let reset = {
            page = 1
            isEnd = false
            dataPresentType = DataPresentType.refresh
        }
        
        let searchKeyword = input.searchKeyword.skip(1).asDriver(onErrorDriveWith: .empty())
        
        let cleanUp: Driver<[ImageSearchResultSectionModel]> = searchKeyword
            .filter { $0.isEmpty }
            .map { _ in () }
            .do(onNext: reset)
            .map { _ in [] }
        
        let paging = input.didScrollToBottom
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .do(onNext: { dataPresentType = DataPresentType.append })
        
        let sectionModels = input.searchButtonTapped
            .do(onNext: reset)
            .withLatestFrom(searchKeyword)
            .flatMapLatest { keyword in
                paging
                    .startWith(())
                    .filter { !isEnd }
                    .flatMapFirst {
                        useCase.search(keyword: keyword, page: page)
                            .do(onSuccess: {
                                page += 1
                                isEnd = $0.meta.isEnd
                            })
                            .map { response in
                                let items = response.imageInfos.map { ImageSearchResultItem.image($0) }
                                return [ImageSearchResultSectionModel(section: .main, items: items)]
                            }
                            .catchErrorJustComplete()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
            
        let dataLoaded = Driver.merge(
            sectionModels,
            cleanUp
        )
        .map { ($0, dataPresentType) }
        
        let updateFavorite = input.favoriteButtonSelected
            .flatMapLatest { item, type -> Observable<ImageSearchResultItem> in
                guard case let .image(imageInfo) = item else {
                    return Observable.empty()
                }
                return useCase.updateFavorite(imageInfo: imageInfo, actionType: type)
                    .asObservable()
                    .filter { $0 == nil }
                    .map { _ in item }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(dataLoaded: dataLoaded, updateFavorite: updateFavorite)
    }
}
