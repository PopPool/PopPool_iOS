//
//  AppDIContainerTest.swift
//  PopPoolTests
//
//  Created by SeoJunYoung on 6/1/24.
//

import Foundation
import XCTest

protocol Animal {
    var name:String { get set }
    func cry() -> String
}

class Dog: Animal {
    var name: String
    
    func cry() -> String {
        return "멍멍"
    }
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print(self, "deinit")
    }
}

class Cat: Animal {
    var name: String
    
    func cry() -> String {
        return "야옹"
    }
    
    init(name: String) {
        self.name = name
    }
}

final class AppDIContainerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// Dog 인스턴스 등록 후 반환 값 확인
    func testAppDIContainer() {
        AppDIContainer.shared.register(type: Animal.self, component: Dog(name: "백구"))
        let dog = AppDIContainer.shared.resolve(type: Animal.self)
        XCTAssertTrue(dog.name == "백구")
    }
    
    /// Dog 인스턴스 등록 후 Cat 인스턴스로 변경 후 반환 값 확인
    func testChangeAppDIConainer() {
        AppDIContainer.shared.register(type: Animal.self, component: Cat(name: "나비"))
        let cat = AppDIContainer.shared.resolve(type: Animal.self)
        XCTAssertTrue(cat.name == "나비")
    }
    
    /// 식별자로 강아지, 고양이 등록후 반환 값 확인
    func testIdentifier() {
        AppDIContainer.shared.register(type: Animal.self, identifier: "강아지", component: Dog(name: "백구"))
        AppDIContainer.shared.register(type: Animal.self, identifier: "고양이", component: Cat(name: "나비"))
        let dog = AppDIContainer.shared.resolve(type: Animal.self, identifier: "강아지")
        let cat = AppDIContainer.shared.resolve(type: Animal.self, identifier: "고양이")
        XCTAssertTrue(cat.name == "나비" && dog.name == "백구")
    }
}
