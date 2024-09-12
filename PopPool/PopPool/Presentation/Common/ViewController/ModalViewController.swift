//
//  ModalViewController.swift
//  PopPool
//
//  Created by Porori on 6/28/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ModalViewController: BaseViewController {
    
    // MARK: - Components
    /// 메인 바텀 시트 컨테이너 뷰
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    /// 동적 콘텐츠를 담을 뷰
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    /// 상단 바 뷰, 드래그하여 닫을 수 있음
    private lazy var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    /// 어두운 배경 뷰
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    // MARK: - Properties
    /// 어두운 배경 뷰의 최대 alpha 값
    private let maxDimmedAlpha: CGFloat = 0.8
    /// 바텀 시트를 닫을 수 있는 최소 수직 드래그 거리
    private let minDismissiblePanHeight: CGFloat = 20
    /// 상단 에지와 바텀 시트 간의 최소 간격
    private var minTopSpacing: CGFloat = 80
    
    private let disposeBag = DisposeBag()
}

// MARK: - LifeCycle
extension ModalViewController {
    /// 뷰가 로드될 때 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupGestures()
    }
    
    /// 뷰가 나타날 때 호출
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresent()
    }
}

// MARK: - SetUp
private extension ModalViewController {
    /// 뷰 구성 요소 설정
    func setUpViews() {
        view.backgroundColor = .clear
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().dividedBy(minTopSpacing)
        }
        
        mainContainerView.addSubview(topBarView)
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(14)
        }
        
        mainContainerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 제스처 설정
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer()
        dimmedView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.dismissBottomSheet()
            })
            .disposed(by: disposeBag)
        
        let panGesture = UIPanGestureRecognizer()
        topBarView.addGestureRecognizer(panGesture)
        
        panGesture.rx.event
            .subscribe(onNext: { [weak self] gesture in
                self?.handlePanGesture(gesture)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods
extension ModalViewController {
    /// 패닝 제스처를 처리
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        /// 드래그 방향을 확인
        let isDraggingDown = translation.y > 0
        guard isDraggingDown else { return }
        
        let pannedHeight = translation.y
        let currentY = self.view.frame.height - self.mainContainerView.frame.height
        /// 제스처 상태 처리
        switch gesture.state {
        case .changed:
            /// 사용자가 드래그 중일 때 호출
            self.mainContainerView.frame.origin.y = currentY + pannedHeight
        case .ended:
            /// 사용자가 드래그를 멈췄을 때 호출
            /// 조건을 충족하면 닫고, 그렇지 않으면 원래 위치로 이동
            if pannedHeight >= minDismissiblePanHeight {
                dismissBottomSheet()
            } else {
                self.mainContainerView.frame.origin.y = currentY
            }
        default:
            break
        }
    }

    /// 바텀 시트를 표시하는 애니메이션
    private func animatePresent() {
        mainContainerView.alpha = 1
        dimmedView.alpha = 0
        mainContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.mainContainerView.transform = .identity
        }
        /// 부드러운 애니메이션을 위해 더 긴 시간 추가
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    /// 바텀 시트를 닫는 메서드
    func dismissBottomSheet() {
        UIView.animate(withDuration: 0.2, animations: {  [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = self.maxDimmedAlpha
            self.mainContainerView.frame.origin.y = self.view.frame.height
        }, completion: {  [weak self] _ in
            self?.dismiss(animated: false)
        })
    }
    
    /// 서브 뷰 컨트롤러가 이 함수를 호출하여 콘텐츠를 설정
    func setContent(content: UIView) {
        contentView.addSubview(content)
        content.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.leading.trailing.top.equalToSuperview()
        }
        view.layoutIfNeeded()
    }
}

/// UIViewController 확장
extension UIViewController {
    /// 바텀 시트를 표시하는 메서드
    func presentModalViewController(viewController: ModalViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
}
