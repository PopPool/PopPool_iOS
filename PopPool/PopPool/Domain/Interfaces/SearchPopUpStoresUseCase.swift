import RxSwift

/// 통합 검색 기능을 제공하는 UseCase를 정의합니다.
protocol SearchPopUpStoresUseCase {
    /// 주어진 검색어를 기반으로 팝업 스토어 목록을 가져옵니다.
    /// - Parameter query: 검색어
    /// - Returns: 검색된 팝업 스토어 목록
    func execute(query: String) -> Observable<[PopUpStore]>
}
