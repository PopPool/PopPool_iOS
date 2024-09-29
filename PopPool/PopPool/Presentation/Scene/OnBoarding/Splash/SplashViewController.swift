//
//  _@_@_.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import UIKit
import SnapKit
import Lottie

final class SplashViewController: UIViewController {
    
    let splashAnimation: LottieAnimationView = {
        let view = LottieAnimationView(name: Constants.lottie.splashAnimation)
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        
        // 조금 더 수월한 이동을 위해 수정할 예정
        splashAnimation.play { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.splashAnimation.alpha = 0
            }, completion: { _ in
                self.splashAnimation.alpha = 1
                self.splashAnimation.removeFromSuperview()
                self.view.alpha = 1
                
                guard let window = UIApplication.shared.windows.first else { return }
                let LoginVC = UINavigationController(
                    rootViewController: LoginVC(viewModel: LoginVM(), provider: ProviderImpl(), tokenInterceptor: TokenInterceptor())
                )
                window.rootViewController = LoginVC
            })
        }
    }
    
    private func setUp() {
        view.backgroundColor = .blu500
    }
    
    private func setUpConstraint() {
        view.addSubview(splashAnimation)
        splashAnimation.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
