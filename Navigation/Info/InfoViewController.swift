//
//  InfoViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/17/21.
//

import UIKit
import SnapKit
import SwiftUI

struct UserJson: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

struct Planet: Codable {
    let name: String
    let rotationPeriod: String
    let orbitalPeriod: String
    let diameter: String
    let climate: String
    let gravity: String
    let terrain: String
    let surfaceWater: String
    let population: String
    let residents: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter = "diameter"
        case climate = "climate"
        case gravity = "gravity"
        case terrain = "terrain"
        case surfaceWater = "surface_water"
        case population = "population"
        case residents = "residents"
        case films = "films"
        case created = "created"
        case edited = "edited"
        case url = "url"
    }
}

struct Resident: Codable {
    let name: String
}

class InfoViewController: UIViewController {
    
    var residents = [String]()
    
    lazy var labelDz1: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.text = "placeholder"
        lb.textAlignment = .center
        lb.layer.borderColor = UIColor.black.cgColor
        lb.layer.borderWidth = 2
        view.addSubview(lb)
        return lb
    }()
    
    lazy var labelDz2: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.text = "placeholder"
        lb.textAlignment = .center
        lb.layer.borderColor = UIColor.black.cgColor
        lb.layer.borderWidth = 2
        view.addSubview(lb)
        return lb
    }()
    
    lazy var alertButton: UIButton = {
        let button = CustomButton(frame: .zero, title: "Alert", tintColor: nil)
        button.backgroundColor = .systemRed
        button.onTap = pressedAlertButton
        self.view.addSubview(button)
        return button
    }()
    
    lazy var stackView: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [labelDz1, labelDz2, alertButton])
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
      
      view.addSubview(stackView)
      
      return stackView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        view.backgroundColor = .white
        title = "Info"
        fetchSerialization()
        fetchJson()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
 
    func configureLayout(){
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(150)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(stackView.snp.top).offset(-6)
        }
    }
    
    func fetchSerialization(){
        var user = UserJson(userId: 1, id: 1, title: "", completed: false)
        
       guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {  return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let unwrappedData = data {
                do{
                    let serializedDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                    if let dict = serializedDictionary as? [String: Any] {
                        if let title = dict["title"] as? String {
                            user.title = title
                        }
                        if let id = dict["id"] as? Int {
                            user.id = id
                        }
                        if let userId = dict["userId"] as? Int {
                            user.userId = userId
                        }
                        if let completed = dict["completed"] as? Bool {
                            user.completed = completed
                        }
                        if !user.title.isEmpty {
                            DispatchQueue.main.async {
                                self.labelDz1.text = user.title
                            }
                        }
                    }
                }
                    catch let error {
                        print(error)
                    }
            }
            
        }.resume()
    }
    
    func fetchJson(){
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else {  return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let unwrappedData = data {
                do {
                    let planet = try JSONDecoder().decode(Planet.self, from: unwrappedData)
                    planet.residents.forEach { residentUrl in
                        self.fetchResident(stringURL: residentUrl)
                    }
                    DispatchQueue.main.async {
                        self.labelDz2.text = planet.orbitalPeriod
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func fetchResident(stringURL: String){
        guard let url = URL(string: stringURL) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let unwrappedDate = data {
                do {
                    let resident = try JSONDecoder().decode(Resident.self, from: unwrappedDate)
                    self.residents.append(resident.name)
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                    }
                }catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func pressedAlertButton (){
        let alertVC = UIAlertController(title: "Внимание", message: "Выберите действие", preferredStyle: .alert)
        let button1 = UIAlertAction(title: "Первое сообщение", style: .default){ _ in
            print("Первое сообщение")
        }
        let button2 = UIAlertAction(title: "Второе сообщение", style: .default){ _ in
            print("Второе сообщение")
        }
        let button3 = UIAlertAction(title: "exit info VC", style: .default){ _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(button1)
        alertVC.addAction(button2)
        alertVC.addAction(button3)
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =  residents[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
}

struct AdvancedProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let vc = InfoViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<AdvancedProvider.ContainterView>) -> InfoViewController {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: AdvancedProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<AdvancedProvider.ContainterView>) {
            
        }
    }
}
