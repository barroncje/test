//
//  ViewController.swift
//  Contactos
//
//  Created by IOS Developer on 05/09/20.
//  Copyright © 2020 JEBC. All rights reserved.
//

import UIKit
import Firebase

class ViewController: BaseController {
    // IB Outlets
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtContrasenia: UITextField!
    @IBOutlet weak var lblRecuperarContrasenia: UILabel!
    
    // IB Actions
    @IBAction func btnIniciarSesion(_ sender: UIButton) {
        let correo = txtCorreo.text
        let password = txtContrasenia.text
        
        if(correo != "") && (password != ""){
            Auth.auth().signIn(withEmail: correo!, password: password!) { (result, error) in
                if(error == nil){
                    //Verificando que el email con el que se está iniciando la sesión ya haya sido confirmado
                    if(result?.user.isEmailVerified)!{
                        // Redirigiendo al controller principal
                        let displayVC : InicioController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InicioController") as! InicioController
                        displayVC.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        self.present(displayVC, animated: true, completion: nil)
                    }else{
                        // Enviando nuevamente el email de verificación
                        result?.user.sendEmailVerification(completion: { (error) in
                            
                        })
                        
                        // Cerrando la sesión en Firebase
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            print("Sesión cerrada porque la cuenta no ha sido verificada.")
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                        
                        let alertController = UIAlertController(title: "¡Atención!", message: "\nPor favor revise su bandeja de entrada y valide su correo electrónico.", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    let alertController = UIAlertController(title: "¡Atención!", message: "\nPor favor verifique que su correo y contraseña sean los correctos.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }else{
            let alertController = UIAlertController(title: "¡Atención!", message: "\nIntroduce tu correo electrónico y contraseña.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnRegistro(_ sender: UIButton) {
        let displayVC : RegistroController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistroController") as! RegistroController
        self.present(displayVC, animated: true, completion: nil)
    }
    
    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapRecuperarContrasenia))
        lblRecuperarContrasenia.isUserInteractionEnabled = true
        lblRecuperarContrasenia.addGestureRecognizer(tapLabel)
        
        // Para ocultar el teclado
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.view.addGestureRecognizer(gesture)
        
        txtCorreo.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Comprobando si hay un usuario logueado
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            print("Hay un usuario logueado: \(uid!)")
            
            // Redirigiendo al controller principal
            DispatchQueue.main.async {
                let display : InicioController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InicioController") as! InicioController
                display.modalPresentationStyle = UIModalPresentationStyle.currentContext
                self.present(display, animated: true, completion: nil)
            }
            return
            
        }
    }

    // Funciones
    @objc func tapRecuperarContrasenia(sender:UITapGestureRecognizer) {
        let displayVC : RecuperaController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecuperaController") as! RecuperaController
        self.present(displayVC, animated: true, completion: nil)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}

