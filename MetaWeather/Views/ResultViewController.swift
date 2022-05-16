//
//  SearchViewController.swift
//  MetaWeather
//
//  Created by David Martin on 19/01/2022.
//

import UIKit

protocol ResultViewControllerDelegate: AnyObject {
    func finishChooseCity(woeid: String)
}

class ResultViewController: UITableViewController {
    let kCellIdentifier = "ResultCell"
    let viewModel = ResultViewModel()
    weak var delegate: ResultViewControllerDelegate?
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.arrLocations[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWoeid = viewModel.arrLocations[indexPath.row].woeid
        delegate?.finishChooseCity(woeid: "\(selectedWoeid)")
        navigationController?.popViewController(animated: false)
    }
}
