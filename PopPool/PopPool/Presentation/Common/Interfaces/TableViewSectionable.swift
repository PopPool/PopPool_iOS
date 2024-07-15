//
//  TableViewSectionable.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import UIKit
import RxSwift

protocol TableViewSectionable: Inputable, Outputable {
    associatedtype CellType: Cellable, UITableViewCell
    
    // Section의 Header와 Footer에 필요한 Input
    var sectionInput: Input { get set }
    
    // Section의 Cell에 주입할 Input 배열
    var sectionCellInputList: [CellType.Input] { get set }
    
    // Cell의 Output PublishSubject
    var sectionCellOutput: PublishSubject<(CellType.Output, IndexPath)> { get set }
    
    /// Section의 Cell을 Input을 주입한 상태로 리턴하는 메서드
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: indexPath
    /// - Returns: Section Cell
    mutating func getCell(tableView: UITableView, indexPath: IndexPath) -> CellType
    
    /// HeaderView를 생성하는 메서드
    /// - Returns: HeaderView
    mutating func makeHeaderView() -> UIView?
    
    /// FooterView를 생성하는 메서드
    /// - Returns: FooterView
    mutating func makeFooterView() -> UIView?
    
    /// Header와 Footer의 Output을 리턴하는 메서드
    /// - Returns: Header, Footer Output
    mutating func sectionOutput() -> Output
}

extension TableViewSectionable {
    mutating func getCell(tableView: UITableView, indexPath: IndexPath) -> CellType {
        tableView.register(CellType.self, forCellReuseIdentifier: CellType.identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as! CellType
        let input = sectionCellInputList[indexPath.row]
        cell.injectionWith(input: input)
        self.sectionCellOutput.onNext((cell.getOutput(), indexPath))
        return cell
    }
}
