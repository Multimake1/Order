//
//  HidePromoCell.swift
//  Order
//
//  Created by Арсений on 27.10.2024.
//

import UIKit

final class HidePromoCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.HidePromo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var orangeHexColor = {
        let color = UIColor(hex: "#ff4611ff")
        return color
    }()
    
    private lazy var hidePromoButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.setTitleColor(orangeHexColor, for: .normal)
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
        contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        contentView.addSubview(hidePromoButton)
        hidePromoButton.translatesAutoresizingMaskIntoConstraints = false
        hidePromoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        hidePromoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        hidePromoButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        //hidePromoButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        hidePromoButton.titleLabel?.leftAnchor.constraint(equalTo: hidePromoButton.leftAnchor, constant: 16).isActive = true
       
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
