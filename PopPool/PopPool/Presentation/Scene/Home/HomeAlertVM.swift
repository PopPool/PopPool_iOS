//
//  HomeAlertVM.swift
//  PopPool
//
//  Created by Porori on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeAlertVM: ViewModelable {
    
    enum TimeStamp {
        case today
        case hours(Int)
        case days(Int)
        case weeks(Int)
        case months(Int)
        case longTime
        
        var description: String {
            switch self {
            case .today:
                return "오늘"
            case .hours(let hours):
                return "\(hours)시간 전"
            case .days(let days):
                return "\(days)일 전"
            case .weeks(let weeks):
                return "\(weeks)주 전"
            case .months(let months):
                return "\(months)개월 전"
            case .longTime:
                return "1년 이상"
            }
        }
    }
    
    // MARK: - AlertData 데이터 구조체
    // DTO 생성 이후 변경 필요
    
    struct AlertData {
        let title: String
        let description: String
        let date: String
        var dateString: String = ""
    }
    
    struct Input {
        let returnToRoot: ControlEvent<Void>
        let moveToNextPage: ControlEvent<Void>
    }
    
    struct Output {
        let tableData: Observable<[AlertData]>
    }
    
    // MARK: - Components
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "KO")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Properties
    
    let mockData: [AlertData] = [
        AlertData(
            title: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
            description: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
            date: "2024/08/12"),
        AlertData(title: "콘텐츠 타이틀", description: "알린 서브 텍스트", date: "2024/07/08"),
        AlertData(title: "콘텐츠 타이틀2", description: "알린 서브 텍스트2", date: "2023/05/07"),
        AlertData(title: "콘텐츠 타이틀3", description: "알린 서브 텍스트3", date: "2024/08/15")
    ]
    
    var todayData: [AlertData] = []
    var allData: [AlertData] = []
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init() {
        separateData()
    }
    
    // MARK: - Methods
    
    /// 데이터를 '오늘, 전체' section으로 구분합니다
    private func separateData() {
        for var item in mockData {
            let formattedDate = dateToString(item.date)
            item.dateString = formattedDate.description
            
            if let itemDate = dateFormatter.date(from: item.date),
               calendar.isDateInToday(itemDate) {
                todayData.append(item)
            } else {
                allData.append(item)
            }
        }
    }
    
    /// 알림 데이터에 활용될 Date를 기간에 따라 특정 문구로 변환합니다

    private func dateToString(_ date: String) -> TimeStamp {
        guard let formattedDate = dateFormatter.date(from: date) else { return .longTime }
        let today = Date()
        
        let convertedDay = calendar
            .dateComponents([.year, .month, .weekOfYear, .day, .hour],
            from: formattedDate,
            to: today)
        
        // 1년 여부 확인
        if let year = convertedDay.year, year > 0 {
            return .longTime
        }
        
        // 1달 여부 확인
        if let month = convertedDay.month, month > 0 {
            return .months(month)
        }
        
        // 하루 여부 확인
        if let day = convertedDay.day {
            if day == 0 { return .today }
            if day < 7 { return .days(day) }
            if day < 30 {
                let weeks = day / 7
                return .weeks(weeks)
            }
        }
        
        // 24시간 이내 여부 확인
        if let hour = convertedDay.hour, hour < 24 {
            return .hours(hour)
        }
        return .longTime
    }
    
    func transform(input: Input) -> Output {
        let dataOutput = Observable.just(mockData)
        
        return Output(
            tableData: dataOutput
        )
    }
}
