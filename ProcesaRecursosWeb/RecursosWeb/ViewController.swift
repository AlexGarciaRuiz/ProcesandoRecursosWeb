//
//  ViewController.swift
//  RecursosWeb
//
//  Created by AlexGarcia on 7/20/16.
//  Copyright © 2016 AlexGarcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var isbn: UITextField!
    
    @IBOutlet weak var resultado: UITextView!
    
    @IBOutlet weak var tituloLbl: UILabel!
    
    @IBOutlet weak var autoresLbl: UITextView!
    
    @IBOutlet weak var portdaImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbn.delegate = self
        isbn.clearButtonMode = UITextFieldViewMode.Always
        resultado.text = ""
    }
    
    @IBAction func limpiarBtn(sender: AnyObject) {
        isbn.text = ""
    }
    
    @IBAction func textFieldDidEndEditing(sender: UITextField) {
        sender.resignFirstResponder()
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn.text!
        //978-84-376-0494-7
        let url = NSURL(string: urls)
        if url != nil {
            let datos : NSData? = NSData(contentsOfURL: url!)
            if datos != nil && datos!.length > 2{
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                self.resultado.text = texto! as String
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dico1 = json as! NSDictionary
                    
                    let dico2 = dico1["ISBN:" + isbn.text!] as! NSDictionary
                    
                    tituloLbl.text = dico2["title"] as? String
                    
                    let autoresArray = dico2["authors"] as! NSArray
                    print("cant: \(autoresArray.count)")
                    var s = ""
                    for a in autoresArray {
                        let autor = a["name"] as! String
                        s = s + "\n" + autor
                        print("autor:" + autor)
                    }
                    autoresLbl.text = s
                    
                    let dico3 = dico2["cover"] as? NSDictionary
                    
                    print("dico3: \(dico3)")
                    
                    if dico3 != nil {
                        
                        var c1 = ""
                        
                        if dico3!["large"] != nil {
                            c1 = dico3!["large"] as! String
                            print("large: " + c1)
                        }
                        else if dico3!["medium"] != nil {
                            c1 = dico3!["medium"] as! String
                            print("medium: " + c1)
                        }
                        else if dico3!["small"] != nil {
                            c1 = dico3!["small"] as! String
                            print("small: " + c1)
                        }
                        
                        let urlCover = NSURL(string: c1)
                        if urlCover != nil {
                            let dataCover : NSData? = NSData(contentsOfURL: urlCover!)
                            portdaImg.hidden = false
                            portdaImg.image = UIImage(data: dataCover!)
                        }
                        else {
                            portdaImg.hidden = true
                        }
                    }
                    else {
                        portdaImg.hidden = true
                    }
                    print("Titulo: \(tituloLbl.text!)")
                    print("Titulo: \(autoresLbl.text!)")
                    
                    
                    }
                catch _ {
                    
                }

            }
            else {
                if datos!.length == 2 {
                    resultado.text = "No se localizó el ISBN: " + isbn.text!
                    let alertEmpty = UIAlertController(title: "Mensaje",
                                                       message: "No se localizó el ISBN: " + isbn.text!,
                                                       preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Ok",
                                                 style: UIAlertActionStyle.Default,
                                                 handler: nil)
                    alertEmpty.addAction(okAction)
                    self.presentViewController(alertEmpty,
                                               animated: true,
                                               completion: nil)
                }
                else {
                self.resultado.text = "Error en conexión. Verifique que este conectado a internet."
                }
            }
        }
        else {
            resultado.text = "No se localizó el ISBN: " + isbn.text!
        }
    }
    
    @IBAction func backgroundTap(sender : UIControl)
    {
        isbn.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

