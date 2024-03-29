//
//  MainViewController.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import UIKit
import SwiftMessages

class WeatherViewController: UITableViewController {
    
    var searchVC: UISearchController!
    var resultVC: ResultViewController!
    
    private let cellIdentifier = String(describing: WeatherCell.self)
    private let estimateCellHeight: CGFloat = 120
    
    lazy var viewModel = {
        return WeatherViewModel()
    }()
    
    lazy var refreshVC: UIRefreshControl = {
        let vc = UIRefreshControl()
        vc.tintColor = .systemPurple
        vc.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup network listener
        NotificationCenter.default.addObserver(self, selector: #selector(networkSubscriber), name: .networkStatus, object: nil)
        setupKeyboardObserver()
        initData()
    }
    
    private func setupSearchViewController() {
        guard let resultVC = storyboard?.instantiateViewController(withIdentifier:
                                                                    String(describing: ResultViewController.self)) as? ResultViewController else { return }
        resultVC.delegate = self
        self.resultVC = resultVC
        
        searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.delegate = self
        if let osVersion = Float(UIDevice.current.systemVersion), osVersion < 15 {
            searchVC.obscuresBackgroundDuringPresentation = false
        }
        searchVC.searchResultsUpdater = self
        searchVC.automaticallyShowsCancelButton = false
        searchVC.searchBar.searchTextField.clearButtonMode = .never
        searchVC.searchBar.autocapitalizationType = .none
        searchVC.searchBar.delegate = self // Observe when the search button is tapped.
        searchVC.searchBar.placeholder = String.stringByKey(key: .searchBarPlaceHolder)
        
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchVC
        
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         */
        
        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true
    }
    
    private func initData() {
        LoadingView.shared.startLoadingVia(parentView: view)
        
        // Setup search view controller
        setupSearchViewController()
        
        // Setup table view
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
//        tableView.backgroundColor = UIColor(named: "#EFFAFD")
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = estimateCellHeight
        tableView.tableFooterView = UIView()
        
        // Setup refresh control
        tableView.refreshControl = refreshVC
        
        // First time load data from server
        fetchData()
        
        LoadingView.shared.stopLoading()
    }
    
    // MARK: Data
    @objc func fetchData() {
        viewModel.fetchWeather {[weak self] result in
            DispatchQueue.main.async {
                if result.isEmpty {
                    self?.tableView.reloadData()
                } else {
                    self?.showMessageBaseOn(type: .error, message: result)
                }
                self?.refreshVC.endRefreshing()
            }
            LoadingView.shared.stopLoading()
        }
    }
    
    // MARK: Network
    @objc private func networkSubscriber(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Bool] {
            for (key, value) in data {
                if key == "isLost" && value == true {
                    showMessageBaseOn(type: .warning, message: String.stringByKey(key: .dialogLostInternet))
                    viewModel.isNetworkBack = true
                } else if key == "isLost" && value == false && viewModel.isNetworkBack {
                    showMessageBaseOn(type: .info, message: String.stringByKey(key: .dialogInternetComeback))
                    viewModel.isNetworkBack = false
                }
            }
        }
    }
    
    // MARK: Utils
    private func setupKeyboardObserver() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        searchVC.searchBar.endEditing(true)
    }
    
}

// MARK: - Table view data source & delegate
extension WeatherViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrWeather.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                as? WeatherCell else { return UITableViewCell() }
        cell.weather = viewModel.arrWeather[indexPath.row]
        return cell
    }
}

extension WeatherViewController: ResultViewControllerDelegate {
    func finishChooseCity(coordinate: (Float, Float)) {
        resetSearchUi()
        viewModel.currentCoordinate = coordinate
        LoadingView.shared.startLoadingVia(parentView: view)
        fetchData()
    }
    
    private func resetSearchUi() {
        searchVC.searchBar.endEditing(true)
        searchVC.searchBar.text = nil
        searchVC.searchBar.placeholder = String.stringByKey(key: .searchBarPlaceHolder)
        //        self.dismiss(animated: false)
    }
}

