//
//  ViewModel.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    var disposeBag: DisposeBag { get set }
}
