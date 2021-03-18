//
//  ViewController.swift
//  jsonparser
//
//  Created by Oğuzhan Varsak on 18.03.2021.
//

import UIKit
var indexAt: Int = 1

class ViewController: UIViewController {

    @IBOutlet weak var publishedAtLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var sourceNameLbl: UILabel!
    
    @IBOutlet weak var urlToImageView: UIImageView!
    
    @IBAction func sonrakiHaberBtn(_ sender: Any) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=059fe3f084b3477496a2ea886da60c98"

        func haber (index: Int) {
            let url = URL(string: urlString)
            guard url != nil else {
                debugPrint("URL nil")
                return
            }
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url!) {(data, response, error) in
                
                if error == nil && data != nil {
                    let decoder = JSONDecoder()
                    
                    do {
                        let newsFeed = try decoder.decode(NewsFeed.self, from: data!)
                        print("Parsed -> \(newsFeed)")
                        DispatchQueue.main.async {
                            self.titleLbl.text = newsFeed.articles[index].title
                            self.urlToImageView.downloaded(from: newsFeed.articles[index].urlToImage!)
                            self.contentLbl.text = newsFeed.articles[index].description
                            self.sourceNameLbl.text = newsFeed.articles[index].author
                            self.publishedAtLbl.text = newsFeed.articles[index].publishedAt
                            
                            indexAt += 1
                        }
                        
                    } catch {
                        debugPrint("Error parsing")
                    }
                }
            }
            dataTask.resume()
        }
        haber(index: indexAt)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=059fe3f084b3477496a2ea886da60c98"
        
        let url = URL(string: urlString)
        guard url != nil else {
            debugPrint("URL nil")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) {(data, response, error) in
            
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                
                do {
                    let newsFeed = try decoder.decode(NewsFeed.self, from: data!)
                    print("Parsed -> \(newsFeed)")
                    DispatchQueue.main.async {
                        self.titleLbl.text = newsFeed.articles[0].title
                        self.urlToImageView.downloaded(from: newsFeed.articles[0].urlToImage!)
                        self.contentLbl.text = newsFeed.articles[0].description
                        self.sourceNameLbl.text = newsFeed.articles[0].author
                        self.publishedAtLbl.text = newsFeed.articles[0].publishedAt
                    }
                    
                } catch {
                    debugPrint("Error parsing")
                }
            }
        }
        dataTask.resume()
        
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
