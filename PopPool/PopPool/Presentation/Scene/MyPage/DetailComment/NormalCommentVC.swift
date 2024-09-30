//
//  normalCommentVC.swift
//  PopPool
//
//  Created by Porori on 9/8/24.
//

import UIKit
import RxSwift
import SnapKit
import PhotosUI

final class NormalCommentVC: BaseViewController {
    
    //MARK: - Components
    
    private let header = HeaderViewCPNT(title: "코멘트 작성하기", style: .icon(nil))
    private let scrollView = UIScrollView(frame: .zero)
    private let containerView = UIView()
    
    private let imageHeader: ListTitleViewCPNT
    private let commentHeader: ListTitleViewCPNT
    private let topSectionSpace = UIView()
    private let bottomSectionSpace = UIView()
    
    private var imageCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewLayout())
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return layout
    }()
    
    private lazy var commentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(commentHeader)
        stackView.addArrangedSubview(commentTextfield)
        stackView.addArrangedSubview(commentFooterSpace)
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let commentTextfield = DynamicTextViewCPNT(
        placeholder: "내용을 작성해보세요",
        textLimit: 500)
    
    private lazy var footerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(saveButton)
        stack.addArrangedSubview(footerSpace)
        return stack
    }()
    
    private let saveButton = ButtonCPNT(
        type: .primary,
        title: "저장",
        disabledTitle: "저장")
    
    private let footerSpace = UIView()
    private let commentFooterSpace = UIView()
    
    //MARK: - Properties
    
    private let viewModel: NormalCommentVM
    private let disposeBag = DisposeBag()
    private var imageCount: Int = 0
    
    //MARK: - LifeCycle
    
    init(viewModel: NormalCommentVM) {
        self.viewModel = viewModel
        self.imageHeader = ListTitleViewCPNT(
            title: "사진 선택",
            size: .large(subtitle: "", image: nil))
        self.commentHeader = ListTitleViewCPNT(
            title: "코멘트 작성",
            size: .large(subtitle: "", image: nil))
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        setUpContent()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUp() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        scrollView.delegate = self
        
        imageHeader.rightButton.isHidden = true
        commentHeader.rightButton.isHidden = true
        saveButton.isEnabled = false
        
        imageCollectionView.collectionViewLayout = self.layout
        imageCollectionView.register(CommentImageCell.self,
                                     forCellWithReuseIdentifier: CommentImageCell.identifier)
        imageCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func bind() {
        let input = NormalCommentVM.Input(
            isTextViewFilled: commentTextfield.textView.rx.text,
            returnButtonTapped: header.leftBarButton.rx.tap,
            saveButtonTapped: saveButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        viewModel.popUpStore
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.imageHeader.subTitleLabel.text = "\(data)과 관련있는 사진을 업로드해보세요."
                owner.commentHeader.subTitleLabel.text = "\(data)에 대한 감상평을 작성해주세요."
            })
            .disposed(by: disposeBag)
        
        output.hasText
            .subscribe(onNext: { hasText in
                self.saveButton.isEnabled = hasText
            })
            .disposed(by: disposeBag)
        
        output.returnToHome
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                if owner.commentTextfield.textView.hasText || owner.imageCount != 0 {
                    let vc = DismissCommentModalVC()
                    vc.delegate = self
                    owner.presentModalViewController(viewController: vc)
                } else {
                    owner.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.notifySave
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let imageService = PreSignedService()
                var pathList: [String] = []
                var imageUploadDatas: [PreSignedService.PresignedURLRequest] = []
                
                let newComment = self.viewModel.commentRequest.value
//                let newComment = owner.viewModel.newComment.value
                // 선택된 이미지 데이터 배열에 담기
                owner.viewModel.selectedImages
                    .subscribe { images in
                        for (index, image) in images.enumerated() {
                            let image = UIImage(data: image)!
                            let path = "comment/\(index)\(image)"
                            pathList.append(path)
                            imageUploadDatas.append(.init(
                                filePath: path,
                                image: image
                            ))
                        }
                    }
                
                // AWS preSignedURL에 이미지를 업로드
                imageService.tryUpload(datas: imageUploadDatas)
                    .subscribe(onSuccess: { _ in
                        
                        // 이미지 업로드하며 코멘트 업로드 진행
                        let repository = CommentRepositoryImpl()
                        let popUpStore = CreateCommentRequestDTO(
                            userId: newComment.userId,
                            popUpStoreId: newComment.popUpStoreId,
                            content: newComment.content,
                            commentType: newComment.commentType,
                            imageUrlList: newComment.imageUrlList)
                        
                        repository.postComment(request: popUpStore)
                            .subscribe {
                                print("코멘트 업로드 완료")
                                ToastMSGManager.createToast(message: "코멘트 작성을 완료했어요")
                            }
                            .disposed(by: owner.disposeBag)
                        
                    }, onFailure: { error in
                        print("코멘트 업로드 중 오류")
                        ToastMSGManager.createToast(message: "코멘트 업로드 도중 문제가 발생했어요")
                    })
                    .disposed(by: owner.disposeBag)
                
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.currentImageCount
            .withUnretained(self)
            .subscribe(onNext: { (owner, count) in
                owner.imageCount = count // 이미지 갯수 업데이트
                owner.imageCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpConstraint() {
        view.addSubview(header)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        view.addSubview(footerStack)
        
        header.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        footerSpace.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        footerStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footerStack.snp.top)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    private func setUpContent() {
        containerView.addSubview(topSectionSpace)
        containerView.addSubview(imageHeader)
        containerView.addSubview(imageCollectionView)
        containerView.addSubview(bottomSectionSpace)
        containerView.addSubview(commentStack)
        
        topSectionSpace.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.spaceGuide.small300)
        }
        
        imageHeader.snp.makeConstraints { make in
            make.top.equalTo(topSectionSpace.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        bottomSectionSpace.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.spaceGuide.medium100)
        }
        
        commentFooterSpace.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small300)
        }
        
        commentStack.snp.makeConstraints { make in
            make.top.equalTo(bottomSectionSpace.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension NormalCommentVC: DismissCommentDelegate {
    func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
}

extension NormalCommentVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(imageCount + 1, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentImageCell.identifier, for: indexPath) as? CommentImageCell else { return UICollectionViewCell() }
        
        if indexPath.item < imageCount {
            if let imageData = viewModel.getImage(at: indexPath.item) {
                cell.configure(with: imageData)
            }
        } else {
            let image = UIImage(systemName: "lasso")
            cell.configure(with: nil)
        }
        
        cell.delegate = self
        cell.index = indexPath.item
        return cell
    }
}

// MARK: - CommentImageDelegate

extension NormalCommentVC: CommentImageDelegate {
    
    /// 이미지 갯수 여부에 따라 사진첩 활성화
    func didRequestImage() {
        if imageCount < 5 {
            openPhotoLibrary()
        } else {
            ToastMSGManager.createToast(message: "사진은 최대 5장까지 올릴 수 있어요")
        }
    }
    
    /// 선택된 이미지를 삭제 메서드
    /// - Parameter index: Int 타입의 index 값을 받습니다
    func didRequestRemoval(at index: Int) {
        viewModel.removeImage(at: index)
    }
    
    /// 사진첩 설정 상태에 맞는 권한을 제공하는 메서드
    func openPhotoLibrary() {
        self.isPhotoAuthorizationEnabled() ? self.showFullAccess() : self.grantAccess()
    }
    
    /// 사진첩 설정 상태 확인 메서드
    /// - Returns: Bool 타입 반환
    func isPhotoAuthorizationEnabled() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        return status == .authorized || status == .limited
    }
    
    /// 최초 권한 요청시, 사진첩을 열고 - 아닐 경우 설정 페이지로 이동하는 메서드
    func grantAccess() {
        let currentStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch currentStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    print("허락됐습니다")
                    self.showFullAccess()
                case .limited:
                    print("일부 허락됐습니다")
                    self.showLimitedAccess()
                case .denied, .restricted:
                    print("허락 X")
                    self.denied()
                default:
                    break
                }
            }
        case .denied, .restricted:
            self.denied()
        default:
            break
        }
    }
    
    /// 제한 접근 권한인 경우
    func showLimitedAccess() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    /// 전체 접근 권한인 경우
    func showFullAccess() {
        var configure = PHPickerConfiguration()
        configure.filter = .images
        configure.selectionLimit = 5
        
        DispatchQueue.main.async {
            let phPicker = PHPickerViewController(configuration: configure)
            phPicker.delegate = self
            self.present(phPicker, animated: true)
        }
    }
    
    /// 접근 불가 권한인 경우
    func denied() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            if status == .denied {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "사진 접근 허용 필요",
                        message: "설정에서 사진첩 접근을 허용해주세요.",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    })
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

//MARK: - PHPickerViewControllerDelegate

extension NormalCommentVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
        let dispatchGroup = DispatchGroup()
        
        for item in imageItems {
            dispatchGroup.enter()
            
            item.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage,
                   let imageData = image.jpegData(compressionQuality: 0) {
                    dispatchGroup.notify(queue: .main) {
                        self.viewModel.addImage(imageData)
                    }
                }
                dispatchGroup.leave()
            }
        }
        picker.dismiss(animated: true)
    }
}
