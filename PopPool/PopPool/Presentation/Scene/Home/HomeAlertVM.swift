//
//  HomeAlertVM.swift
//  PopPool
//
//  Created by Porori on 8/8/24.
//

import Foundation
import RxSwift

class HomeAlertVM: ViewModelable {
    
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
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
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
        AlertData(title: "콘텐츠 타이틀", description: "알린 서브 텍스트", date: "2024/08/08"),
        AlertData(title: "콘텐츠 타이틀2", description: "알린 서브 텍스트2", date: "2023/05/07")
    ]
    var disposeBag = DisposeBag()
    
    private func separateData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for var item in mockData {
            item.dateString = getRelativeTimeString(from: item.date)
            if let itemDate = dateFormatter.date(from: item.date),
               calendar.isDate(itemDate, inSameDayAs: today) {
                todayData.append(item)
            } else {
                allData.append(item)
            }
        }
    }
    
    func getRelativeTimeString(from dateString: String) -> String {
            guard let date = dateFormatter.date(from: dateString) else {
                return "Invalid date"
            }

            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.day, .hour, .minute], from: date, to: now)

            if let day = components.day, day > 0 {
                return day == 1 ? "1 day ago" : "\(day) days ago"
            } else if let hour = components.hour, hour > 0 {
                return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
            } else if let minute = components.minute, minute > 0 {
                return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
            } else {
                return "Just now"
            }
        }
    
    func transform(input: Input) -> Output {
        let dataOutput = Observable.just(mockData)
        
        return Output(
            tableData: dataOutput
        )
    }
}
