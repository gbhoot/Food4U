//
//  UIViewControllerExt.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

extension UIViewController {

   func presentFromBottom(_ viewControllerToPresent: UIViewController, _ viewControllerPresenting: UIViewController) {
      let transition = CATransition()
      transition.duration = DURATION
      transition.type = CATransitionType.push
      transition.subtype = CATransitionSubtype.fromTop
      self.view.window?.layer.add(transition, forKey: kCATransition)

//      guard let presentingVC = viewControllerPresenting as? RecipeInfoViewController else { return }
      present(viewControllerToPresent, animated: false, completion: nil)
   }
   
   func presentFromLeft(_ viewControllerToPresent: UIViewController) {
      let transition = CATransition()
      transition.duration = DURATION
      transition.type = CATransitionType.push
      transition.subtype = CATransitionSubtype.fromRight
      self.view.window?.layer.add(transition, forKey: kCATransition)
      
      present(viewControllerToPresent, animated: false, completion: nil)
   }
   
   func presentFromRight(_ viewControllerToPresent: UIViewController) {
      let transition = CATransition()
      transition.duration = DURATION
      transition.type = CATransitionType.push
      transition.subtype = CATransitionSubtype.fromLeft
      self.view.window?.layer.add(transition, forKey: kCATransition)

      present(viewControllerToPresent, animated: false, completion: nil)
   }
   
   func presentFromTop(_ viewControllerToPresent: UIViewController) {
      let transition = CATransition()
      transition.duration = DURATION
      transition.type = CATransitionType.push
      transition.subtype = CATransitionSubtype.fromBottom
      self.view.window?.layer.add(transition, forKey: kCATransition)

      present(viewControllerToPresent, animated: false, completion: nil)
   }
   
   func dismissVC() {
      let transition = CATransition()
      transition.duration = DURATION
      transition.type = CATransitionType.push
      transition.subtype = CATransitionSubtype.fromBottom
      self.view.window?.layer.add(transition, forKey: kCATransition)
      
      dismiss(animated: false, completion: nil)
   }
    
    func unwindVCFromBottom(unwind: String) {
        let transition = CATransition()
        transition.duration = DURATION
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        performSegue(withIdentifier: unwind, sender: self)
    }
}
