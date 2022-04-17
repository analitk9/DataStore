//
//  DetailProfileAvatar.swift
//  Navigation
//
//  Created by Denis Evdokimov on 11/16/21.
//

import UIKit

protocol ButCloseDelegate {
  func closeButTapped()
}

class DetailProfileAvatar: UIView {
   
    private enum Constans{
        static let padding: CGFloat = 16
        static let avatarViewSideSize: CGFloat = 110
    }
    
    
    var clickView: UIView?
    var avatarAnimator: UIViewPropertyAnimator!
    var buttonAnimator: UIViewPropertyAnimator!
    
    
    let alfaView: UIView = {
        let alfaView = UIView()
        alfaView.translatesAutoresizingMaskIntoConstraints = false
        alfaView.backgroundColor = .white
        alfaView.alpha = 0.0
        return alfaView
    }()
    var startRect: CGRect?
    
    let profileAvatarView: UIImageView = {
        let rect = CGRect(x: 0, y: 0, width: Constans.avatarViewSideSize, height: Constans.avatarViewSideSize)
        let image = ProfileAvatarView(frame: rect)
        image.configure()
        image.translatesAutoresizingMaskIntoConstraints = true
        return image
    }()
    
    let closeButton: CustomButton = {
        let but = CustomButton(frame: .zero, title: nil, tintColor: nil)
        let conf = UIImage.SymbolConfiguration(pointSize: 30, weight: .heavy, scale: .large)
        let image = UIImage(systemName: "xmark.circle",withConfiguration: conf)
        but.alpha = 0.0
        but.setImage(image, for: .normal)
      
        but.layer.cornerRadius = but.bounds.size.width / 2
        but.clipsToBounds = true
        but.translatesAutoresizingMaskIntoConstraints = false
        return but
    }()
 
    
    init(with clickView: UIView, frame: CGRect){
        super.init(frame: frame)
        closeButton.onTap = closeTap
        backgroundColor = .clear
        self.clickView = clickView
        alfaView.frame.size = frame.size
        addSubview(alfaView)
        addSubview(profileAvatarView)
        addSubview(closeButton)
        createAvatarAnimation()
        createButAnimation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    func configureLayout(){
        [
        
        alfaView.widthAnchor.constraint(equalTo: self.widthAnchor),
        alfaView.heightAnchor.constraint(equalTo: self.heightAnchor),
        alfaView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        alfaView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        
        closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: Constans.padding),
        closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constans.padding)
        ].forEach {
            $0.isActive = true
        }
    }
    
     func closeTap(){

        buttonAnimator.isReversed = true
        buttonAnimator.pausesOnCompletion = false
        
        buttonAnimator.startAnimation()
        
        avatarAnimator.isReversed = true
        avatarAnimator.pausesOnCompletion = false
        avatarAnimator.addCompletion { [unowned self] _ in
            clickView?.isHidden = false
            removeFromSuperview()
        }
        avatarAnimator.startAnimation()
    }
    
    
    func createAvatarAnimation(){
        avatarAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) { [unowned self] in
            profileAvatarView.frame.size.width = self.bounds.width
            profileAvatarView.frame.size.height = self.bounds.width
            profileAvatarView.center = self.center
            profileAvatarView.layer.cornerRadius = 0.0
            alfaView.alpha = 0.5
        }
        avatarAnimator.pausesOnCompletion = true

    }
    func createButAnimation(){
        buttonAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .linear, animations: {[unowned self] in
            closeButton.alpha = 1.0
        })
        buttonAnimator.pausesOnCompletion = true
    }
    
}
