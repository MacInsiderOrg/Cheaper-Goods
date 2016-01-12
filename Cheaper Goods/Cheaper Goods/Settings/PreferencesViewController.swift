//
//  PreferencesViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

struct Preferences {
    static var currentLanguageID = Int()
    static var currentAlertID = Int()
    
    static var language = [
        "ua": [
            "name": "Українська",
            "nav": [
                "sales": "Знижки",
                "stores": "Магазини",
                "favorites": "Вибране",
                "settings": "Налаштування",
                "review": "Відгук"
            ]
        ],
            
        "ru": [
            "name": "Русский",
            "nav": [
                "sales": "Скидки",
                "stores": "Магазины",
                "favorites": "Избранное",
                "settings": "Настройки",
                "review": "Отзыв"
            ]
        ],
            
        "en": [
            "name": "English",
            "nav": [
                "sales": "Sales",
                "stores": "Stores",
                "favorites": "Favorites",
                "settings": "Settings",
                "review": "Review"
            ]
        ]
    ]

}

class PreferencesViewController: UITableViewController {
    
    //static var currentLanguageID = Int()
    //static var currentAlertID = Int()
    var currentLanguage = String()
    var currentAlert = String()

    @IBOutlet weak var basicSettings: SettingsCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
        switch (Preferences.currentLanguageID) {
            case 0:
                self.currentLanguage = "Українська"
            case 1:
                self.currentLanguage = "Русский"
            case 2:
                self.currentLanguage = "English"
            default:
                self.currentLanguage = "Українська"
        }
        
        switch (Preferences.currentAlertID) {
            case 0:
                self.currentAlert = "Один раз в день"
            case 1:
                self.currentAlert = "Двічі на день"
            case 2:
                self.currentAlert = "Один раз в тиждень"
            case 3:
                self.currentAlert = "Один раз в місяць"
            default:
                self.currentAlert = "Один раз в день"
        }
        
        self.basicSettings.languageName?.setTitle(self.currentLanguage, forState: UIControlState.Normal)
        self.basicSettings.alertName?.setTitle(self.currentAlert, forState: UIControlState.Normal)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

