//
//  AudioView.swift
//  Navigation
//
//  Created by Denis Evdokimov on 2/25/22.
//

import UIKit
import SnapKit

class AudioView: UIView {

    let SongNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Song"
        label.textAlignment = .center
        label.textColor = .createColor(lightMode: .black, darkMode: .white)
        
        return label
    }()
    
    let previousButton: CustomButton = {
        let but = CustomButton(frame: .zero, title: nil, tintColor: UIColor.createColor(lightMode: .black, darkMode: .white))
        but.setImage(UIImage(systemName: "backward.end"), for: .normal)
        but.setImage(UIImage(systemName: "backward.end.fill"), for: .highlighted)
        but.backgroundColor = UIColor(patternImage: UIImage(named: "bluePixel")!)
        but.layer.borderWidth = 1
        return but
    }()
    
    let pauseButton: CustomButton = {
        let but = CustomButton(frame: .zero, title: nil, tintColor: UIColor.createColor(lightMode: .black, darkMode: .white))
        but.setImage(UIImage(systemName: "pause"), for: .normal)
        but.setImage(UIImage(systemName: "pause.fill"), for: .highlighted)
        but.backgroundColor = UIColor(patternImage: UIImage(named: "bluePixel")!)
        but.layer.borderWidth = 1
        return but
    }()
    
    let stopButton: CustomButton = {
        let but = CustomButton(frame: .zero, title: nil, tintColor: UIColor.createColor(lightMode: .black, darkMode: .white))
        but.setImage(UIImage(systemName: "stop"), for: .normal)
        but.setImage(UIImage(systemName: "stop.fill"), for: .highlighted)
        but.backgroundColor = UIColor(patternImage: UIImage(named: "bluePixel")!)
        but.layer.borderWidth = 1
        return but
    }()
    
    let playButton: CustomButton = {
        let but = CustomButton(frame: .zero, title: nil, tintColor: UIColor.createColor(lightMode: .black, darkMode: .white))
        but.setImage(UIImage(systemName: "play"), for: .normal)
        but.setImage(UIImage(systemName: "play.fill"), for: .highlighted)
        but.backgroundColor = UIColor(patternImage: UIImage(named: "bluePixel")!)
        but.layer.borderWidth = 1
        return but
    }()
    
    let nextButton: CustomButton = {
        let but = CustomButton(frame: .zero, title: nil, tintColor: UIColor.createColor(lightMode: .black, darkMode: .white))
        but.setImage(UIImage(systemName: "forward.end"), for: .normal)
        but.setImage(UIImage(systemName: "forward.end.fill"), for: .highlighted)
        but.backgroundColor = UIColor(patternImage: UIImage(named: "bluePixel")!)
        but.layer.borderWidth = 1
        return but
    }()
    
    let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.layer.cornerRadius = 10
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.borderWidth = 0.5
        stack.clipsToBounds = true
        return stack
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.layer.cornerRadius = 10
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.borderWidth = 0.5
        stack.clipsToBounds = true
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hStack.addArrangedSubview(previousButton)
        hStack.addArrangedSubview(pauseButton)
        hStack.addArrangedSubview(stopButton)
        hStack.addArrangedSubview(playButton)
        hStack.addArrangedSubview(nextButton)
            
        vStack.addArrangedSubview(SongNameLabel)
        vStack.addArrangedSubview(hStack)
        
        addSubview(vStack)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    func configureLayout(){
        vStack.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
    }
}
