//
//  ViewController.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 7/31/24.
//

import UIKit
import SystemConfiguration
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let viewModel = ViewModel()
    let deleteAlert = UIAlertController(title: nil, message: "Do you want to delete", preferredStyle: .alert)
    let productViewModel = CoreDataViewModel()
    var productModelArray :[ProductsArray] = []
    
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
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func tableViewDelegates() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier: "cell")
    }
    
    private func initUI() {
        tableViewDelegates()
    }
    
    private func checkNetworkStatus() {
        if NetworkReachability.isConnectedToNetwork()  {
            getProductData()
            
        }
        else {
            self.productViewModel.fetchProductData {
                self.viewModel.reports = self.productViewModel.products
                DispatchQueue.main.async(execute: {
                    self.loader.stopAnimating()
                    self.tableView.reloadData()
                })
            }
            showAlert()
        }
    }
    
    private func showAlert() {
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { alert in
            
            self.checkNetworkStatus()
        }
        
        let alert = AlertHelper.createAlertController(title: "No Internet Connection", message: "Check your internet connection", actions: [cancelAction, retryAction] )
        self.present(alert, animated: true)
    }
    
    func getProductData() {
        productViewModel.deleteAllProductsData()
        loader.startAnimating()
        viewModel.getData { data in
            self.viewModel.reports = data
            for product in data {
                self.productViewModel.saveToCoreData(data: product)
            }
            
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
         viewModel.reports.count
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
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func deldeteBtnTap(tag: Int) {
        
        let alertAction = UIAlertAction(title: "Yes", style: .default) { alert in
            let reportID = self.viewModel.reports[tag].id ?? 0
            self.viewModel.deleteData(id: reportID) {
                self.productViewModel.deleteReportFromCoreData(id: Int64(reportID))
                DispatchQueue.main.async {
                    self.viewModel.reports.remove(at: tag)
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        let alert = AlertHelper.createAlertController(title: nil, message: "Do you want to delete", actions: [alertAction,cancelAction])
        self.present(alert, animated: true)
    }
}

extension ViewController: UpdateCoreDataTitle {
    func updateTitle(id: Int64, title: String) {
        self.productViewModel.updateDataInCoreData(id: id, with: ["title": "\(title)"])
    }
}

extension ViewController: CreateCoreDataModel {
    func dataCreated(obj: DataModel) {
        productViewModel.saveToCoreData(data: obj)
    }
}
