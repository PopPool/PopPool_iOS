//
//  MyPageMainVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/4/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class MyPageMainVC : BaseViewController {
    // MARK: - Components
    private let headerView = HeaderViewCPNT(style: .icon(UIImage(named: "icosolid")))
    private let profileView = UIView()
    private let contentView = UIView()
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.isScrollEnabled = false
        return view
    }()
    
    // MARK: - Properties
    private let profileViewHeight: CGFloat = 200
    private var isCloseProfileView: BehaviorRelay<Bool> = .init(value: false)
    private let disposeBag = DisposeBag()
}

// MARK: - LifeCycle
extension MyPageMainVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        setUpGestures()
        bind()
    }
}

// MARK: - SetUp
private extension MyPageMainVC {
    
    func setUp() {
        self.navigationController?.navigationBar.isHidden = true
        headerView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        contentView.backgroundColor = .red
        view.addSubview(profileView)
        profileView.backgroundColor = .green
        profileView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(profileViewHeight)
        }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(profileViewHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 제스처 설정
    func setUpGestures() {
        let panGesture = UIPanGestureRecognizer()
        contentView.addGestureRecognizer(panGesture)
        
        panGesture.rx.event
            .subscribe(onNext: { [weak self] gesture in
                self?.handlePanGesture(gesture)
            })
            .disposed(by: disposeBag)
    }
    
    func bind() {
        isCloseProfileView
            .withUnretained(self)
            .subscribe { (owner, isClose) in
                owner.tableView.isScrollEnabled = isClose
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ProfileView Animation Methods
private extension MyPageMainVC {
    
    /// 제스처 설정 메서드
    /// - Parameter gesture: 제스처
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentView)
        let defaultClosePoint = headerView.frame.maxY
        /// 드래그 방향을 확인
        let isDraggingDown = translation.y > 0
        let pannedHeight = translation.y
        let currentY: CGFloat = isCloseProfileView.value ? defaultClosePoint : defaultClosePoint + profileViewHeight
        /// 제스처 상태 처리
        switch gesture.state {
        /// 사용자가 드래그 중일 때 호출
        case .changed:
            /// profile View가 열려있는지에 따른 분기 처리
            if isCloseProfileView.value {
                if !isDraggingDown { return }
                if pannedHeight > profileViewHeight { return }
            } else {
                if isDraggingDown { return }
                if pannedHeight < -profileViewHeight { return }
            }
            self.contentView.frame.origin.y = currentY + pannedHeight
        /// 사용자가 드래그를 멈췄을 때 호출
        case .ended:
            /// 최소 이동조건을 충족하면 닫거나 열고, 그렇지 않으면 원래 위치로 이동
            if abs(pannedHeight) >= (profileViewHeight / 3) {
                if isDraggingDown {
                    openProfileView(defaultPoint: defaultClosePoint)
                } else {
                    closeProfileView(defaultPoint: defaultClosePoint)
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.contentView.frame.origin.y = currentY
                })
            }
        default:
            break
        }
    }

    /// profile view를 닫는 animation
    /// - Parameter defaultPoint: 기준이 되는 지점
    func closeProfileView(defaultPoint: CGFloat) {
        isCloseProfileView.accept(true)
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.frame.origin.y = defaultPoint
        })
    }
    
    /// profile view를 여는 animation
    /// /// - Parameter defaultPoint: 기준이 되는 지점
    func openProfileView(defaultPoint: CGFloat) {
        isCloseProfileView.accept(false)
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.frame.origin.y = self.profileViewHeight + defaultPoint
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyPageMainVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "test\(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
        }
    }
}
