//
//  HomeAlertVM.swift
//  PopPool
//
//  Created by Porori on 8/8/24.
//

import Foundation
import RxSwift

class HomeAlertVM: ViewModelable {
    
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
    
    struct AlertData {
        let title: String
        let description: String
        let date: String
        var dateString: String = ""
    }
    
    struct Input {
        
    }
    
    struct Output {
        let tableData: Observable<[AlertData]>
    }
    
    var todayData: [AlertData] = []
    var allData: [AlertData] = []
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "KO")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init() {
        separateData()
    }
    
    let mockData: [AlertData] = [
        AlertData(
            title: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
            description: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십",
            date: "2024/08/12"),
        AlertData(title: "콘텐츠 타이틀", description: "알린 서브 텍스트", date: "2024/07/08"),
        AlertData(title: "콘텐츠 타이틀2", description: "알린 서브 텍스트2", date: "2023/05/07"),
        AlertData(title: "콘텐츠 타이틀3", description: "알린 서브 텍스트3", date: "2024/08/14")
    ]
    var disposeBag = DisposeBag()
    
    private func separateData() {
        for var item in mockData {
            let formattedDate = dateToString(item.date)
            item.dateString = formattedDate.description
            
            if let itemDate = dateFormatter.date(from: item.date),
               calendar.isDateInToday(itemDate) {
                print("오늘", item)
                todayData.append(item)
            } else {
                print("전체", item)
                allData.append(item)
            }
        }
    }
    
    private func dateToString(_ date: String) -> TimeStamp {
        let today = Date()
        guard let formattedDate = dateFormatter.date(from: date) else {
            return .longTime
        }
        let convertedDay = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour], from: formattedDate, to: today)
        
        print("변환 날짜", convertedDay)
        
        if let year = convertedDay.year, year > 0 {
            return .longTime
        }
        
        if let month = convertedDay.month, month > 0 {
            return .months(month)
        }
        
        if let day = convertedDay.day {
            if day == 0 { return .today }
            if day < 7 { return .days(day) }
            if day < 30 {
                let weeks = day / 7
                return .weeks(weeks)
            }
        }
        
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
