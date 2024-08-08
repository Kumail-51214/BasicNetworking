//
//  ViewModel.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 8/1/24.

import UIKit

class ViewModel {
    
    let baseUrl = "https://dummy.codeduthu.com/products/"
    var reports: [DataModel] = []
    
    func getData(success: @escaping([DataModel]) -> Void, failure: @escaping(String) -> Void) {
        
        let session = URLSession.shared
        let reportUrl = URL(string: baseUrl)!
        
        let task = session.dataTask(with: reportUrl) { data, response, error in
            
            if error == nil {
                do {
                    let jsonData = try JSONDecoder().decode(([DataModel]).self, from: data!)
                    success(jsonData)
                    for post in jsonData {
//                        print(post.title as Any)
                    }
                }
                catch {
                    failure(error.localizedDescription)
                }
            }
            else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
    func postData(dataModel: DataModel?,  completion: @escaping(String) -> Void) {
        
        let session = URLSession.shared
        let reportUrl = URL(string: baseUrl)!
        
        guard let jsonData = try? JSONEncoder().encode(dataModel) else {
            print("erorrrrrrrrrrrr")
            return
        }
        var request = URLRequest(url: reportUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                completion(httpResponse.statusCode == 200 || httpResponse.statusCode == 201 ? "Successfully Created..." : httpResponse.statusCode == 500 ? "ID must not be same" : "Something went Wrong")
            }
        }
        task.resume()
    }
    
    func updateData(id: Int , dataModel: DataModel?, completion: @escaping(String) -> Void) {
        let session = URLSession.shared
        let reportUrl = URL(string: baseUrl+"\(id)")!
        
        guard let jsonData = try? JSONEncoder().encode(dataModel) else {
            print("erorrrrrrrrrrrr")
            return
        }
        var request = URLRequest(url: reportUrl)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                completion(error?.localizedDescription ?? "something went wrong")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                completion(httpResponse.statusCode == 200 ? "Successfully Updated..." : "Something went Wrong")
            }
        }
        task.resume()
    }
    
    func deleteData(id: Int, completion: @escaping() -> Void) {
        let session = URLSession.shared
        let reportUrl = URL(string: baseUrl+"\(id)")!
        
        var request = URLRequest(url: reportUrl)
        request.httpMethod = "DELETE"
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            completion()
        }
        task.resume()
    }
}
