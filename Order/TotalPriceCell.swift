//
//  TotalPriceCell.swift
//  Order
//
//  Created by Арсений on 27.10.2024.
//

import UIKit

final class TotalPriceCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.Products? {
        didSet {
            
            updateUI()
        }
    }
    
    private lazy var grayHexColor = {
        let color = UIColor(hex: "#7A7A7Aff")
        return color
    }()
    
    private lazy var lightGrayHexColor = {
        let color = UIColor(hex: "#F6F6F6ff")
        return color
    }()
    
    private lazy var greenHexColor = {
        let color = UIColor(hex: "#00B775ff")
        return color
    }()
    
    private lazy var orangeHexColor = {
        let color = UIColor(hex: "#ff4611ff")
        return color
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        let image = UIImage(named: "infoImage")
        button.titleLabel?.numberOfLines = 0
        button.setImage(image, for: .normal)
        button.tintColor = grayHexColor
        button.addTarget(self, action: #selector(getInfoAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var totalView = {
        let view = UIView()
        view.backgroundColor = lightGrayHexColor
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
        label.textColor = orangeHexColor
        return label
    }()
    
    private lazy var promocodesLabel = {
        let label = UILabel()
        label.text = "Промокоды"
        return label
    }()
    
    private lazy var promocodesPriceLabel = {
        let label = UILabel()
        label.textColor = greenHexColor
        return label
    }()
    
    private lazy var paymentDiscountLabel = {
        let label = UILabel()
        label.text = "Способ оплаты"
        return label
    }()
    
    private lazy var paymentDiscountPriceLabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var totalLabel = {
        let label = UILabel()
        label.text = "Итого"
        return label
    }()
    
    private lazy var totalPriceLabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var placeAnOrderButton = {
        let button = UIButton()
        button.setTitle("Оформить заказ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(16)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = orangeHexColor
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    @objc func tap() {
        print("Оформить заказ")
    }
    
    private lazy var straightLineView = {
        let view = UIView()
        view.backgroundColor = grayHexColor
        return view
    }()
    
    private lazy var conditionsLabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.numberOfLines = 0
        label.textColor = grayHexColor
        label.textAlignment = .center
        label.text = "Нажимая кнопку оформить заказ, Вы соглашаетесь с Условиями оферты"
        return label
    }()
    
    @objc func getInfoAction() {
        print("getInfoAction")
    }
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        //placeAnOrderButton.bottomAnchor.constraint(equalTo: conditionsLabel.topAnchor, constant: -16).isActive = true
        countProductLabel.text = viewModel.priceOfProductsString()
        countProductPriceLabel.text = viewModel.productPriceString()
        
        if viewModel.baseDiscount != 0 {
            baseDiscountsPriceLabel.text = viewModel.baseDiscountString()
        } else {
            baseDiscountsLabel.removeFromSuperview()
            baseDiscountsPriceLabel.removeFromSuperview()
            promocodesLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
            promocodesPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        }
        
        if viewModel.promocodesDiscountCount() != 0 {
            //promocodesLabel.removeFromSuperview()
            //promocodesPriceLabel.removeFromSuperview()
            //infoButton.removeFromSuperview()
            totalView.addSubview(promocodesLabel)
            totalView.addSubview(promocodesPriceLabel)
            totalView.addSubview(infoButton)
            if viewModel.baseDiscount != 0 {
                promocodesLabel.translatesAutoresizingMaskIntoConstraints = false
                promocodesLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
                promocodesLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
                
                promocodesPriceLabel.translatesAutoresizingMaskIntoConstraints = false
                promocodesPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
                promocodesPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
            } else {
                promocodesLabel.translatesAutoresizingMaskIntoConstraints = false
                promocodesLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
                promocodesLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
                
                promocodesPriceLabel.translatesAutoresizingMaskIntoConstraints = false
                promocodesPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
                promocodesPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
            }
            
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                infoButton.centerYAnchor.constraint(equalTo: promocodesLabel.centerYAnchor),
                infoButton.leadingAnchor.constraint(equalTo: promocodesLabel.trailingAnchor, constant: 4),
                infoButton.trailingAnchor.constraint(lessThanOrEqualTo: promocodesPriceLabel.leadingAnchor, constant: -8)
            ])
            
            promocodesPriceLabel.text = viewModel.promocodesDiscountString()
        } else if viewModel.baseDiscount != 0 {
            promocodesLabel.removeFromSuperview()
            promocodesPriceLabel.removeFromSuperview()
            infoButton.removeFromSuperview()
            paymentDiscountLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
            paymentDiscountPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
        } else {
            promocodesLabel.removeFromSuperview()
            promocodesPriceLabel.removeFromSuperview()
            infoButton.removeFromSuperview()
            paymentDiscountLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
            paymentDiscountPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        }
        
        if viewModel.paymentMethodDiscount != 0 {
            paymentDiscountPriceLabel.text = viewModel.paymentDiscountString()
        } else if viewModel.promocodesDiscountCount() != 0 {
            paymentDiscountLabel.removeFromSuperview()
            paymentDiscountPriceLabel.removeFromSuperview()
            totalLabel.topAnchor.constraint(equalTo: promocodesLabel.bottomAnchor, constant: 10).isActive = true
            totalPriceLabel.topAnchor.constraint(equalTo: promocodesPriceLabel.bottomAnchor, constant: 10).isActive = true
        } else if viewModel.baseDiscount != 0 {
            paymentDiscountLabel.removeFromSuperview()
            paymentDiscountPriceLabel.removeFromSuperview()
            totalLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
            totalPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
        } else {
            paymentDiscountLabel.removeFromSuperview()
            paymentDiscountPriceLabel.removeFromSuperview()
            totalLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
            totalPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        }
        
        totalPriceLabel.text = viewModel.totalPriceString()
    }

    private func setupUI() {
        self.contentView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        self.contentView.addSubview(totalView)
        totalView.translatesAutoresizingMaskIntoConstraints = false
        totalView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        totalView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        totalView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        totalView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.totalView.addSubview(countProductLabel)
        countProductLabel.translatesAutoresizingMaskIntoConstraints = false
        countProductLabel.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 24).isActive = true
        countProductLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(countProductPriceLabel)
        countProductPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        countProductPriceLabel.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 24).isActive = true
        countProductPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(baseDiscountsLabel)
        baseDiscountsLabel.translatesAutoresizingMaskIntoConstraints = false
        baseDiscountsLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
        baseDiscountsLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(baseDiscountsPriceLabel)
        baseDiscountsPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        baseDiscountsPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        baseDiscountsPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(promocodesLabel)
        promocodesLabel.translatesAutoresizingMaskIntoConstraints = false
        promocodesLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
        promocodesLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(promocodesPriceLabel)
        promocodesPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        promocodesPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
        promocodesPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(paymentDiscountLabel)
        paymentDiscountLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentDiscountLabel.topAnchor.constraint(equalTo: promocodesLabel.bottomAnchor, constant: 10).isActive = true
        paymentDiscountLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(paymentDiscountPriceLabel)
        paymentDiscountPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentDiscountPriceLabel.topAnchor.constraint(equalTo: promocodesPriceLabel.bottomAnchor, constant: 10).isActive = true
        paymentDiscountPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(straightLineView)
        straightLineView.translatesAutoresizingMaskIntoConstraints = false
        //straightLineView.frame.size.width = 311
        straightLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        straightLineView.topAnchor.constraint(equalTo: paymentDiscountLabel.bottomAnchor, constant: 16).isActive = true
        straightLineView.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        straightLineView.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.topAnchor.constraint(equalTo: straightLineView.bottomAnchor, constant: 16).isActive = true
        totalLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(totalPriceLabel)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.topAnchor.constraint(equalTo: straightLineView.bottomAnchor, constant: 16).isActive = true
        totalPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(placeAnOrderButton)
        self.totalView.addSubview(conditionsLabel)
        placeAnOrderButton.translatesAutoresizingMaskIntoConstraints = false
        placeAnOrderButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        placeAnOrderButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 16).isActive = true
        placeAnOrderButton.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        placeAnOrderButton.bottomAnchor.constraint(equalTo: conditionsLabel.topAnchor, constant: -16).isActive = true
        placeAnOrderButton.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        
        conditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        //conditionsLabel.topAnchor.constraint(equalTo: placeAnOrderButton.bottomAnchor).isActive = true
        conditionsLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        conditionsLabel.trailingAnchor.constraint(equalTo: totalView.trailingAnchor, constant: -32).isActive = true
        conditionsLabel.bottomAnchor.constraint(equalTo: totalView.bottomAnchor, constant: -40).isActive = true
        contentView.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoButton.centerYAnchor.constraint(equalTo: promocodesLabel.centerYAnchor),
            infoButton.leadingAnchor.constraint(equalTo: promocodesLabel.trailingAnchor, constant: 4),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: promocodesPriceLabel.leadingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
}
