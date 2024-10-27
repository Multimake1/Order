//
//  PromoCell.swift
//  Order
//
//  Created by Арсений on 27.10.2024.
//

import UIKit

final class PromoCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.Promo? {
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
    
    private lazy var promoView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = lightGrayHexColor
        return view
    }()
    
    private lazy var subPromoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var circleLeftView: UIView = {
        let view = UIView()
        //view.frame.size.width = 20
        //view.frame.size.height = 20
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var circleRightView: UIView = {
        let view = UIView()
        //view.frame.size.width = 20
        //view.frame.size.height = 20
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titlePromoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
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
        label.textColor = grayHexColor
        return label
    }()
    
    private lazy var percentLabel: PaddingLabel = {
        let label = PaddingLabel(contentInsets: .init(top: 2, left: 6, bottom: 2, right: 6))
        label.font = label.font.withSize(12)
        label.textColor = .white
        label.numberOfLines = 1
        label.backgroundColor = greenHexColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = label.font.withSize(12)
        label.textColor = grayHexColor
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = orangeHexColor
        button.tintColor = grayHexColor
        button.isOn = false
        button.addTarget(self, action: #selector(toggle), for: .valueChanged)
        return button
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
    
    @objc func toggle() {
        guard let viewModel else { return }
        viewModel.toggle?(switchButton.isOn, viewModel.id)
    }
    
    @objc func getInfoAction() {
        guard let viewModel else { return }
        print("getInfoAction")
    }
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        
        
        switchButton.setOn(viewModel.isActive, animated: true)
        titlePromoLabel.text = viewModel.title
        datePromoLabel.text = "По " + viewModel.getDate(endDate: viewModel.endDate ?? Date.now)
        datePromoLabel.topAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor).isActive = true
        if viewModel.info != "" {
            promoView.addSubview(infoLabel)
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            infoLabel.topAnchor.constraint(equalTo: subPromoView.bottomAnchor, constant: 8).isActive = true
            infoLabel.leadingAnchor.constraint(equalTo: promoView.leadingAnchor, constant: 20).isActive = true
            infoLabel.bottomAnchor.constraint(equalTo: promoView.bottomAnchor, constant: -12).isActive = true
            infoLabel.trailingAnchor.constraint(equalTo: promoView.trailingAnchor, constant: -12).isActive = true
            infoLabel.text = viewModel.info
        }
        percentLabel.text = "-" + String(viewModel.percent) + "%"
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
        promoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        promoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        promoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        promoView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        promoView.addSubview(subPromoView)
        subPromoView.translatesAutoresizingMaskIntoConstraints = false
        subPromoView.topAnchor.constraint(equalTo: promoView.topAnchor, constant: 18).isActive = true
        subPromoView.leftAnchor.constraint(equalTo: promoView.leftAnchor, constant: 20).isActive = true
        subPromoView.rightAnchor.constraint(equalTo: promoView.rightAnchor, constant: -20).isActive = true
        
        subPromoView.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    switchButton.trailingAnchor.constraint(equalTo: promoView.trailingAnchor, constant: -20),
                    switchButton.centerYAnchor.constraint(equalTo: subPromoView.centerYAnchor)
                ])
        
        
        subPromoView.addSubview(titlePromoLabel)
        contentView.addSubview(percentLabel)
        titlePromoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titlePromoLabel.leadingAnchor.constraint(equalTo: subPromoView.leadingAnchor),
            titlePromoLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8),
            titlePromoLabel.topAnchor.constraint(equalTo: subPromoView.topAnchor)
        ])
        
        subPromoView.addSubview(datePromoLabel)
        datePromoLabel.translatesAutoresizingMaskIntoConstraints = false
        datePromoLabel.topAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor).isActive = true
        datePromoLabel.leftAnchor.constraint(equalTo: subPromoView.leftAnchor).isActive = true
        //datePromoLabel.rightAnchor.constraint(equalTo: subPromoView.rightAnchor, constant: -54).isActive = true
        datePromoLabel.bottomAnchor.constraint(equalTo: subPromoView.bottomAnchor).isActive = true
        
        
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            percentLabel.leadingAnchor.constraint(equalTo: titlePromoLabel.trailingAnchor, constant: 8),
            percentLabel.centerYAnchor.constraint(equalTo: titlePromoLabel.centerYAnchor),
        ])
        
        contentView.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoButton.centerYAnchor.constraint(equalTo: percentLabel.centerYAnchor),
            infoButton.leadingAnchor.constraint(equalTo: percentLabel.trailingAnchor, constant: 8),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: switchButton.leadingAnchor, constant: -8)
        ])
        
        promoView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.topAnchor.constraint(equalTo: subPromoView.bottomAnchor, constant: 8).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: promoView.leadingAnchor, constant: 20).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: promoView.bottomAnchor, constant: -12).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: promoView.trailingAnchor, constant: -12).isActive = true
        
        promoView.addSubview(circleLeftView)
        circleLeftView.translatesAutoresizingMaskIntoConstraints = false
        circleLeftView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        circleLeftView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        circleLeftView.centerYAnchor.constraint(equalTo: promoView.centerYAnchor).isActive = true
        circleLeftView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        
        promoView.addSubview(circleRightView)
        circleRightView.translatesAutoresizingMaskIntoConstraints = false
        circleRightView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        circleRightView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        circleRightView.centerYAnchor.constraint(equalTo: promoView.centerYAnchor).isActive = true
        circleRightView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        
        titlePromoLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titlePromoLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        percentLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        infoButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        switchButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        
            
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titlePromoLabel.text = nil
        datePromoLabel.text = nil
        infoLabel.text = nil
        percentLabel.text = nil
    }
    
}

