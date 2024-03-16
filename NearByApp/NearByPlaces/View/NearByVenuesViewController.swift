//
//  NearByVenuesViewController.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import UIKit

internal protocol NearByPlacesViewProtocol: AnyObject {
    func showResultsForNearByVenue()
    func showLoader()
    func hideLoader()
    func gotoBooking(url:URL)
}

internal final class NearByVenuesViewController: UIViewController {

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var slider: UISlider!

    private var viewModel: NearByPlacesViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        registerTableViewCell()
        setTableViewDelegate()
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        viewModel = NearByPlacesViewModel(delegate: self)
        viewModel?.onPageLoad()
    }
    
    private func registerTableViewCell() {
        tableView.register(UINib(nibName: String(describing: VenueTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VenueTableViewCell.self))
    }
    
    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    @IBAction func onSliderValueChange(slider: UISlider){
        viewModel?.onUserInput(text: searchBar.text ?? "", range: "\(Int(slider.value))mi") // This could have done better this just to save time
    }
}

extension NearByVenuesViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.places.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VenueTableViewCell.self), for: indexPath) as? VenueTableViewCell, let venues = viewModel?.places else {
            return UITableViewCell()
        }
        cell.updateData(venue: venues[indexPath.row])
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let venues = viewModel?.places else {
            return
        }
        if indexPath.row == venues.count - 2 {
            viewModel?.onPaiginationTrigger()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.onSelection(index: indexPath.row)
    }

}


extension NearByVenuesViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel?.onUserInput(text: searchBar.text ?? "", range: "\(Int(slider.value))mi") // This could have done better this just to save time
    }
}

extension NearByVenuesViewController: NearByPlacesViewProtocol {
    func gotoBooking(url: URL) {
        UIApplication.shared.open(url)
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func showResultsForNearByVenue() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
