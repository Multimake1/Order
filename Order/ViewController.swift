//
//  ViewController.swift
//  Order
//
//  Created by Арсений on 16.10.2024.
//

import UIKit

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
        let order: Order = Order(screenTitle: "Оформление экрана",
                                 promocodes: [.init(title: "VESNA20", percent: 5, endDate: formatter.date(from: "2024/10/08"), info: "", active: true),
                                              .init(title: "KROCS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "kefteme", active: false)],
                                 products: [.init(price: 1200, title: "asa"),
                                            .init(price: 1000, title: "asdasd")],
                                 paymentDiscount: 200,
                                 baseDiscount: 1000)
        self.configure()
        showOrder(with: order)
    }


}

final class TotalPriceCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.Products? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var totalView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var countProductLabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var countProductPriceLabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var baseDiscountsLabel = {
        let label = UILabel()
        label.text = "Скидки"
        return label
    }()
    
    private lazy var baseDiscountsPriceLabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    private lazy var promocodesLabel = {
        let label = UILabel()
        label.text = "Промокоды"
        return label
    }()
    
    private lazy var promocodesPriceLabel = {
        let label = UILabel()
        label.textColor = .green
        label.text = String(viewModel?.promocodesDiscountCount() ?? 0) + " ₽"
        return label
    }()
    
    private lazy var paymentDiscountLabel = {
        let label = UILabel()
        label.text = "Способ оплаты"
        return label
    }()
    
    private lazy var paymentDiscountPriceLabel = {
        let label = UILabel()
        label.text = String(viewModel?.paymentMethodDiscount ?? 0) + " ₽"
        return label
    }()
    
    private lazy var totalLabel = {
        let label = UILabel()
        label.text = "Итого"
        return label
    }()
    
    private lazy var totalPriceLabel = {
        let label = UILabel()
        label.text = String(viewModel?.totalPrice() ?? 0) + " ₽"
        return label
    }()
    
    private lazy var placeAnOrderButton = {
        let button = UIButton()
        button.setTitle("Оформить заказ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    private lazy var straightLineView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.frame.size.width = 311
        view.frame.size.height = 5
        return view
    }()
    
    private lazy var conditionsLabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.text = "Нажимая кнопку оформить заказ, " + "(\n)" + " вы соглашаетесь с условиями оферты"
        return label
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        if viewModel.numberOfProducts() == 1 {
            countProductLabel.text = "Цена за " + String(viewModel.numberOfProducts()) + " товар"
        } else if viewModel.numberOfProducts() == 2 || viewModel.numberOfProducts() == 3 || viewModel.numberOfProducts() == 4 {
            countProductLabel.text = "Цена за " + String(viewModel.numberOfProducts()) + " товара"
        } else {
            countProductLabel.text = "Цена за " + String(viewModel.numberOfProducts()) + " товаров"
        }
        countProductPriceLabel.text = String(viewModel.productPrice()) + " ₽"
        baseDiscountsPriceLabel.text = String(viewModel.baseDiscount ?? 0) + " ₽"
        promocodesPriceLabel.text = String(viewModel.promocodesDiscountCount()) + " ₽"
        paymentDiscountPriceLabel.text = String(viewModel.paymentMethodDiscount ?? 0) + " ₽"
        totalPriceLabel.text = String(viewModel.totalPrice()) + " ₽"
    }

    private func setupUI() {
        self.contentView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        self.contentView.addSubview(totalView)
        totalView.translatesAutoresizingMaskIntoConstraints = false
        totalView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        totalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        totalView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        totalView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.totalView.addSubview(countProductLabel)
        countProductLabel.translatesAutoresizingMaskIntoConstraints = false
        countProductLabel.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 20).isActive = true
        countProductLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 40).isActive = true
        
        self.totalView.addSubview(countProductPriceLabel)
        countProductPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        countProductPriceLabel.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 20).isActive = true
        countProductPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -40).isActive = true
        
        self.totalView.addSubview(baseDiscountsLabel)
        baseDiscountsLabel.translatesAutoresizingMaskIntoConstraints = false
        baseDiscountsLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
        baseDiscountsLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 40).isActive = true
        
        self.totalView.addSubview(baseDiscountsPriceLabel)
        baseDiscountsPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        baseDiscountsPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        baseDiscountsPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -40).isActive = true
        
        self.totalView.addSubview(promocodesLabel)
        promocodesLabel.translatesAutoresizingMaskIntoConstraints = false
        promocodesLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
        promocodesLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 40).isActive = true
        
        self.totalView.addSubview(promocodesPriceLabel)
        promocodesPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        promocodesPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
        promocodesPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -40).isActive = true
        
        self.totalView.addSubview(paymentDiscountLabel)
        paymentDiscountLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentDiscountLabel.topAnchor.constraint(equalTo: promocodesLabel.bottomAnchor, constant: 10).isActive = true
        paymentDiscountLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 40).isActive = true
        
        self.totalView.addSubview(paymentDiscountPriceLabel)
        paymentDiscountPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentDiscountPriceLabel.topAnchor.constraint(equalTo: promocodesPriceLabel.bottomAnchor, constant: 10).isActive = true
        paymentDiscountPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -40).isActive = true
        
        /*self.totalView.addSubview(straightLineView)
        straightLineView.translatesAutoresizingMaskIntoConstraints = false
        straightLineView.topAnchor.constraint(equalTo: paymentDiscountLabel.bottomAnchor, constant: 10).isActive = true
        straightLineView.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 40).isActive = true*/
        
        self.totalView.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.topAnchor.constraint(equalTo: paymentDiscountLabel.bottomAnchor, constant: 30).isActive = true
        totalLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 40).isActive = true
        
        self.totalView.addSubview(totalPriceLabel)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.topAnchor.constraint(equalTo: paymentDiscountLabel.bottomAnchor, constant: 30).isActive = true
        totalPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -40).isActive = true
        
        self.totalView.addSubview(placeAnOrderButton)
        placeAnOrderButton.translatesAutoresizingMaskIntoConstraints = false
        placeAnOrderButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 15).isActive = true
        placeAnOrderButton.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 40).isActive = true
        placeAnOrderButton.bottomAnchor.constraint(equalTo: totalView.bottomAnchor, constant: -100).isActive = true
        placeAnOrderButton.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -40).isActive = true
        
        self.totalView.addSubview(conditionsLabel)
        conditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionsLabel.topAnchor.constraint(equalTo: placeAnOrderButton.bottomAnchor, constant: 15).isActive = true
        conditionsLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @objc func tap() {
        print("Оформить заказ")
    }
}

