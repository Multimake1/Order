//
//  TitleCell.swift
//  Order
//
//  Created by Арсений on 27.10.2024.
//

import UIKit

final class TitleCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.TitleInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
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
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        titleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleView.addSubview(titlePromoLabel)
        titlePromoLabel.translatesAutoresizingMaskIntoConstraints = false
        titlePromoLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        titlePromoLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        titlePromoLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        
        titleView.addSubview(titleInfoLabel)
        titleInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        titleInfoLabel.topAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor, constant: 10).isActive = true
        titleInfoLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        titleInfoLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        titleInfoLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
}
