//
//  celdaContacto.swift
//  Contactos
//
//  Created by IOS Developer on 05/09/20.
//  Copyright © 2020 JEBC. All rights reserved.
//

import UIKit

class celdaContacto: UITableViewCell {
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblApellido: UILabel!
    @IBOutlet weak var lblCorreo: UILabel!
    @IBOutlet weak var lblTelefono: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            contentView.backgroundColor = UIColor.lightGray
        } else {
            contentView.backgroundColor = UIColor.lightGray
        }
    }

}
