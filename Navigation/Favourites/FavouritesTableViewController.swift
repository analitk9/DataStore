//
//  FavouritesViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 5/16/22.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    var favourites = [Post]()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
   
    
    init() {
        super.init(nibName: nil, bundle: nil)
       // configureTabBarItem()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .black)
        navigationItem.title = "Favourites".localize()
        navigationItem.titleView?.tintColor = .createColor(lightMode: .white, darkMode: .black)
        view.addSubview(tableView)
        tableView.dataSource = self
        configureLayout()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        favourites = CoreDataService.shared.getFavouritesPosts()
        tableView.reloadData()
    }
    
    
    func configureTabBarItem() {
        tabBarItem.title = "Favourites".localize()
        tabBarItem.image = UIImage(systemName: "bookmark")
        tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        tabBarItem.tag = 40
    }

    func configureLayout(){
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ].forEach { $0.isActive = true }
    }
}
    // MARK: - Table view data source
    extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
        
         func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            UITableView.automaticDimension
        }
        

//         func numberOfSections(in tableView: UITableView) -> Int {
//            return 1
//        }
        
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return favourites.count
        }

        
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { fatalError() }
            let post = favourites[indexPath.row]
            cell.configure(post)

            return cell
        }
        
    }
        
   

   
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    


