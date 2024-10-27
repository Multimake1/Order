//
//  TotalPriceCell.swift
//  Order
//
//  Created by Арсений on 25.10.2024.
//

import Foundation

class TotalPriceCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.Products? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var orangeHexColor = {
        let color = UIColor(hex: "#ff4611ff")
        return color
    }()
    
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
        button.backgroundColor = orangeHexColor
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
        label.text = "Нажимая кнопку оформить заказ, Вы соглашаетесь с условиями оферты"
        return label
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        countProductLabel.text = viewModel.priceOfProductsString()
        countProductPriceLabel.text = viewModel.productPriceString()
        baseDiscountsPriceLabel.text = viewModel.baseDiscountString()
        promocodesPriceLabel.text = viewModel.promocodesDiscountString()
        paymentDiscountPriceLabel.text = viewModel.paymentDiscountString()
        totalPriceLabel.text = viewModel.totalPriceString()
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
