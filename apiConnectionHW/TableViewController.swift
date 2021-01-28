//
//  TableViewController.swift
//  apiConnectionHW

import UIKit
import Alamofire

class TableViewController: UITableViewController {

    var thumbnailURLs = [String]()
    var titles = [String]()
    
    
    // daha önce derste kullandığımız yapı dışında birşeyler denemiştim. struct yapısı yaerine ayrı array'ler içerisinde tutmak çok mantıklı olmasa da bu haliyle sizinle paylaşmak istedim
    
    var shouldShowResults = false
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120

        getData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if titles.count > thumbnailURLs.count{
            return thumbnailURLs.count
        } else {
            return titles.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        let imageUrl = thumbnailURLs[indexPath.row]
        let titleText = titles[indexPath.row]
        
        let data = try? Data(contentsOf: imageUrl.asURL())
        cell.imageView?.image = UIImage(data: data!)
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = titleText
        
        return cell
    }
    
    func getData(){
        progress.startAnimating()
        
        let url = "https://jsonplaceholder.typicode.com/photos"
        let request = AF.request(url, method: .get).validate()
                request.responseJSON { (data) in
                   // print(data)
                }
        
       request.responseDecodable(of: PhotosData.self) { (response) in
                    switch response.result {
                    case .success(let models):
                       // print(models)
                        self.shouldShowResults = true
                        let count =  models.count
                        for member in 0...count - 1{
                            self.thumbnailURLs.append(models[member].thumbnailURL)
                            self.titles.append(models[member].title)
                        }
                        self.tableView.reloadData()
                        self.progress.stopAnimating()
                        self.progress.alpha = 0
                        self.progress.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                        
                    case .failure(let error):
                        do {
                            self.makeAlert(alertTitle: "We are sorry...", alertMessage: "Something went wrong!")
                            print(error)
                            
                        }
                    }
                    
                }
    }
    
    func makeAlert(alertTitle: String, alertMessage: String){
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
            
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (UIAlertAction) in print("OK button clicked")
            }
            
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
}
