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
        AppDIContainer.shared.register(type: Animal.self, component: Dog(name: "백구"))
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAppDIContainer() {
        let dog = AppDIContainer.shared.resolve(type: Animal.self)
        XCTAssertTrue(dog.name == "백구")
    }
    
    func testChangeAppDIConainer() {
        AppDIContainer.shared.register(type: Animal.self, component: Cat(name: "나비"))
        let cat = AppDIContainer.shared.resolve(type: Animal.self)
        XCTAssertTrue(cat.name == "나비")
    }
}
