//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/17/21.
//

import UIKit
import iOSIntPackage
import UniformTypeIdentifiers

class ProfileViewController: UIViewController {
    
    
    fileprivate enum CellReuseID: String {
        case `default` = "TableViewCellReuseIDDefault"
        case sectionHeader = "TableViewHeaderSectionID"
        case photoCell = "PhotoTableViewCellID"
    }
    
    var name: String
    var userService: UserService
    
    var profileViewModel: ProfileViewModel
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dragInteractionEnabled = true
        return table
    }()
    
    var detailProfileView: DetailProfileAvatar?
    
    init(model: ProfileViewModel, userService: UserService, name: String) {
        
        self.profileViewModel = model
        self.userService = userService
        self.name = name
        super.init(nibName: nil, bundle: nil)
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = tabBarItem.title
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        view.addSubview(tableView)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: CellReuseID.default.rawValue)
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: CellReuseID.sectionHeader.rawValue)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: CellReuseID.photoCell.rawValue)
        profileViewModel.send(.viewIsReady)
        setupViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        configureLayout()
    }
    
    func configureLayout() {
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ].forEach { $0.isActive = true }
    }
    
    private func setupViewModel() {
        profileViewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loaded:
                
                self.tableView.reloadData()
            case let .imageFiltered(filteredImage, indexPath):
                
                guard  let cell = self.tableView.cellForRow(at: indexPath) as? PostTableViewCell else {return}
                cell.applyImageFilter(filteredImage)
            case let .updateTimer(timerCount):
                
                DispatchQueue.main.async { [self] in
                    guard let profileView =  self.tableView.headerView(forSection: 0) as? ProfileHeaderView else {return}
                    profileView.timerLabel.text = String(timerCount)
                }
            case .newPost:
                
                DispatchQueue.main.async { [ self] in
                    self.showNewsAlert()
                }
            case let .postError(postError):

               let alert = ErrorAlertService().createAlert(postError.errorDescription)
                self.present(alert, animated: true, completion: nil)
            default:
                print("initial")
            }
        }
    }
    
    func showNewsAlert() {
        let alertVC = UIAlertController(title: "News".localize(), message: "New news has arrived!".localize(), preferredStyle: .alert)
        let button1 = UIAlertAction(title: "Ok", style: .default) { _ in
            self.profileViewModel.send(.newPostTake)
            self.tableView.reloadData()
        }
        let button2 = UIAlertAction(title: "Stop timer".localize(), style: .default) { _ in
            self.profileViewModel.send(.stopTimer)
            self.tableView.reloadData()
        }
        
        alertVC.addAction(button1)
        alertVC.addAction(button2)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
}

extension ProfileViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 220
        }else {
            return 0
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return profileViewModel.postModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let reUseID = CellReuseID.photoCell.rawValue
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reUseID, for: indexPath) as? PhotosTableViewCell else { fatalError() }
            cell.tapHandler = tapArrow
            cell.configure(with: profileViewModel.photoModel.suffix(4))
            return cell
        case 1:
            let reuseID = CellReuseID.default.rawValue
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? PostTableViewCell else { fatalError() }
            cell.delegate = profileViewModel
            let post = profileViewModel.postModel[indexPath.row]
            cell.configure(post)
            
            guard let image = UIImage(named: post.imageString) else {fatalError()}
            profileViewModel.send(.setupImageFilter(image, indexPath))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let reuseId = CellReuseID.sectionHeader.rawValue
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                        reuseId) as? ProfileHeaderView else { preconditionFailure("ProfileHeaderView not found!") }
            do {
                let currentUser = try userService.returnUser(for: name)
                view.profileNameLabel.text = currentUser.name
            
            }catch let userError as UserServiceError {
               
                let alert = ErrorAlertService().createAlert(userError.errorDescription)
                present(alert, animated: true, completion: nil)
            } catch {
                
                let alert = ErrorAlertService().createAlert(error.localizedDescription)
                present(alert, animated: true, completion: nil)
            }
            view.tapAvatarViewDelegate = self
            return view
        }
        return nil
    }
    
    func tapArrow(){
        profileViewModel.send(.pressButtonToPhotoVC)
    }
    
}

extension ProfileViewController: tapAvatarViewProtocol {
    
    
    func tapHandler(_ gesture: UITapGestureRecognizer) {
        guard let avatarImage = gesture.view else { return }
        avatarImage.isHidden = true
        detailProfileView = DetailProfileAvatar(with: avatarImage, frame: .zero)
        
        guard let showView = detailProfileView else {return}
        showView.frame.size = view.frame.size
        view.addSubview(showView)
        
        showView.profileAvatarView.frame = avatarImage.convert(avatarImage.bounds, to: view)
        showView.startRect = showView.profileAvatarView.frame
        showView.avatarAnimator.startAnimation()
        showView.buttonAnimator.startAnimation(afterDelay: 0.5)
    }
}

extension ProfileViewController: UITableViewDragDelegate {
    
    // метод создающий объекты при начале drag
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = indexPath
       return  dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath)-> [UIDragItem] {
        let post = profileViewModel.postModel[indexPath.row]
        let imageDragItem = UIDragItem(itemProvider: NSItemProvider(object: post.image))
        let descriptionDragItem = UIDragItem(itemProvider: NSItemProvider(object: NSString(string: post.description)))
        return [imageDragItem,descriptionDragItem]
    }
    
}

extension ProfileViewController: UITableViewDropDelegate {
    
   ///  метод непосредстенного дропа
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
      
        let destinationIndex = coordinator.destinationIndexPath ?? IndexPath(row: profileViewModel.postModel.count , section: 1)
        guard let selfDropItem = coordinator.items.first else {return}
        
        if let sourceIndex = selfDropItem.sourceIndexPath {
            // локальный дроп
            tableView.performBatchUpdates {
                let dragNews = profileViewModel.postModel.remove(at: sourceIndex.row)
                profileViewModel.postModel.insert(dragNews, at: destinationIndex.row)
                tableView.deleteRows(at: [sourceIndex], with: .automatic)
                tableView.insertRows(at: [destinationIndex], with: .automatic)
            }
            coordinator.drop(selfDropItem.dragItem, toRowAt: destinationIndex)
        }else{
            // дроп из вне
            var providerImage: UIImage?
            var providerDesc: NSString?
            var imageString: String?
            coordinator.items.forEach { item in
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { provider, error in
                    if let newImage = provider as? UIImage {
                        providerImage = newImage
                        imageString = UUID().uuidString
                    }
                    if let newDesc = provider as? NSString {
                        providerDesc = newDesc
                    }
                }
            }
            guard let providerDesc = providerDesc,
                  let providerImage = providerImage,
                  let imageString = imageString else { return }

            profileViewModel.writeImage(name: imageString, providerImage)
            let newPost = Post(title: "Drag and Drop NEWS", author: "Drag and Drop", description: String(providerDesc), imageString: imageString, likes: 0, views: 0)
            self.profileViewModel.postModel.append(newPost)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /// метод проверяет входящие при drop объекты и дает разрещение на drop
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        session.hasItemsConforming(toTypeIdentifiers: [UTType.text.identifier, UTType.image.identifier])
    }
    
    /// метод  показывает какие операции при drop будут выполнены (копирование, перемещение, отмена, запрет)
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        let isSelf = tableView.hasActiveDrag
        let dropProposal = UITableViewDropProposal(operation: isSelf ? .move :.copy, intent: .insertAtDestinationIndexPath)
        
        return dropProposal
    }
    
    
    
}
