//
//  ConcentrationThemeChooseControllerViewController.swift
//  assignment_1
//
//  Created by Chen Shoresh on 11/07/2021.
//

import UIKit

class ConcentrationThemeChooseControllerViewController: UIViewController {
    
    
    let themes = [
        "Food":"🍔🍟🍕🥗🌯🍜🥟🍤🍦🍫🍿🍪🥠🥘🧀",
        "Animals":"🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐮🦁🐸🐵🐨🐧",
        "Faces":"😍🤪😎🥸🥳🤓🤩😡🥶😱🤯😶😴😷🤑",
        "Vehicles":"🚗🚎🚒🚛🚜✈️⛴🚤🛴🦼🛵🚲🛺🚔🚠",
        "Flags":"🇮🇱🇱🇷🇳🇮🇳🇿🇿🇦🇹🇹🇺🇸🇾🇪🇳🇪🇱🇮🇬🇫🇪🇹🇬🇵🇬🇹🇭🇰",
        "Clothes":"👚👕👖🩳👠🩴👘👙🧤🧦👒👜👗👢🥾"
        
    ]
    
    @IBAction func changrTheme(_ sender: Any) {
        if let cvc = stackConcentrationViewcontroller {
            if let themename = (sender as? UIButton)?.currentTitle, let theme = themes[themename] {
                cvc.theme = theme
            }
        }else if let cvc = lastSeguedToConcentrationViewController {
            if let themename = (sender as? UIButton)?.currentTitle, let theme = themes[themename] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
            
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
            
        }
        
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    private var stackConcentrationViewcontroller: ConcentrationViewController? {
        return navigationController?.viewControllers.last as? ConcentrationViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle , let theme = themes[themeName]{
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    cvc.setLastTheme()
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
    
    
}


