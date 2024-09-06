//
//  PreSignedTestViewController.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/5/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class PreSignedTestViewController: BaseViewController {
    let service = PreSignedService()
    let disposeBag = DisposeBag()
    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        service.tryUpload(datas: [
            .init(filePath: "TestPath/TestFile1", image: UIImage(systemName: "folder")!),
            .init(filePath: "TestPath/TestFile2", image: UIImage(systemName: "lasso")!),
        ])
            .subscribe { _ in
                print("성공!!!!!")
            } onFailure: { _ in
                print("실패 ㅠㅠㅠㅠㅠㅠ")
            }
            .disposed(by: disposeBag)

//        service.getUploadLinks(request: .init(objectKeyList: ["filePathTest/Test"]))
//            .subscribe { response in
//                print(response)
//            }
//            .disposed(by: disposeBag)
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        service.tryDownload(filePaths: [
            "TestPath/TestFile",
            "TestPath/TestFile1",
            "TestPath/TestFile2"
        ])
            .subscribe { images in
                print("성공 !!!!!!!")
                print(images)
                if let image = images.last {
                    self.imageView.image = image
                }
            } onFailure: { error in
                print("실패 ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ")
            }
            .disposed(by: disposeBag)

    }
}
