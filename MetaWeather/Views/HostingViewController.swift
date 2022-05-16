//
//  HostingViewController.swift
//  MetaWeather
//
//  Created by David Martin on 25/02/2022.
//

import SwiftUI


class HostingViewController: UIHostingController<NewsView> {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: NewsView())
    }
}
