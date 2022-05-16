//
//  WeatherViewController+UISearchBarDelegate.swift
//  MetaWeather
//
//  Created by David Martin on 25/01/2022.
//

import UIKit

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keywords = searchBar.searchTextField.text else { return }
        LoadingView.shared.startLoadingVia(parentView: self.view)
        viewModel.findCityBy(keyword: keywords) {[weak self] locations in
            DispatchQueue.main.async {
                LoadingView.shared.stopLoading()
                // Send result to Result View Controller
                self?.resultVC.viewModel.arrLocations = locations
                self?.resultVC.tableView.reloadData()
                
                guard let resultVC = self?.resultVC else { return }
                self?.navigationController?.pushViewController(resultVC, animated: false)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Reset search bar and hide keyboard
        searchBar.searchTextField.text = nil
        searchBar.endEditing(true)
    }
}
