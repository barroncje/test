//
//  RegistroController.swift
//  Contactos
//
//  Created by IOS Developer on 05/09/20.
//  Copyright © 2020 JEBC. All rights reserved.
//

import UIKit
import Firebase

class RegistroController: BaseController {
    // Globales
    var ref: DatabaseReference!
    
    // IB Outlets
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtContrasenia: UITextField!
    @IBOutlet weak var txtConfirmaContrasenia: UITextField!
    
    // IB Actions
    @IBAction func btnRegistro(_ sender: UIButton) {
        let correo = txtCorreo.text
        let contrasenia = txtContrasenia.text
        let confirmacion = txtConfirmaContrasenia.text
        
        if (correo != "") && (contrasenia != "") && (confirmacion != "") {
            let correoValido = isValidEmail(testStr: correo!)
            if (correoValido) {
                if (contrasenia == confirmacion) {
                    if (contrasenia!.count >= 6) {
                        Auth.auth().createUser(withEmail: correo!, password: contrasenia!) { (user, error) in
                            if(error == nil){
                                let uid = user?.user.uid
                                //Enviando el email de verificación
                                Auth.auth().currentUser?.sendEmailVerification { (error) in
                                    if(error == nil){
                                        let alertController = UIAlertController(title: "¡Listo!", message: "\nRevisa tu bandeja de entrada, se ha enviado un mail de verificación.", preferredStyle: .alert)
                                        
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                            UIAlertAction in
                                            
                                            // Cerrando la sesión en Firebase
                                            let firebaseAuth = Auth.auth()
                                            do {
                                                try firebaseAuth.signOut()
                                                
                                                self.dismiss(animated: true, completion: nil)
                                                
                                            } catch let signOutError as NSError {
                                                print ("Error signing out: %@", signOutError)
                                            }
                                            
                                        }
                                        
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion: nil)
                                        
                                    }else{
                                        print("Error al enviar el email de verificación.")
                                    }
                                }
                            }else{
                                if(error?.localizedDescription == "The email address is already in use by another account."){
                                    
                                    let alertController = UIAlertController(title: "¡Atención!", message: "\nEl correo electrónico ya está registrado. Intenta con otro diferente.", preferredStyle: .alert)
                                    
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        
                                    }
                                    
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                    } else {
                        let alertController = UIAlertController(title: "¡Atención!", message: "\nLa contraseña debe contener al menos 6 caracteres.", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    let alertController = UIAlertController(title: "¡Atención!", message: "\nLa contraseña no coincide.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
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
            let alertController = UIAlertController(title: "¡Atención!", message: "\nTodos los campos son obligatorios.", preferredStyle: .alert)
            
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
