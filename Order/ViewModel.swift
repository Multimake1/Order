//
//  ViewModel.swift
//  Order
//
//  Created by Арсений on 16.10.2024.
//

import Foundation

class ViewModel {
    var closure: ((Bool) -> Void)?
    
    lazy var cellViewModels = [TableViewModel]()
    
    var selectedPromos = [String]()
    
    func togglePromo(value: Bool, id: String) {
        guard let index = cellViewModels.firstIndex(where: { value in
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
        
        let element = cellViewModels[index].type
        switch element {
        case .promo(var promo):
            //var promo = promo
            //promo.isActive = !promo.isActive
            promo.isActive.toggle()
            cellViewModels.remove(at: index)
            cellViewModels.insert(.init(type: .promo(promo)), at: index)
        default:
            break
        }
        
        if value == true,
           self.selectedPromos.contains(where: { $0 == id }) {
            self.selectedPromos.append(id)
        } else if value == false, 
                  let arrayId = self.selectedPromos.firstIndex(where: { $0 == id }) {
            self.selectedPromos.remove(at: arrayId)
        }
        
        //тут логика блокировки свитчей
        /*if self.selectedPromos.count >= 2 {
            
        } else {
            cellViewModels.forEach { element in
                switch element.type {
                case .promo(let promo):
                    if !promo.isActive {
                        
                    }
                }
                
            }
        }*/
        
        updateTotalPrice()
    
    }
    
    func updateTotalPrice() {
        print("ppdsd")
        
        guard let index = cellViewModels.firstIndex(where: { value in
            switch value.type {
            case .totalPrice:
                return true
            default:
                return false
            }
        }) else { return }
        
        let element = cellViewModels[index].type
        switch element {
        case .totalPrice(var totalPrice):
            
            //var totalPrice = totalPrice
            //поменять значение totalPrice
            totalPrice.baseDiscount = 100
            cellViewModels.remove(at: index)
            cellViewModels.insert(.init(type: .totalPrice(totalPrice)), at: index)
            print(cellViewModels)
        default:
            break
        }
    }
    
    func insertOrder(with order: Order) {
        self.cellViewModels.append(.init(type: .info(.init(title: "Промокоды", info: "На один товар можно применить только один промокод"))))
        self.cellViewModels.append(.init(type: .applyPromo(.init(titleApply: "Применить промокод"))))
        let promocodes = order.promocodes.map {
            TableViewModel.ViewModelType.Promo(title: $0.title,
                                               percent: $0.percent,
                                               endDate: $0.endDate,
                                               info: $0.info ?? "",
                                               isActive: $0.active,
            toggle: { [weak self] value, id in
                self?.togglePromo(value: value, id: id)
            })
        }
        promocodes.forEach { element in
            self.cellViewModels.append(.init(type: .promo(element)))
        }
        self.cellViewModels.append(.init(type: .hidePromo(.init(titleHide: "Скрыть промокоды"))))
        let products = order.products.map {
            TableViewModel.ViewModelType.Products.Product(price: $0.price,
                                                          title: $0.title)
        }
        self.cellViewModels.append(.init(type: .totalPrice(.init(promocodes: promocodes, products: products, baseDiscount: order.baseDiscount, paymentMethodDiscount: order.paymentDiscount))))
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
            var isActive: Bool
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
            
            func getDate(endDate: Date) -> String {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.dateStyle = .short
                formatter.dateFormat = "d MMMM"
                return formatter.string(from: endDate)
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
            var baseDiscount: Double?
            let paymentMethodDiscount: Double?
            
            func productPrice() -> Double {
                var productsPrice: Double = 0
                for product in products {
                    productsPrice = productsPrice + product.price
                }
                return productsPrice
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
            
            func priceOfProductsString() -> String {
                let priceString: String
                if products.count == 1 {
                    priceString = "Цена за " + "\(products.count)" + " товар"
                } else if products.count == 2 || products.count == 3 || products.count == 4 {
                    priceString = "Цена за " + "\(products.count)" + " товара"
                } else {
                    priceString = "Цена за " + "\(products.count)" + " товаров"
                }
                return priceString
            }
            
            func numberOfProducts() -> Int {
                return products.count
            }
            
            func productPriceString() -> String {
                let productPriceString: String
                productPriceString = "\(Int(productPrice()))" + " ₽"
                return productPriceString
            }
            
            func baseDiscountString() -> String {
                let baseDiscountString: String
                baseDiscountString = "-" + "\(Int(baseDiscount ?? 0))" + " ₽"
                return baseDiscountString
            }
            
            func promocodesDiscountString() -> String {
                let promocodesDiscountString: String
                promocodesDiscountString = "-" + "\(Int(promocodesDiscountCount()))" + " ₽"
                return promocodesDiscountString
            }
            
            func paymentDiscountString() -> String {
                let paymentDiscountString: String
                paymentDiscountString = "-" + "\(Int(paymentMethodDiscount ?? 0))" + " ₽"
                return paymentDiscountString
            }
            
            func totalPriceString() -> String {
                let totalPriceString: String
                totalPriceString = "\(Int(totalPrice()))" + " ₽"
                return totalPriceString
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