final class HidePromoCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.HidePromo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var hidePromoButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        hidePromoButton.setTitle(viewModel.titleHide, for: .normal)
    }

    private func setupUI() {
        contentView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        contentView.addSubview(hidePromoButton)
        hidePromoButton.translatesAutoresizingMaskIntoConstraints = false
        hidePromoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        hidePromoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        hidePromoButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        hidePromoButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        hidePromoButton.titleLabel?.leftAnchor.constraint(equalTo: hidePromoButton.leftAnchor, constant: 10).isActive = true
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @objc func tap() {
        print("Скрыть промокоды")
    }
}

final class ApplyPromocodeCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.ApplyPromocode? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var applyPromocodeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .red.withAlphaComponent(0.10)
        button.setTitleColor(.red, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyPromocodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "percent")
        imageView.tintColor = .red
        return imageView
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        applyPromocodeButton.setTitle(viewModel.titleApply, for: .normal)
    }

    private func setupUI() {
        contentView.heightAnchor.constraint(equalToConstant: 74).isActive = true
        contentView.addSubview(applyPromocodeButton)
        applyPromocodeButton.translatesAutoresizingMaskIntoConstraints = false
        applyPromocodeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        applyPromocodeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        applyPromocodeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        applyPromocodeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        applyPromocodeButton.addSubview(applyPromocodeImage)
        applyPromocodeImage.translatesAutoresizingMaskIntoConstraints = false
        applyPromocodeImage.centerYAnchor.constraint(equalTo: applyPromocodeButton.centerYAnchor).isActive = true
        applyPromocodeImage.rightAnchor.constraint(equalTo: applyPromocodeButton.titleLabel?.leftAnchor ?? applyPromocodeButton.centerXAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @objc func tap() {
        print("тап")
    }
}

final class TitleCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.TitleInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var titlePromoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(24)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var titleInfoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        titlePromoLabel.text = viewModel.title
        titleInfoLabel.text = viewModel.info
    }

    private func setupUI() {
        contentView.addSubview(titlePromoLabel)
        titlePromoLabel.translatesAutoresizingMaskIntoConstraints = false
        titlePromoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        titlePromoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        titlePromoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        contentView.addSubview(titleInfoLabel)
        titleInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        titleInfoLabel.topAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor, constant: 10).isActive = true
        titleInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        titleInfoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        titleInfoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
}

