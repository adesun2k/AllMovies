//
//  MovieDetailViewController.swift
//  AllMovies
//
//  Created by Seun Adeyemi on 17/12/2021.
//

import Foundation
import UIKit
import CoreData
import SDWebImage



class MovieDetailViewController: UIViewController{
    
    
    @IBOutlet weak var posterImage: UIImageView!
    var movie: Movies?

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
    func configure(with movie:Movies) {
            self.movie = movie
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = self.movie?.value(forKeyPath: "title") as? String ?? ""
        let posterLink:String =  self.movie?.value(forKeyPath: "poster") as? String ?? ""
        self.posterImage?.sd_setImage(with: URL(string: posterLink), placeholderImage: UIImage(systemName: "circle.hexagongrid.circle.fill"))
        self.posterImage?.layer.cornerRadius = 5
        self.posterImage?.clipsToBounds = true
        self.titleLabel?.text = self.movie?.value(forKeyPath: "title") as? String ?? ""
        self.yearLabel?.text = self.movie?.value(forKeyPath: "year") as? String ?? ""
        self.idLabel?.text = self.movie?.value(forKeyPath: "imdbid") as? String ?? ""
        self.typeLabel?.text = self.movie?.value(forKeyPath: "type") as? String ?? ""
       
      
    }
    
    
    
}
