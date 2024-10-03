//
//  AdminPostVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/9/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import PhotosUI

final class AdminPostVC: BaseViewController {
    //    owner.checkValidation()
    // MARK: - properties
    private let titleText: BehaviorRelay<String?> = .init(value: nil)
    private let images: BehaviorRelay<[UIImage?]> = .init(value: [])
    private let mainImageIndex: BehaviorRelay<Int> = .init(value: -1)
    private let selectCategory: BehaviorRelay<String> = .init(value: "카테고리")
    private let address: BehaviorRelay<String?> = .init(value: nil)
    private let latitude: BehaviorRelay<Double?> = .init(value: nil)
    private let longitude: BehaviorRelay<Double?> = .init(value: nil)
    private let bannerYn: BehaviorRelay<Bool> = .init(value: false)
    private let markerName: BehaviorRelay<String?> = .init(value: nil)
    private let snippet: BehaviorRelay<String?> = .init(value: nil)
    private let startDate: BehaviorRelay<String?> = .init(value: nil)
    private let endDate: BehaviorRelay<String?> = .init(value: nil)
    private let descriptionText: BehaviorRelay<String?> = .init(value: nil)
    
    let imageViewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    // 돌아가기 버튼 추가
    private let backButton: UIButton = {
          let button = UIButton(type: .system)
          button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
          button.tintColor = .black
          return button
      }()

    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .init(hexCode: "#D9D9D9", alpha: 0.3)
        textField.placeholder = "이름"
        return textField
    }()
    
    let imageChoiceButton: ButtonCPNT = {
        let button = ButtonCPNT(type: .primary, title: "이미지")
        button.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        return button
    }()
    let categoryChoiceButton: ButtonCPNT = {
        let button = ButtonCPNT(type: .primary, title: "카테고리")
        button.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        return button
    }()
    
    let addressTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .init(hexCode: "#D9D9D9", alpha: 0.3)
        textField.placeholder = "주소"
        return textField
    }()
    
    let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .init(hexCode: "#D9D9D9", alpha: 0.3)
        textField.placeholder = "위도"
        return textField
    }()
    
    let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .init(hexCode: "#D9D9D9", alpha: 0.3)
        textField.placeholder = "경도"
        return textField
    }()
    
    let markerNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .init(hexCode: "#D9D9D9", alpha: 0.3)
        textField.placeholder = "마커명"
        return textField
    }()
    
    let snippetTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .init(hexCode: "#D9D9D9", alpha: 0.3)
        textField.placeholder = "스니펫"
        return textField
    }()
    let startDateChoiceButton: ButtonCPNT = {
        let button = ButtonCPNT(type: .primary, title: "시작날짜")
        button.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        return button
    }()
    
    let endDateChoiceButton: ButtonCPNT = {
        let button = ButtonCPNT(type: .primary, title: "종료날짜")
        button.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        return button
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "설명"
        return label
    }()
    let descriptionTextView: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .init(hexCode: "#D9D9D9", alpha: 0.3)
        textField.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        return textField
    }()
    let saveButton: ButtonCPNT = {
        let button = ButtonCPNT(type: .primary, title: "저장", disabledTitle: "저장")
        button.isEnabled = false
        return button
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
    
    func setUp() {
        self.navigationController?.navigationBar.isHidden = false
//        view.addSubview(backButton)

        imageViewCollectionView.dataSource = self
        imageViewCollectionView.delegate = self
        imageViewCollectionView.register(AdminImageViewCollectionViewCell.self, forCellWithReuseIdentifier: AdminImageViewCollectionViewCell.identifier)
    }
    

    func setUpConstraints() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).inset(-16)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        contentView.addSubview(imageViewCollectionView)
        imageViewCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(imageViewCollectionView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }

        backButton.snp.makeConstraints { make in
                  make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
                  make.leading.equalToSuperview().offset(20)
                  make.size.equalTo(44)
              }
        contentStackView.addArrangedSubview(titleTextField)
        contentStackView.addArrangedSubview(imageChoiceButton)
        contentStackView.addArrangedSubview(categoryChoiceButton)
        contentStackView.addArrangedSubview(addressTextField)
        contentStackView.addArrangedSubview(latitudeTextField)
        contentStackView.addArrangedSubview(longitudeTextField)
        contentStackView.addArrangedSubview(markerNameTextField)
        contentStackView.addArrangedSubview(snippetTextField)
        contentStackView.addArrangedSubview(startDateChoiceButton)
        contentStackView.addArrangedSubview(endDateChoiceButton)
        contentStackView.addArrangedSubview(descriptionTitleLabel)
        contentStackView.addArrangedSubview(descriptionTextView)
        contentStackView.addArrangedSubview(backButton)
    }


    private func setupBackButton() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }


    func bind() {
        imageChoiceButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.images.accept([])
                owner.mainImageIndex.accept(-1)
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                configuration.selectionLimit = 15
                
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = owner
                owner.present(picker, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        images
            .withUnretained(self)
            .subscribe { (owner, images) in
                owner.imageViewCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        categoryChoiceButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let data = [
                    "패션",
                    "라이프스타일",
                    "스포츠",
                    "라이프스타일",
                    "패션",
                    "예술",
                    "여행",
                    "애니메이션",
                    "키즈",
                    "뷰티",
                    "패션",
                    "라이프스타일",
                    "뷰티",
                    "패션",
                    "반려동물"
                ]
                let alert = UIAlertController(title: "Pick a Category", message: nil, preferredStyle: .actionSheet)
                
                // 각 항목을 UIAlertAction으로 추가
                for item in data {
                    let action = UIAlertAction(title: item, style: .default) { _ in
                        owner.categoryChoiceButton.setTitle(item, for: .normal)
                        owner.selectCategory.accept(item)
                    }
                    alert.addAction(action)
                }
                
                // 취소 버튼 추가
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    owner.categoryChoiceButton.setTitle("카테고리", for: .normal)
                    owner.selectCategory.accept("카테고리")
                }
                alert.addAction(cancelAction)
                
                // UIAlertController 표시
                self.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        startDateChoiceButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let alert = UIAlertController(title: "Pick a Date", message: "\n\n\n\n\n\n", preferredStyle: .alert)
                
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .dateAndTime
                
                datePicker.preferredDatePickerStyle = .compact
                
                alert.view.addSubview(datePicker)
                datePicker.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
                
                // 확인 버튼 추가
                let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
                    let selectedDate = datePicker.date
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YYYY-MM-dd'T'HH:MM:ss.SSSSSS"
                    formatter.locale = Locale(identifier: "ko")
                    let dateString = formatter.string(from: selectedDate)
                    owner.startDateChoiceButton.setTitle(dateString, for: .normal)
                    owner.startDate.accept(dateString)
                }
                
                // 취소 버튼 추가
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    owner.startDate.accept(nil)
                    owner.startDateChoiceButton.setTitle("시작날짜", for: .normal)
                }
                
                alert.addAction(selectAction)
                alert.addAction(cancelAction)
                
                // UIAlertController 표시
                owner.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        endDateChoiceButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let alert = UIAlertController(title: "Pick a Date", message: "\n\n\n\n\n\n", preferredStyle: .alert)
                
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .dateAndTime
                
                datePicker.preferredDatePickerStyle = .compact
                
                alert.view.addSubview(datePicker)
                datePicker.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
                
                // 확인 버튼 추가
                let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
                    let selectedDate = datePicker.date
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YYYY-MM-dd'T'HH:MM:ss.SSSSSS"
                    formatter.locale = Locale(identifier: "ko")
                    let dateString = formatter.string(from: selectedDate)
                    owner.endDateChoiceButton.setTitle(dateString, for: .normal)
                    owner.endDate.accept(dateString)
                }
                
                // 취소 버튼 추가
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    owner.endDate.accept(nil)
                    owner.endDateChoiceButton.setTitle("종료날짜", for: .normal)
                }
                
                alert.addAction(selectAction)
                alert.addAction(cancelAction)
                
                // UIAlertController 표시
                owner.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        titleTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, title) in
                if let title = title {
                    if title.count == 0 {
                        owner.titleText.accept(nil)
                    } else {
                        owner.titleText.accept(title)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        addressTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, adress) in
                if let adress = adress {
                    if adress.count == 0 {
                        owner.address.accept(nil)
                    } else {
                        owner.address.accept(adress)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        latitudeTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .subscribe { (owner, latitude) in
                if let latitude = Double(latitude) {
                    owner.latitude.accept(latitude)
                } else {
                    owner.latitude.accept(nil)
                }
            }
            .disposed(by: disposeBag)
        
        longitudeTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .subscribe { (owner, longitude) in
                if let longitude = Double(longitude) {
                    owner.longitude.accept(longitude)
                } else {
                    owner.longitude.accept(nil)
                }
            }
            .disposed(by: disposeBag)
        
        markerNameTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, markerName) in
                if let markerName = markerName {
                    if markerName.count == 0 {
                        owner.markerName.accept(nil)
                    } else {
                        owner.markerName.accept(markerName)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        snippetTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, snippet) in
                if let snippet = snippet {
                    if snippet.count == 0 {
                        owner.snippet.accept(nil)
                    } else {
                        owner.snippet.accept(snippet)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        descriptionTextView.rx.text
            .withUnretained(self)
            .subscribe { (owner, description) in
                if let description = description {
                    if description.count == 0 {
                        owner.descriptionText.accept(nil)
                    } else {
                        owner.descriptionText.accept(description)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        let allRelays: [Observable<Any?>] = [
            titleText.map { $0 as Any? },
            images.map { $0 as Any? },
            mainImageIndex.map { $0 as Any? },
            selectCategory.map { $0 as Any? },
            latitude.map { $0 as Any? },
            longitude.map { $0 as Any? },
            markerName.map { $0 as Any? },
            snippet.map { $0 as Any? },
            startDate.map { $0 as Any? },
            endDate.map { $0 as Any? },
            descriptionText.map { $0 as Any? },
            address.map { $0 as Any? }
        ]
        
        Observable.merge(allRelays.map { $0.asObservable() })
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.checkValidation()
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                if let title = owner.titleText.value,
                   let latitude = owner.latitude.value,
                   let longitude = owner.longitude.value,
                   let startDate = owner.startDate.value,
                   let endDate = owner.endDate.value,
                   let description = owner.descriptionText.value,
                   let adress = owner.address.value,
                   let marker = owner.markerName.value,
                   let snippet = owner.snippet.value
                {

                    let imageService = PreSignedService()
                    var pathList: [String] = []
                    var imageUploadDatas: [PreSignedService.PresignedURLRequest] = []
                    let imageList = owner.images.value.compactMap { $0 }
                    owner.saveButton.isEnabled = false
                    for (index, image) in imageList.enumerated() {
                        let path = "PopUpImage/\(title)/\(index)"
                        pathList.append(path)
                        imageUploadDatas.append(.init(filePath: path, image: image))
                    }
                    
                    imageService.tryUpload(datas: imageUploadDatas)
                        .subscribe { _ in
                            print("ImageUploadSuccess")
                            let repository = AdminRepositoryImpl()
                            let newPopUp = CreatePopUpStoreRequestDTO(
                                name: title,
                                category: owner.selectCategory.value,
                                desc: description,
                                address: adress,
                                startDate: startDate,
                                endDate: endDate,
                                mainImageUrl: pathList[owner.mainImageIndex.value],
                                bannerYn: owner.bannerYn.value,
                                imageUrlList: pathList,
                                latitude: latitude,
                                longitude: longitude,
                                markerTitle: marker,
                                markerSnippet: snippet
                            )
                            print(newPopUp)
                            repository.postPopUpStore(createPopUp: newPopUp)
                                .subscribe {
                                    ToastMSGManager.createToast(message: "등록성공")
                                    owner.navigationController?.popViewController(animated: true)
                                } onError: { _ in
                                    ToastMSGManager.createToast(message: "등록실패")
                                    imageService.tryDelete(targetPaths: .init(objectKeyList: pathList))
                                        .subscribe {
                                            print("이미지 삭제 완료")
                                        } onError: { _ in
                                            print("이미지 삭제 오류")
                                        }
                                        .disposed(by: owner.disposeBag)
                                }
                                .disposed(by: owner.disposeBag)
                        } onFailure: { _ in
                            print("ImageUploadFail")
                            ToastMSGManager.createToast(message: "ImageUploadFail")
                        }
                        .disposed(by: owner.disposeBag)
                    
                    
                }
            }
            .disposed(by: disposeBag)
        // 백 버튼 바인딩 추가
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

    }
    
    func checkValidation() {
        if let title = titleText.value,
           let latitude = latitude.value,
           let longitude = longitude.value,
           let startDate = startDate.value,
           let endDate = endDate.value,
           let description = descriptionText.value,
           let adress = address.value,
           let marker = markerName.value,
           let snippet = snippet.value
        {
            
            if images.value.count != 0 &&
                mainImageIndex.value != -1 &&
                selectCategory.value != "카테고리" &&
                description.count != 0
            {
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
        } else {
            saveButton.isEnabled = false
        }
    }
}


extension AdminPostVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminImageViewCollectionViewCell.identifier, for: indexPath) as! AdminImageViewCollectionViewCell
        cell.injectionWith(input: .init(image: images.value[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainImageIndex.accept(indexPath.row)
    }
}

extension AdminPostVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let itemProviders = results.map(\.itemProvider)
        var images: [UIImage?] = []
        for itemProvider in itemProviders {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            images.append(image)
                            if itemProviders.count == images.count {
                                self?.images.accept(images)
                            }
                        }
                    }
                }
            }
        }
    }
}

