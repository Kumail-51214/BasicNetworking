//
//  UpdateViewController.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 8/5/24.
//

import UIKit

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var characterValidationLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    let viewModel = ViewModel()
    var updatedString: String?
    var report: DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initUI()
    }
    
    private func initUI() {
        textField.text = updatedString
    }
    
    @IBAction func textFieldEditing(_ sender: Any) {
        if textField.text?.isEmpty == true {
            characterValidationLabel.isHidden = false
            saveBtn.backgroundColor = .systemGray
        }
        else {
            characterValidationLabel.isHidden = true
            saveBtn.backgroundColor = .systemBlue

        }
    }
        
        @IBAction func saveBtn(_ sender: Any) {
          
            if textField.text?.isEmpty == false {
                
            loader.startAnimating()
            report?.title = "\(textField.text ?? "null")"
            viewModel.updateData(id: report?.id ?? 0, dataModel: DataModel(id: report?.id, stock: report?.stock ?? 12, price: report?.price ?? 14, title: report?.title ?? "", description:  report?.description ?? "", discountPercentage: report?.discountPercentage ?? 1.00, rating: report?.rating ?? 2.00, brand: report?.brand ?? "abc", category: report?.category ?? "Software", thumbnail: report?.thumbnail ?? "Engnr", images: report?.images ?? ["abcdef","kumail"])) { msg in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 , execute: {
                    self.loader.stopAnimating()
                    let alertAction = UIAlertAction(title: "Ok", style: .default) { alert in
                        self.navigationController?.popViewController(animated: true)
                    }
                    let alert = AlertHelper.createAlertController(title: nil, message: msg, actions: [alertAction])
                    self.present(alert, animated: true)
                })
            }
        }
            else {
                characterValidationLabel.isHidden = false
            }
    }
}
