import UIKit

enum ExternalApp {
    case naverMap
    case kakaoMap
    case tMap

    func scheme(with latitude: Double, longitude: Double) -> String {
        switch self {
        case .naverMap:
            return "nmap://place?lat=\(latitude)&lng=\(longitude)&name=popupstore"
        case .kakaoMap:
            return "kakaomap://look?p=\(latitude),\(longitude)"
        case .tMap:
            return "tmap://route?goalx=\(longitude)&goaly=\(latitude)&goalname=popupstore"
        }
    }

    var appStoreURL: String {
        switch self {
        case .naverMap:
            return "https://apps.apple.com/kr/app/id311867728"
        case .kakaoMap:
            return "https://apps.apple.com/kr/app/id304608425"
        case .tMap:
            return "https://apps.apple.com/kr/app/id431589174"
        }
    }
}

class URLSchemeService {
    static func openApp(_ app: ExternalApp, latitude: Double, longitude: Double) {
        let scheme = app.scheme(with: latitude, longitude: longitude)
        let appStoreURL = app.appStoreURL

        if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let appStoreURL = URL(string: appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}



extension UIApplication {
    func openURL(_ urlString: String, fallbackURL: String? = nil) {
        if let url = URL(string: urlString), self.canOpenURL(url) {
            self.open(url, options: [:], completionHandler: nil)
        } else if let fallback = fallbackURL, let fallbackURL = URL(string: fallback) {
            self.open(fallbackURL, options: [:], completionHandler: nil)
        }
    }
}
