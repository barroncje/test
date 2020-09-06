//
//  ChatController.swift
//  Contactos
//
//  Created by IOS Developer on 06/09/20.
//  Copyright © 2020 JEBC. All rights reserved.
//

import UIKit

class ChatController: BaseController {
    // Globales
    var correoDestino = ""

    // IB Outlets
    @IBOutlet weak var txtViewHistorial: UITextView!
    @IBOutlet weak var txtMensaje: UITextField!
    
    // IB Actions
    @IBAction func btnEnviarMensaje(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        txtMensaje.becomeFirstResponder()
    }

}
