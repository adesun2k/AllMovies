//
//  ViewController.swift
//  AllMovies
//
//  Created by Seun Adeyemi on 15/12/2021.
//

import UIKit
import CoreData
import SwiftyJSON
import SDWebImage 


var vSpinner : UIView?
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    @IBOutlet weak var movieListTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
    var movies: [NSManagedObject] = []
    var curPage:Int = 1
    var searchKey:String = "Batman"
    var searchText:String = ""
    static let showDetailSegueIdentifier = "ShowDetailSegue"
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Movies"
        self.movieListTable.dataSource = self
        self.movieListTable.delegate = self
        self.movieListTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.movieListTable.keyboardDismissMode = .onDrag
        self.searchBar.delegate = self
       
        // display all available batman movies
        fetchMovies()
        // get batman movies from saver and persiter them to local database for quick search.
        self.getAllMoviesFromServer()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchText = searchText
            fetchMovies()
            print("searchText \(searchText)")
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
            if searchBar.text != nil {
             self.searchText = searchBar.text!
             fetchMovies()
            }
            self.searchBar.endEditing(true)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier,
                   let destination = segue.destination as? MovieDetailViewController,
                   let cell = sender as? UITableViewCell,
           let indexPath = self.movieListTable.indexPath(for: cell) {
                    let movieDetails = movies[indexPath.row] as! Movies
                    destination.configure(with: movieDetails)
            
            self.searchBar.endEditing(true)
                }
        }
    
    
    func fetchMovies(){
        // load Batman movies from database if they have been fetched from server already.
        do {
            // if user typed in something to search then let get only what the is looking for instead of shwowing all
            if self.searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
             fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR year CONTAINS[cd] %@ OR imdbid CONTAINS[cd] %@ OR type CONTAINS[cd] %@", self.searchText, self.searchText, self.searchText, self.searchText)
            }
             movies = try managedContext.fetch(fetchRequest)
            //show spinner if none has never been downloaded.
            if movies.count == 0 {
                self.showSpinner(onView: self.view)
            }else{
            //dismiss spinner
                self.removeSpinner()
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        movieListTable.reloadData()
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return movies.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
    let cell:MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell",for: indexPath) as! MovieTableViewCell
        
      let movie = movies[indexPath.row]
      cell.accessibilityIdentifier = "myCell_\(indexPath.row)"
      cell.titleLabel?.text = movie.value(forKeyPath: "title") as? String
      cell.yearLabel?.text = movie.value(forKeyPath: "year") as? String
      let posterLink:String =  movie.value(forKeyPath: "poster") as! String
      cell.posterImage?.sd_setImage(with: URL(string: posterLink), placeholderImage: UIImage(systemName: "circle.hexagongrid.circle.fill"))
      cell.posterImage?.layer.cornerRadius = (cell.posterImage?.frame.size.width ?? 150) / 2
      cell.posterImage?.clipsToBounds = true
      cell.posterImage?.layer.borderColor = UIColor.white.cgColor
      cell.posterImage?.layer.borderWidth = 10
      
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.searchBar.endEditing(true)
     }

    func getAllMoviesFromServer(){
        
               /*
               This method gets a list of all the movies ever created about
               Batman, the Marvel superhero and persisted them locally.
               */
        
            // First check internet connection.
          if !InternetConnectionManager.isConnectedToNetwork(){
            print("Not Connected")
            self.removeSpinner()
            self.showNoInternetAlert()
              
              return
           }
        
            guard let url = URL(string: "https://www.omdbapi.com/?s=\(searchKey)&page=\(curPage)&apikey=86c4b2d9") else {
            print("Invalid URL")
            return
            }
        
            let parameterDictionary = ["s" : "Batman"]
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                return
            }
            request.httpBody = httpBody
            URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let json = JSON(jsonObject)
                    let ResponseData = json["Response"].stringValue
                    print(ResponseData)
                    if ResponseData.caseInsensitiveCompare("true") == .orderedSame {
                        print(ResponseData,"Yea")
                        if let movieItems = json["Search"].array {
                           for movieItem in movieItems {
                             let title = movieItem["Title"].stringValue
                             let year = movieItem["Year"].stringValue
                             let imdbid = movieItem["imdbID"].stringValue
                             let type_ = movieItem["Type"].stringValue
                             let poster = movieItem["Poster"].stringValue
                             // save to database
                             CoreDataManager.sharedManager.insertMovie(title,year,imdbid,type_,poster)
                             print("Childreen",title, year,imdbid,type_,poster)
                           }
                            print("Childreen Count",movieItems.count,self.curPage)
                            DispatchQueue.main.async {
                                self.fetchMovies()
                            }
                            // I loop trhough to get all movies avaiables
                            self.curPage = self.curPage + 1
                            
                            self.getAllMoviesFromServer()
                         }
                       
                    }
                    } catch {
                                   print(error)
                                
                               }
                         
            }else if let error = error {
                print(error)
                
            }
            
        }.resume()
    
}
    
    func showNoInternetAlert(){
        let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection. Please check your internet connection and re-open this app.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                controller.addAction(ok)
                controller.addAction(cancel)

                present(controller, animated: true, completion: nil)
    }

}
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}


