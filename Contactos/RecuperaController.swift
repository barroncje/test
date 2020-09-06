//
//  RecuperaController.swift
//  Contactos
//
//  Created by IOS Developer on 05/09/20.
//  Copyright © 2020 JEBC. All rights reserved.
//

import UIKit
import Firebase

class RecuperaController: BaseController {
    // IB Outlets
    @IBOutlet weak var txtCorreo: UITextField!
    
    // IB Actions
    @IBAction func btnRecupera(_ sender: UIButton) {
        let correo = txtCorreo.text
        
        if (correo != "") {
            let correoValido = isValidEmail(testStr: correo!)
            
            if (correoValido) {
                
                Auth.auth().languageCode = "es"
                Auth.auth().sendPasswordReset(withEmail: correo!) { (error) in
                    if (error == nil) {
                        let alertController = UIAlertController(title: "¡Listo!", message: "\nRevisa tu bandeja de entrada y sigue las instrucciones.", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "¡Atención!", message: "\nVerifica que tu correo electrónico sea el correcto.", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                let alertController = UIAlertController(title: "¡Atención!", message: "\nIntroduce un correo electrónico válido.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "¡Atención!", message: "\nIntroduce tu correo electrónico.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Para ocultar el teclado
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.view.addGestureRecognizer(gesture)
        
        txtCorreo.becomeFirstResponder()
    }
    
    // Funciones
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
