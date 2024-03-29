//
//  ImageSearcherTests.swift
//  ImageSearcherTests
//
//  Created by SEONGJUN on 1/6/24.
//
@testable import ImageSearcher
import XCTest
import RxSwift

final class ImageSearchTests: XCTestCase {
    let useCaseMock = ImageSearchUseCaseMock()
    lazy var viewModel = ImageSearchViewModel(useCase: useCaseMock)
    
    private let searchKeywordSubject = BehaviorSubject<String>(value: "")
    private let favoriteButtonTapSubject = PublishSubject<(ImageSearchResultItem, PersistenceUpdateType)>()
    private let didScrollToBottomSubject = PublishSubject<Void>()
    private let searchButtonTappedSubject = PublishSubject<Void>()
    
    private var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag = DisposeBag()
    }
    
    func testImageSearchResponseIsValid() throws {
        /// Given
        let input = ImageSearchViewModel.Input(searchKeyword: searchKeywordSubject.asObservable(),
                                               favoriteButtonSelected: favoriteButtonTapSubject.asObservable(),
                                               didScrollToBottom: didScrollToBottomSubject.asObservable(),
                                               searchButtonTapped: searchButtonTappedSubject.asObservable())
        
        let output = viewModel.transform(input)
        
        let expectation = XCTestExpectation(description: "imageSearch")
        
        /// When
        output.dataLoaded
            .drive(onNext:{ sectionModels, presentType in
                /// Then
                guard let item = sectionModels.first?.items.first, case .image(let imageInfo) = item else {
                    return
                }
                let isItemImageInfoType = type(of: imageInfo) == ImageInfo.self
                XCTAssertTrue(isItemImageInfoType)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        output.updateFavorite.drive().disposed(by: disposeBag)
        
        searchKeywordSubject.onNext("bmw")
        searchButtonTappedSubject.onNext(())
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testImageResultCleanUp() throws {
        /// Given
        let input = ImageSearchViewModel.Input(searchKeyword: searchKeywordSubject.asObservable(),
                                               favoriteButtonSelected: favoriteButtonTapSubject.asObservable(),
                                               didScrollToBottom: didScrollToBottomSubject.asObservable(),
                                               searchButtonTapped: searchButtonTappedSubject.asObservable())
        
        let output = viewModel.transform(input)
        
        /// When
        output.dataLoaded
            .asObservable()
            .enumerated()
            .subscribe(onNext:{ index, value in
                /// Then
                if index == 1 {
                    let (sectionModels, _) = value
                    XCTAssertTrue(sectionModels.isEmpty)
                }
            })
            .disposed(by: disposeBag)
        
        output.updateFavorite.drive().disposed(by: disposeBag)
        
        searchKeywordSubject.onNext("bmw")
        searchButtonTappedSubject.onNext(())
        
        searchKeywordSubject.onNext("")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
