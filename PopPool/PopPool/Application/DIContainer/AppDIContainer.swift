//
//  AppDIContainer.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

import Foundation

protocol DIContainer {
    /// 특정 타입에 대한 컴포넌트를 등록합니다.
    /// - Parameters:
    ///   - type: 컴포넌트를 등록할 타입.
    ///   - component: 등록할 컴포넌트 인스턴스.
    func register<T>(type: T.Type, component: AnyObject)
    
    /// 특정 타입에 대한 컴포넌트를 반환합니다.
    /// - Parameter type: 반환할 컴포넌트의 타입.
    /// - Returns: 반환된 컴포넌트 인스턴스.
    func resolve<T>(type: T.Type) -> T
}

final class AppDIContainer: DIContainer {
    
    // AppDIContainer의 싱글톤 인스턴스
    static let shared = AppDIContainer()
    
    // 인스턴스 생성을 방지하기 위한 private 초기화 함수
    private init() {}
    
    // 등록된 서비스를 저장할 딕셔너리
    private var services: [String: AnyObject] = [:]
    
    func register<T>(type: T.Type, component: AnyObject) {
        let key = "\(type)"
        services[key] = component
    }
    
    func resolve<T>(type: T.Type) -> T {
        let key = "\(type)"
        return services[key] as! T
    }
}

extension AppDelegate {
    /// DI 컨테이너 인스턴스를 등록합니다.
    func registerDIContainer() {
        let container = AppDIContainer.shared
    }
}
