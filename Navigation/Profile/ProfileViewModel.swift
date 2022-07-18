//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/27/22.
//

import UIKit
import iOSIntPackage

class ProfileViewModel {
    private(set) var state: ProfileState = .initial {
        didSet {
            onStateChanged?(state) // сюда модель сообщает о изменении своего состояния
        }
    }
    var onStateChanged: ((ProfileState) -> Void)?
    var toPhotoVC: (()-> Void)?
    var postModel: [Post] = [Post]()
    var photoModel: [Photo] = [Photo]()
    let imageProcessor = ImageProcessor()
    private let postsService: Posts
    private let photoService: Photos
    private var postTimer: Timer?
    private var timerCount = 4
    
    init(postsService: Posts, photoService: Photos) {
        self.postsService = postsService
        self.photoService = photoService
    }
    
    func send(_ action: Action){
        switch action {
        case let  .setupImageFilter(image, indexPath):
            applyFilter(to: image, in: indexPath)
            
        case .pressButtonToPhotoVC:
            toPhotoVC?()
            
        case .viewIsReady:
            fetch()
            createTimer()
            
        case .newPostTake:
            createTimer()
            
        case .stopTimer:
            cancelTimer()
        }
    }
    
    private func createTimer() {
        postTimer = Timer(timeInterval: 1.0,
                          target: self,
                          selector: #selector(updateTimer),
                          userInfo: nil,
                          repeats: true)
        postTimer?.tolerance = 0.1
        
            DispatchQueue.global().async {
                guard let postTimer = self.postTimer else {return}
                RunLoop.current.add(postTimer, forMode: .common)
                RunLoop.current.run()
               
            }
        
    }
    
    private func cancelTimer() {
   
        postTimer?.invalidate()
        postTimer = nil
       
    }
    
    
  @objc private func updateTimer() {
      if timerCount != 0 {
          timerCount -= 1
      }else {
          timerCount = 4
          cancelTimer()
          postModel.append(postModel.randomElement()!)
          state = .newPost
         
      }
      state = .updateTimer(timerCount)

    }
    
    private func fetch(){
        postsService.fetchPosts({ [weak self] result in
            switch result{
            case let .success(posts):
                self?.postModel = posts
            case let .failure(postError):
                DispatchQueue.main.async {
                    self?.state = .postError(postError)
                    self?.cancelTimer()
                }
            }
        })
        photoModel = photoService.createMockPhotos()
        state = .loaded
    }
    
    func applyFilter(to image: UIImage, in indexPath: IndexPath){
        imageProcessor.processImageAsync(sourceImage:image, filter: ColorFilter.allCases.randomElement()!) { resultImage in
            guard let resultImage = resultImage else {fatalError()}
            DispatchQueue.main.async { [weak self] in
                let resultImage = UIImage(cgImage: resultImage)
                self?.state = .imageFiltered(resultImage, indexPath)
            }
        }
    }
    
}

extension ProfileViewModel {
    
    enum Action { //  состояния вью
        case viewIsReady
        case pressButtonToPhotoVC
        case setupImageFilter(UIImage, IndexPath)
        case newPostTake
        case stopTimer
    }
    
    enum ProfileState { // состояния модели
        
        case initial
        case imageFiltered(UIImage, IndexPath)
        case updateTimer(Int)
        case newPost
        case loaded
        case postError(PostError)
        
    }
}

extension ProfileViewModel: PostViewCellDelegate {
    
    func addToFavourite(_ post: Post) {
        CoreDataService.shared.saveFavouritePost(post)
    }
    
    
}
