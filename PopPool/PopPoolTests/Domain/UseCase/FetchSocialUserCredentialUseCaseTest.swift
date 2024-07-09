//
//  FetchSocialUserCredentialUseCaseTest.swift
//  PopPoolTests
//
//  Created by SeoJunYoung on 7/9/24.
//

import Foundation
import XCTest
import RxSwift

final class FetchSocialCredentialUseCaseTest: XCTestCase {
    
    var fetchSocialCredentialUseCase: FetchSocialCredentialUseCase!
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        fetchSocialCredentialUseCase = nil
        super.tearDown()
    }
    
    func test_AppleExecute() {
        let expectation = XCTestExpectation(description: "카카오_소셜인증_Fetch")
        var data: Encodable? = nil
        fetchSocialCredentialUseCase = FetchSocialCredentialUseCaseImpl(service: AppleAuthServiceImpl())
        fetchSocialCredentialUseCase.execute()
            .subscribe(onNext: { response in
                data = response
                print("Apple response data: \(data)")
                expectation.fulfill()
            },onError: { error in
                print("Apple error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [expectation])
        XCTAssertNotNil(data)
    }
}
