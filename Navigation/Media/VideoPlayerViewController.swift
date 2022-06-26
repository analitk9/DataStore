//
//  VideoPlayerViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 4/25/22.
//

import UIKit
import YouTubeiOSPlayerHelper
import SnapKit
class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate {

    var videoID: String!
    lazy var videoPlayer: YTPlayerView = {
        let player = YTPlayerView(frame: .zero)
        player.delegate = self
       
       
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubview(videoPlayer)
        videoPlayer.load(withVideoId: videoID)
    }
    
    override func viewWillLayoutSubviews() {
        videoPlayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

   

}
