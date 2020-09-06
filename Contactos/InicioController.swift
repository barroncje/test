//
//  InicioController.swift
//  Contactos
//
//  Created by IOS Developer on 05/09/20.
//  Copyright © 2020 JEBC. All rights reserved.
//

import UIKit
import Firebase

class InicioController: BaseController {
    // Globales
    var ref: DatabaseReference!
    var arrayKeys: [String] = []
    var arrayNombres: [String] = []
    var arrayApellidos: [String] = []
    var arrayCorreos: [String] = []
    var arrayTelefonos: [String] = []
    
    // IB Outlets
    @IBOutlet weak var viewNuevo: UIView!
    @IBOutlet weak var viewMarcadorNuevo: UIView!
    @IBOutlet weak var viewContactos: UIView!
    @IBOutlet weak var viewMarcadorContactos: UIView!
    @IBOutlet weak var stackViewNuevo: UIStackView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // IB Actions
    @IBAction func btnGuardarContacto(_ sender: UIButton) {
        let nombre = txtNombre.text
        let apellido = txtApellido.text
        let correo = txtCorreo.text
        let telefono = txtTelefono.text
        
        if (nombre != "") && (apellido != "") && (correo != "") && (telefono != "") {
            let correoValido = isValidEmail(testStr: correo!)
            if (correoValido) {
                // Insertando en la base de datos
                let uid = Auth.auth().currentUser?.uid
                ref = Database.database().reference().child("Usuarios").child(uid!).childByAutoId()
                ref.setValue(["nombre":nombre!, "apellido":apellido!, "correo":correo!, "telefono":telefono!], withCompletionBlock: { (error, databaseReference) in
                    
                    let alertController = UIAlertController(title: "¡Listo!", message: "\nContacto guardado exitosamente.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        
                        self.txtNombre.text = ""
                        self.txtApellido.text = ""
                        self.txtCorreo.text = ""
                        self.txtTelefono.text = ""
                        self.txtNombre.becomeFirstResponder()
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Para ocultar el teclado
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.view.addGestureRecognizer(gesture)

        let gesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewNuevoTapped(_:)))
        viewNuevo.addGestureRecognizer(gesture2)
        
        let gesture3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewContactosTapped(_:)))
        viewContactos.addGestureRecognizer(gesture3)
        
        viewMarcadorNuevo.backgroundColor = .darkGray
        
        txtNombre.becomeFirstResponder()
    }

    // Funciones
    @objc func viewNuevoTapped(_ recognizer: UITapGestureRecognizer) {
        
        txtNombre.becomeFirstResponder()
        
        viewMarcadorNuevo.backgroundColor = .darkGray
        viewMarcadorContactos.backgroundColor = .clear
        
        stackViewNuevo.isHidden = false
        tableView.isHidden = true
    }
    
    @objc func viewContactosTapped(_ recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
        viewMarcadorContactos.backgroundColor = .darkGray
        viewMarcadorNuevo.backgroundColor = .clear
        
        tableView.isHidden = false
        stackViewNuevo.isHidden = true
        
        ConsultaContactos()
    }
    
    // Funciones
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func ConsultaContactos() {
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("Usuarios").child(uid!)
        ref.observe(DataEventType .value, with: { (snap) in
            
            self.arrayKeys.removeAll()
            self.arrayNombres.removeAll()
            self.arrayApellidos.removeAll()
            self.arrayCorreos.removeAll()
            self.arrayTelefonos.removeAll()
            
            if (snap.exists()) {
                for rest in snap.children.allObjects as! [DataSnapshot] {
                    let datos = rest.value as? NSDictionary
                    
                    let keyContacto = rest.key
                    let nombre = datos?["nombre"] as? String ?? ""
                    let apellido = datos?["apellido"] as? String ?? ""
                    let correo = datos?["correo"] as? String ?? ""
                    let telefono = datos?["telefono"] as? String ?? ""
                    
                    self.arrayKeys.append(keyContacto)
                    self.arrayNombres.append(nombre)
                    self.arrayApellidos.append(apellido)
                    self.arrayCorreos.append(correo)
                    self.arrayTelefonos.append(telefono)
                    
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.reloadData()
            }
            
        })
    }
}

extension InicioController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayKeys.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaContacto", for: indexPath) as! celdaContacto
        
        celda.lblNombre.text = arrayNombres[indexPath.row]
        celda.lblApellido.text = arrayApellidos[indexPath.row]
        celda.lblCorreo.text = arrayCorreos[indexPath.row]
        celda.lblTelefono.text = arrayTelefonos[indexPath.row]
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let borrar = UITableViewRowAction(style: .destructive, title: "Borrar") { (action, indexPath) in
            
            let key = self.arrayKeys[indexPath.row]
            
            if (key != "") {
                
                let alertController = UIAlertController(title: "¡Atención!", message: "\n¿Deseas eliminar este contacto?", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Sí", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    let keyContacto = self.arrayKeys[indexPath.row]
                    
                    let uid = Auth.auth().currentUser?.uid
                    self.ref = Database.database().reference().child("Usuarios").child(uid!).child(keyContacto)
                    self.ref.removeValue()
                }
                
                let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                }
                
                alertController.addAction(okAction)
                alertController.addAction(noAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            
        }
        
        borrar.backgroundColor = UIColor(red: 0/255, green: 63/255, blue: 97/255, alpha: 1.0)
        
        return [borrar]
    }
}
