//
//  PopPoolTests.swift
//  PopPoolTests
//
//  Created by SeoJunYoung on 6/1/24.
//

import XCTest
import RxSwift
@testable import PopPool

final class PopPoolTests: XCTestCase {
    var provider: ProviderImpl!
    var mockSession: MockUrlSession!
    var disposeBag: DisposeBag!
    
    func setup() {
        mockSession = MockUrlSession()
        provider = ProviderImpl(session: mockSession)
        disposeBag = DisposeBag()
    }
    
    func testFetchJokes() {
        // 가짜 데이터
        let jokeData = """
                {
                    "icon_url": "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
                    "id": "DJkMRNM0QRS7kdEwbenGHQ",
                    "url": "http://example.com/joke",
                    "value": "Chuck Norris joke."
                }
                """.data(using: .utf8)
        mockSession.nextData = jokeData
        
        let requestDTO = TestRequestDTO(query: "cat")
        let endPoint = APIEndpoint.fetchData(with: requestDTO)
        
        let expected = self.expectation(description: "JokeData")
        
        provider.requestData(with: endPoint)
            .subscribe { (response: TestResponseDTO) in
                XCTAssertEqual(response.value, "chuck norris 조크")
                expected.fulfill()
            }
            onError: { error in
                XCTFail("오류가 발생했습니다. \(error)")
            }
            .disposed(by: disposeBag)
    }
}
