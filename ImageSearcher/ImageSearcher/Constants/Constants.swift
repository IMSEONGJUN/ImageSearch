//
//  Constants.swift
//  SmoothyAssingment
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation

enum Images {
    static let back = "arrow.left"
}

enum Notifications {
    static let removeFavorite = Notification.Name(rawValue: "removeFavorite")
}

enum TabBarTitle {
    static let imageSearchList = "이미지 검색 & 리스트"
    static let favoriteImage = "이미지 즐겨찾기"
}

enum SearchBarPlaceHolder {
    static let search = "Search"
}

enum NetworkError: Error {
    case error(String)
    case defaultError
    
    var message: String? {
        switch self {
        case let .error(msg):
            return msg
        case .defaultError:
            return "잠시 후에 다시 시도해주세요."
        }
    }
}

enum ImageLoadError: String, Error {
    case invalidUrl = "잘못된 URL입니다. 다시 입력해주세요."
    case invalidResponse = "서버로부터의 응답이 잘못되었습니다. 다시 시도해주세요."
    case unableToComplete = "이미지를 불러올 수 없습니다. 인터넷 연결상태를 체크해주세요."
    case invaildData = "해당 URL의 이미지가 없습니다. 다시 시도해주세요."
}


enum FavoriteError: String, Error {
    case alreadyInFavorites = "즐겨찾기에 이미 존재하는 이미지 입니다."
    case failedToLoadFavorite = "즐겨찾기 로드 실패"
    case failedToSaveFavorite = "즐겨찾기에 저장 실패"
}
