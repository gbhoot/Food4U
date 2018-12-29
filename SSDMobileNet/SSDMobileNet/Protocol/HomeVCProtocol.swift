//
//  HomeVCProtocol.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import Foundation
import UIKit
protocol HomeVCProtocol {
    func showRecipeDetail(index: Int, section: Int)
}

protocol SideBarIndexSelected {
    func closeSideBar(forIndexName: String)
}

protocol HomeVCFromSliderUp {
    func reloadTableData()
}