final class PromoCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.Promo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var promoView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var subPromoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.frame.size.width = 16
        view.frame.size.height = 16
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.width / 2
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var titlePromoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var datePromoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        //label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .green
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = .red
        button.isOn = false
        button.addTarget(self, action: #selector(toggle), for: .valueChanged)
        return button
    }()
    
    @objc func toggle() {
        guard let viewModel else { return }
        viewModel.toggle?(switchButton.isOn, viewModel.id)
    }
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        switchButton.setOn(viewModel.isActive, animated: true)
        titlePromoLabel.text = viewModel.title
        datePromoLabel.text = "По " + (viewModel.endDate?.formatted() ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(promoView)
        promoView.translatesAutoresizingMaskIntoConstraints = false
        promoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        promoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        promoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        promoView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        promoView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        if (viewModel?.info == "") {
            promoView.addSubview(titlePromoLabel)
            titlePromoLabel.translatesAutoresizingMaskIntoConstraints = false
            titlePromoLabel.topAnchor.constraint(equalTo: promoView.topAnchor, constant: 5).isActive = true
            titlePromoLabel.bottomAnchor.constraint(equalTo: promoView.bottomAnchor, constant: -5).isActive = true
            titlePromoLabel.leftAnchor.constraint(equalTo: promoView.leftAnchor, constant: 30).isActive = true
            titlePromoLabel.rightAnchor.constraint(equalTo: promoView.rightAnchor, constant: -30).isActive = true
            
            promoView.addSubview(datePromoLabel)
            datePromoLabel.translatesAutoresizingMaskIntoConstraints = false
            datePromoLabel.topAnchor.constraint(equalTo: promoView.topAnchor, constant: 5).isActive = true
            datePromoLabel.bottomAnchor.constraint(equalTo: promoView.bottomAnchor, constant: -5).isActive = true
            datePromoLabel.leftAnchor.constraint(equalTo: promoView.leftAnchor, constant: 30).isActive = true
            datePromoLabel.rightAnchor.constraint(equalTo: promoView.rightAnchor, constant: -30).isActive = true
            
            promoView.addSubview(switchButton)
            switchButton.translatesAutoresizingMaskIntoConstraints = false
            switchButton.topAnchor.constraint(equalTo: promoView.topAnchor, constant: 10).isActive = true
            switchButton.leftAnchor.constraint(equalTo: titlePromoLabel.rightAnchor, constant: 10).isActive = true
            
            promoView.addSubview(circleView)
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.centerXAnchor.constraint(equalTo: promoView.rightAnchor).isActive = true
            circleView.centerYAnchor.constraint(equalTo: promoView.centerYAnchor).isActive = true
        } else {
            promoView.addSubview(subPromoView)
            subPromoView.translatesAutoresizingMaskIntoConstraints = false
            subPromoView.centerYAnchor.constraint(equalTo: promoView.centerYAnchor).isActive = true
            subPromoView.leftAnchor.constraint(equalTo: promoView.leftAnchor, constant: 20).isActive = true
            subPromoView.widthAnchor.constraint(equalToConstant: 240).isActive = true
            
            
            subPromoView.addSubview(titlePromoLabel)
            titlePromoLabel.translatesAutoresizingMaskIntoConstraints = false
            titlePromoLabel.bottomAnchor.constraint(equalTo: subPromoView.centerYAnchor, constant: -5).isActive = true
            titlePromoLabel.leftAnchor.constraint(equalTo: subPromoView.leftAnchor).isActive = true
            
            subPromoView.addSubview(datePromoLabel)
            datePromoLabel.translatesAutoresizingMaskIntoConstraints = false
            datePromoLabel.topAnchor.constraint(equalTo: subPromoView.centerYAnchor, constant: 5).isActive = true
            datePromoLabel.leftAnchor.constraint(equalTo: subPromoView.leftAnchor).isActive = true
            
            promoView.addSubview(switchButton)
            switchButton.translatesAutoresizingMaskIntoConstraints = false
            switchButton.centerYAnchor.constraint(equalTo: subPromoView.centerYAnchor).isActive = true
            switchButton.leftAnchor.constraint(equalTo: subPromoView.rightAnchor, constant: 10).isActive = true
            
            promoView.addSubview(circleView)
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.centerYAnchor.constraint(equalTo: promoView.centerYAnchor).isActive = true
            circleView.centerXAnchor.constraint(equalTo: promoView.centerXAnchor).isActive = true
            
            promoView.addSubview(circleView)
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.topAnchor.constraint(equalTo: promoView.centerYAnchor, constant: 5).isActive = true
            circleView.leftAnchor.constraint(equalTo: promoView.leftAnchor, constant: 5).isActive = true
            
        }
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
    
    func showOrder(with order: Order) {
        
        do {
            try order.checkOrderData()
        } catch CheckOrderDataErrors.outOfProducts {
            let alertVC = UIAlertController(
                title: "Error",
                message: "Products are empty",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
            return
        } catch CheckOrderDataErrors.priceLessThenZero {
            print("alert")
            let alertVC = UIAlertController(
                title: "Error",
                message: "Price less then zero",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
            return
        } catch CheckOrderDataErrors.totalPriceLessThenBaseDiscount {
            let alertVC = UIAlertController(
                title: "Error",
                message: "Total price less then discount",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
            return
        } catch CheckOrderDataErrors.totalPriceLessThenActivePromos {
            let alertVC = UIAlertController(
                title: "Error",
                message: "Activated promos is more then total price",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
            return
        } catch {
            let alertVC = UIAlertController(
                title: "Error",
                message: "Oooups, something goes wrong...",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
            return
        }
        self.title = order.screenTitle
        
        self.viewModel.cellViewModels.append(.init(type: .info(.init(title: "Промокоды", info: "На один товар можно применить только один промокод"))))
        self.viewModel.cellViewModels.append(.init(type: .applyPromo(.init(titleApply: "Применить промокод"))))
        let promocodes = order.promocodes.map {
            TableViewModel.ViewModelType.Promo(title: $0.title,
                                               percent: $0.percent,
                                               endDate: $0.endDate,
                                               info: $0.info ?? "",
                                               isActive: $0.active,
            toggle: { [weak self] value, id in
                self?.viewModel.togglePromo(value: value, id: id)
            })
        }
        promocodes.forEach { element in
            self.viewModel.cellViewModels.append(.init(type: .promo(element)))
        }
        self.viewModel.cellViewModels.append(.init(type: .hidePromo(.init(titleHide: "Скрыть промокоды"))))
        let products = order.products.map {
            TableViewModel.ViewModelType.Products.Product(price: $0.price,
                                                          title: $0.title)
        }
        self.viewModel.cellViewModels.append(.init(type: .totalPrice(.init(promocodes: promocodes, products: products, baseDiscount: order.baseDiscount, paymentMethodDiscount: order.paymentDiscount))))
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

