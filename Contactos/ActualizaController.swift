//
//  ActualizaController.swift
//  Contactos
//
//  Created by IOS Developer on 06/09/20.
//  Copyright © 2020 JEBC. All rights reserved.
//

import UIKit
import Firebase

class ActualizaController: BaseController {
    // Globales
    var ref: DatabaseReference!
    var keyContacto = ""
    
    // IB Outlets
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    
    // IB Actions
    @IBAction func btnActualizar(_ sender: UIButton) {
        let nombre = txtNombre.text
        let apellido = txtApellido.text
        let correo = txtCorreo.text
        let telefono = txtTelefono.text
        
        if (nombre != "") && (apellido != "") && (correo != "") && (telefono != "") {
            let correoValido = isValidEmail(testStr: correo!)
            if (correoValido) {
                // Insertando en la base de datos
                let uid = Auth.auth().currentUser?.uid
                ref = Database.database().reference().child("Contactos").child(uid!).child(keyContacto)
                ref.updateChildValues(["nombre":nombre!, "apellido":apellido!, "correo":correo!, "telefono":telefono!], withCompletionBlock: { (error, databaseReference) in
                    
                    let alertController = UIAlertController(title: "¡Listo!", message: "\nContacto actualizado correctamente.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                })
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
        
        txtNombre.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("Contactos").child(uid!).child(keyContacto)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let datos = snapshot.value as? NSDictionary
            
            let nombre = datos?["nombre"] as? String ?? ""
            let apellido = datos?["apellido"] as? String ?? ""
            let correo = datos?["correo"] as? String ?? ""
            let telefono = datos?["telefono"] as? String ?? ""
            
            self.txtNombre.text = nombre
            self.txtApellido.text = apellido
            self.txtCorreo.text = correo
            self.txtTelefono.text = telefono
            
        })
    }
    
    // Funciones
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
