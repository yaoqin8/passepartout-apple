//
//  PurchaseTableViewCell.swift
//  Passepartout
//
//  Created by Davide De Rosa on 10/30/19.
//  Copyright (c) 2021 Davide De Rosa. All rights reserved.
//
//  https://github.com/passepartoutvpn
//
//  This file is part of Passepartout.
//
//  Passepartout is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Passepartout is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Passepartout.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import StoreKit

class PurchaseTableViewCell: UITableViewCell {
    @IBOutlet private weak var labelTitle: UILabel?

    @IBOutlet private weak var labelPrice: UILabel?

    @IBOutlet private weak var labelDescription: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelTitle?.applyAccent(.current)
        labelPrice?.applyAccent(.current)
        labelDescription?.apply(.current)
        labelDescription?.applySecondarySize(.current)
    }
    
    func fill(product: SKProduct, customDescription: String? = nil) {
        fill(
            title: product.localizedTitle,
            description: customDescription ?? "\(product.localizedDescription)."
        )
        labelPrice?.text = product.localizedPrice
    }

    func fill(title: String, description: String) {
        labelTitle?.text = title
        labelDescription?.text = description
        labelPrice?.text = nil
    }
}
