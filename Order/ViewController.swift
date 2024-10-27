//
//  ViewController.swift
//  Order
//
//  Created by Арсений on 16.10.2024.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

final class ViewController: UIViewController {
    
    private let viewModel = ViewModel()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(TitleCell.self, forCellReuseIdentifier: String(describing: TitleCell.self))
        tableView.register(ApplyPromocodeCell.self, forCellReuseIdentifier: String(describing: ApplyPromocodeCell.self))
        tableView.register(PromoCell.self, forCellReuseIdentifier: String(describing: PromoCell.self))
        tableView.register(HidePromoCell.self, forCellReuseIdentifier: String(describing: HidePromoCell.self))
        tableView.register(TotalPriceCell.self, forCellReuseIdentifier: String(describing: TotalPriceCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let order: Order = Order(screenTitle: "Оформление заказа",
                                 promocodes: [.init(title: "VESNAddssdsddssddsdsdssdsd20", percent: 5, endDate: formatter.date(from: "2024/10/08"), info: nil, active: true),
                                              .init(title: "KROweqwCS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "kefteme", active: false),
                                              .init(title: "KROCqweqweS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "dfjakdfjaksfjlskadfj", active: false),
                                              .init(title: "KROCS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "", active: false),
                                              .init(title: "KROCS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "dmf msadkfjnsdkjnvjkdsnjkfdsnfjkasdnf", active: false)],
                                 products: [.init(price: 1200, title: "asa"),
                                            .init(price: 1000, title: "asdasd")],
                                 paymentDiscount: 200,
                                 baseDiscount: 200)
        self.configure()
        showOrder(with: order)
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.viewModel.cellViewModels[indexPath.row]
        
        switch viewModel.type {
        case .applyPromo(let applyPromo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ApplyPromocodeCell.self)) as? ApplyPromocodeCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = applyPromo
            
            return cell
        case .info(let info):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleCell.self)) as? TitleCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = info
            
            return cell
        case .promo(let promo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PromoCell.self)) as? PromoCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = promo
            return cell
        case .hidePromo(let hidePromo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HidePromoCell.self)) as? HidePromoCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = hidePromo
            return cell
        case .totalPrice(let totalPrice):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalPriceCell.self)) as? TotalPriceCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = totalPrice
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("select on = \(indexPath)")
    }
}

private extension ViewController {
    
    func errorAlert(message: String) {
        let alertVC = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
        return
    }
    
    func showOrder(with order: Order) {
        
        do {
            try order.checkOrderData()
        } catch CheckOrderDataErrors.outOfProducts {
            errorAlert(message: "Products are empty")
        } catch CheckOrderDataErrors.priceLessThenZero {
            errorAlert(message: "Price less then zero")
        } catch CheckOrderDataErrors.totalPriceLessThenBaseDiscount {
            errorAlert(message: "Total price less then discount")
        } catch CheckOrderDataErrors.totalPriceLessThenActivePromos {
            errorAlert(message: "Activated promos is more then total price")
        } catch {
            errorAlert(message: "Oooups, something goes wrong...")
        }
        
        self.title = order.screenTitle
        
        viewModel.insertOrder(with: order)
    }
    
    func configure() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        emptyView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        emptyView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: emptyView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }
}

