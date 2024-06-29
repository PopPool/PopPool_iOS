//
//  ModalAlertCPNT.swift
//  PopPool
//
//  Created by Porori on 6/28/24.
//

import Foundation
import UIKit

// MARK: - Properties
class ModalAlertCPNT: UIViewController {
    // 모달 화면 뒷 배경
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    // 전체 콘텐츠를 감싸는 View
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let titleLabel = ContentTitleCPNT(title: "오류가 있습니다\n화면을 새로 고쳐주세요", type: .title_bs(buttonImage: nil))
    
    // 교체가 가능한 View
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let minimumHeight: CGFloat = 80
    private let maxDimAlpha: CGFloat = 0.8
}

// MARK: - Lifecycle
extension ModalAlertCPNT {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupGestures()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresent()
    }
}

// MARK: - Methods
extension ModalAlertCPNT {
    private func setupLayout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.greaterThanOrEqualTo(view.snp.top).inset(minimumHeight)
        }
        
        containerView.addSubview(stack)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(contentView)
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
    func setContent(content: UIView) {
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        view.layoutIfNeeded()
    }
    
    private func animatePresent() {
        dimmedView.alpha = 0
        
        containerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.containerView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = self.maxDimAlpha
        }
    }
    
    func dismissBottomSheet() {
        UIView.animate(withDuration: 0.2, animations: {  [weak self] in
            guard let self = self else { return }
            self.containerView.frame.origin.y = self.view.frame.height
        }, completion: {  [weak self] _ in
            self?.dismiss(animated: false)
        })
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDimmedView))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapDimmedView() {
        self.dismissBottomSheet()
    }
}

extension UIViewController {
    func presentViewControllerModally(vc: UIViewController) {
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
}
