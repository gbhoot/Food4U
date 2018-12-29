//
//  SideBarView.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class SideBarView: UIView {
   
   var width      : CGFloat = 0
   var height     : CGFloat = 0
   var y          : CGFloat = 0
   var tableView  : UITableView = UITableView()
   let items      : [String] = ["Home", "Shopping List"]
    
   var delegate: SideBarIndexSelected?
   
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   func setUpFrame(viewFrame: CGRect, hamburgetBtnFrame: CGRect){
      self.width  = viewFrame.width - hamburgetBtnFrame.width
      self.y      = 20
      self.height = viewFrame.height - 20
      self.frame  = CGRect(x: -width, y: y, width: width, height: height )
      self.alpha  = 0
      self.backgroundColor = UIColor.red
      
      setUpTableView()
   }
   
   func setUpTableView(){
      tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height), style: .grouped)
      self.addSubview(tableView)
      self.tableView.delegate    = self
      self.tableView.dataSource  = self
      self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
   }
   
   func slideOut(){
      self.alpha = 0
      self.frame  = CGRect(x: -width, y: y, width: width, height: height )
   }
   
   func slideIn(){
      self.alpha = 1
      self.frame  = CGRect(x: 0, y: y, width: width, height: height )
   }
   

}

extension SideBarView : UITableViewDelegate, UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return items.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.selectionStyle = .none
      cell.textLabel?.text = items[indexPath.row]
      cell.accessoryType   = UITableViewCell.AccessoryType.disclosureIndicator
      return cell
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            delegate?.closeSideBar(forIndexName: "shoppingList")
        } else if indexPath.row == 0 {
            delegate?.closeSideBar(forIndexName: "home")
        }
    }
}
