//
//  ViewModel.swift
//  Order
//
//  Created by Арсений on 16.10.2024.
//

import Foundation

class ViewModel {
    lazy var cellViewModels = [TableViewModel]()
    
    var selectedPromos = [String]()
    
    func togglePromo(value: Bool, id: String) {
        guard let element = cellViewModels.first(where: { value in
            switch value.type {
            case .promo(let promo):
                if promo.id == id {
                    return true
                }
            default:
                return false
            }

            return false
        }) else { return }
        
        if value == true,
           self.selectedPromos.contains(where: { $0 == id }) {
            self.selectedPromos.append(id)
        } else if value == false, 
                  let arrayId = self.selectedPromos.firstIndex(where: { $0 == id }) {
            self.selectedPromos.remove(at: arrayId)
        }
    }
}

struct TableViewModel {
    enum ViewModelType {
        struct Promo {
            let id: String = UUID().uuidString
            let title: String
            let percent: Int
            let endDate: Date?
            let info: String?
            let isActive: Bool
            let toggle: ((Bool, String) -> Void)?
            
            init(title: String,
                 percent: Int,
                 endDate: Date?,
                 info: String?,
                 isActive: Bool,
                 toggle: ((Bool, String) -> Void)? = nil) {
                
                self.title = title
                self.percent = percent
                self.endDate = endDate
                self.info = info
                self.isActive = isActive
                self.toggle = toggle
            }
        }
        
        struct TitleInfo {
            let title: String
            let info: String
        }
        
        struct ApplyPromocode {
            let titleApply: String
        }
        
        struct HidePromo {
            let titleHide: String
        }
        
        struct Products {
            struct Product {
                let price: Double
                let title: String
            }
            
            let promocodes: [Promo]
            let products: [Product]
            let baseDiscount: Double?
            let paymentMethodDiscount: Double?
            
            func productPrice() -> Double {
                var productsPrice: Double? = nil
                for product in products {
                    productsPrice = (productsPrice ?? 0) + product.price
                }
                return productsPrice ?? 0
            }
            
            func promocodesDiscountCount() -> Double {
                var promoDiscount: Double? = nil
                promocodes.forEach { element in
                    if element.isActive == true {
                        promoDiscount = (promoDiscount ?? 0) + (productPrice() * Double(element.percent) / 100)
                    }
                }
                return (promoDiscount ?? 0)
            }
            
            func totalPrice() -> Double {
                return (productPrice() - (paymentMethodDiscount ?? 0) - (baseDiscount ?? 0) - promocodesDiscountCount())
            }
            
            func numberOfProducts() -> Int {
                return products.count
            }
        }
        case info(TitleInfo)
        case applyPromo(ApplyPromocode)
        case promo(Promo)
        case hidePromo(HidePromo)
        case totalPrice(Products)
    }
    var type: ViewModelType
}

enum CheckOrderDataErrors: Error {
    case outOfProducts
    case priceLessThenZero
    case totalPriceLessThenBaseDiscount
    case totalPriceLessThenActivePromos
}
    
struct Order {
    struct Promocode {
        let title: String
        let percent: Int
        let endDate: Date?
        let info: String?
        let active: Bool
        
        init(title: String, percent: Int, endDate: Date?, info: String?, active: Bool) {
            self.title = title
            self.percent = percent
            self.endDate = endDate
            self.info = info
            self.active = active
        }
    }
    
    struct Product {
        let price: Double
        let title: String
        
        init(price: Double, title: String) {
            self.price = price
            self.title = title
        }
    }
    
    init(screenTitle: String, promocodes: [Promocode], products: [Product], paymentDiscount: Double?, baseDiscount: Double?) {
        self.screenTitle = screenTitle
        self.promocodes = promocodes
        self.products = products
        self.paymentDiscount = paymentDiscount
        self.baseDiscount = baseDiscount
    }

    var screenTitle: String
    var promocodes: [Promocode]
    let products: [Product]
    let paymentDiscount: Double?
    let baseDiscount: Double?
    
    func checkOrderData() throws {
        var productsPrice: Double? = nil
        guard products.isEmpty != true else {
            throw CheckOrderDataErrors.outOfProducts
        }
        try products.forEach { element in
            guard element.price > 0 else {
                throw CheckOrderDataErrors.priceLessThenZero
            }
            productsPrice = (productsPrice ?? 0) + element.price
        }
        guard productsPrice ?? 0 > baseDiscount ?? 0 else {
            throw CheckOrderDataErrors.totalPriceLessThenBaseDiscount
        }
        var promoDiscount: Double? = nil
        promocodes.forEach { element in
            if element.active == true {
                promoDiscount = (promoDiscount ?? 0) + ((productsPrice ?? 0) * Double(element.percent) / 100)
            }
        }
        guard (promoDiscount ?? 0) < (productsPrice ?? 0) else {
            throw CheckOrderDataErrors.totalPriceLessThenActivePromos
        }
    }
}
