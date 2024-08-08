//
//  ViewController.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 7/31/24.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let viewModel = ViewModel()
    let deleteAlert = UIAlertController(title: nil, message: "Do you want to delete", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.checkNetworkStatus()
    }
    
    
    @IBAction func createTitleBtn(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "createVC")as! CreateTitleViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func tableViewDelegates() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier: "cell")
    }
    
    private func initUI() {
        tableViewDelegates()
        getProductData()
    }
    
    private func checkNetworkStatus() {
        if NetworkReachability.isConnectedToNetwork()  {
            getProductData()
        }
        else {
            showAlert()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Check your internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.checkNetworkStatus()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func getProductData() {
        loader.startAnimating()
        viewModel.getData { data in
            self.viewModel.reports = data
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.tableView.reloadData()
            }
        } failure: { error in
            print(error)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! TableViewCell
        cell.titleLabel.text = viewModel.reports[indexPath.row].title
        cell.delegate = self
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        return cell
    }
}

extension ViewController: TableViewCellProtocol {
    
    func updateBtnTap(tag: Int) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "updateVC")as! UpdateViewController
        controller.updatedString = viewModel.reports[tag].title
        controller.report = viewModel.reports[tag]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func deldeteBtnTap(tag: Int) {
        
        let alertAction = UIAlertAction(title: "Yes", style: .default) { alert in
            self.viewModel.deleteData(id: self.viewModel.reports[tag].id ?? 0) {
                DispatchQueue.main.async {
                    self.viewModel.reports.remove(at: tag)
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        let alert = AlertHelper.createAlertController(title: nil, message: "Do you want to delete", actions: [alertAction,cancelAction])
        present(alert, animated: true)
    }
}
