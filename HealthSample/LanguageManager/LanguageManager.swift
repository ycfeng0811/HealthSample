//
//  LanguageManager.swift
//  HealthSample
//
//  Created by YCFeng on 2021/4/1.
//

import Foundation
import RxCocoa
import RxSwift

enum Language {
    case en_us
    case zh_tw
    static var `default`: Language {
        let _default = Locale.preferredLanguages[0]
        if _default == "en" {
            return Language.en_us
        } else {
            return Language.zh_tw
        }
        
    }
    var languageText: LanguageSymbol {
        switch self {
        case .en_us:
            return EN_US()
        case .zh_tw:
            return ZH_TW()
        }
    }
}

class LanguageManager {
    
    static var languageText: LanguageSymbol { return shared.language.value.languageText }
    static let shared = LanguageManager()
    private let bag = DisposeBag()
    
    init() {
        language.asObservable().debug().subscribe { [unowned self] _language in
            
        }.disposed(by: bag)

    }
  
    lazy var language: BehaviorRelay<Language> = {
        return BehaviorRelay<Language>.init(value: Language.default)
    }()
}

protocol LanguageSymbol {
    var egc: String { get set }
}

class EN_US: LanguageSymbol {
    var egc = "ECG"
}

class ZH_TW: LanguageSymbol {
    var egc = "心電圖"
}
