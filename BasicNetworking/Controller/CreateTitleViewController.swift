//
//  CreateViewController.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 8/8/24.
//

import UIKit

class CreateTitleViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var characterValidationLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let viewModel = ViewModel()
    var randomID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initUI()
    }
    
    private func initUI() {
        saveBtn.backgroundColor = .systemGray
        characterValidationLabel.isHidden = false
    }
    
    private func generateRandomId() -> Int {
        Int.random(in: 30 ..< 200)
    }
    
    @IBAction func textField(_ sender: Any) {
        if textField.text?.isEmpty == true {
            characterValidationLabel.isHidden = false
            saveBtn.backgroundColor = .systemGray
        }
        else {
            characterValidationLabel.isHidden = true
            saveBtn.backgroundColor = .systemBlue
            
        }
    }
    
    @IBAction func saveTitleBtn(_ sender: Any) {
        
        if textField.text?.isEmpty == false {
            loader.startAnimating()
            viewModel.postData(dataModel: DataModel(id: generateRandomId(), stock: 2, price: 5, title: "\(textField.text ?? "nil")", description: "discover", discountPercentage: 2.00, rating: 4.52, brand: "Kumail", category: "Developer", thumbnail: "First", images: ["abc","qwer"])) { post in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 , execute: {
                    self.loader.stopAnimating()
                    let alertAction = UIAlertAction(title: "Ok", style: .default) { alert in
                        self.navigationController?.popViewController(animated: true)
                    }
                    let alert = AlertHelper.createAlertController(title: nil, message: post, actions: [alertAction])
                    self.present(alert, animated: true)
                })
            }
        }
        else {
            characterValidationLabel.isHidden = false
        }
    }
}
