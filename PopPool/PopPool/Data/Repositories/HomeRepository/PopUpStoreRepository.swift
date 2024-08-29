import RxSwift

protocol PopUpStoreRepository {
    /// 주어진 검색어를 기반으로 팝업 스토어 목록을 가져옵니다.
    /// - Parameter query: 검색어
    /// - Returns: 검색된 팝업 스토어 목록
    func searchPopUpStores(query: String) -> Observable<[PopUpStore]>
}
