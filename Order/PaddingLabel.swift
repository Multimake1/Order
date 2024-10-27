//
//  PaddingLabel.swift
//  Order
//
//  Created by Арсений on 27.10.2024.
//

import UIKit

final class PaddingLabel: UILabel {
  private let insets: UIEdgeInsets
  
  init(contentInsets: UIEdgeInsets) {
    self.insets = contentInsets
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: self.insets.top,
                  left: self.insets.left,
                  bottom: self.insets.bottom,
                  right: self.insets.right)
    super.drawText(in: rect.inset(by: insets))
  }

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + self.insets.left + self.insets.right,
            height: size.height + self.insets.top + self.insets.bottom)
  }

  override var bounds: CGRect {
    didSet {
      // ensures this works within stack views if multi-line
      preferredMaxLayoutWidth = self.bounds.width - (self.insets.left + self.insets.right)
    }
  }
}
