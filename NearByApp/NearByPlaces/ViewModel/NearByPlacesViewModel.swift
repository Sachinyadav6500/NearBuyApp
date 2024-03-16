//
//  NearByPlacesViewModel.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

internal protocol NearByPlacesViewModelProtocol {
    var places: [PlaceResponseModel] { get }
    func onPageLoad()
    func onPaiginationTrigger()
    func onSelection(index:Int)
    func onUserInput(text: String, range: String)
}

internal final class NearByPlacesViewModel: NearByPlacesViewModelProtocol {

    private let useCase: NearByPlaceUseCaseType
    private var dataRequested: Bool = false
    private (set) var places: [PlaceResponseModel] = []
    private weak var delegate: NearByPlacesViewProtocol?
    private var paginationInProgress: Bool = false
    private var currentPage: Int = 1
    private var totalLocatios: Int = 1000
    private let cacheService: PlacesCacheServiceType
    private let locationService: LocationManagerProtocol

    init(useCase: NearByPlaceUseCaseType = NearByPlaceUseCase(),
         cacheService: PlacesCacheServiceType = PlacesCacheService(),
         locationService: LocationManagerProtocol =  LocationManager.sharedInstance,
         delegate: NearByPlacesViewProtocol) {
        self.useCase = useCase
        self.cacheService = cacheService
        self.locationService = locationService
        self.delegate = delegate
    }
    
    internal func onPageLoad() {
        // TODO: Return the data stored in persistance.
        delegate?.showLoader()
        locationService.delegate = self
        locationService.requestLocation()
        dataRequested = true
    }
    
    internal func onPaiginationTrigger() {
        delegate?.showLoader()
        guard !paginationInProgress, totalLocatios > places.count else {
            delegate?.hideLoader()
            return
        }
        
        paginationInProgress = true
        dataRequested = true
        getNearByVenueData(page: currentPage)
    }
    
    func onSelection(index:Int) {
        guard places.count >= index,
              let urlString = places[index].url,
              let url = URL(string: urlString)
        else {return}
        self.delegate?.gotoBooking(url: url)
    }

    internal func onUserInput(text: String, range: String){
        // TODO: Cancel OnGoing Api Call and call again to fetch data and reset pagination
        getNearByVenueData(page: 1, query: text, range: range)
    }
    
    private func getNearByVenueData(page: Int = 1, query:String? = nil, range: String = "15mi") {
        guard let currentLocation = locationService.getCurrentLocation() else {
            // TODO: Return the data stored in persistance.
            // Currently fake method added
            cacheService.fetchSavedPlacesData { [weak self] cachedData in
                self?.places = cachedData
                self?.delegate?.showResultsForNearByVenue()
            }
            return
        }
        dataRequested = false
        paginationInProgress = false
        let requestModel = NearByPlaceRequestModel(
            page: page,
            lat: "\(currentLocation.lat)",
            lon: "\(currentLocation.lng)",
            range: range,
            query: query
        )
        useCase.getNearByVeneues(
            requestModel: requestModel
        ) { [weak self] result in
            switch result {
            case let .success(responseModel):
                if let page = responseModel.meta?.page, page == 1 {
                    self?.places = responseModel.venues ?? []
                } else {
                    self?.places.append(contentsOf: responseModel.venues ?? [])
                }
                self?.currentPage = (responseModel.meta?.page ?? 1)+1
                self?.totalLocatios = responseModel.meta?.total ?? 1000
                self?.delegate?.showResultsForNearByVenue()
                self?.delegate?.hideLoader()
                
            case let .failure(error):
                print(error)
                
            }
        }
    }
    
}

extension NearByPlacesViewModel: LocationManagerResponseProtocol {
    func locationUpdated() {
        if dataRequested {
            getNearByVenueData()
        }
    }
    
    func locationUpdateFailed() {
        // TODO: Return the data stored in persistance.
        // or else show error
        
        cacheService.fetchSavedPlacesData { [weak self] cachedData in
            self?.places = cachedData
            self?.delegate?.showResultsForNearByVenue()
        }
    }
    
    
}
