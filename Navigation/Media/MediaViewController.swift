//
//  MediaViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 2/25/22.
//

import UIKit
import AVFoundation
import AVKit


class MediaViewController: UIViewController {
    
    let songList = ["Asia Down", "Melodic song", "Timepieces", "Happy song", "Blue song"]
    let videoArchive = ["Video1": "ife5YK-Keng" , "Video2": "Yv62q3c3UxI" , "Video3": "Uxzay4CPzPA" , "Video4": "p6xqKJqsQWs" , "Video5": "BhbhiQZwjf4" ]
    let videoList = ["Video1", "Video2", "Video3", "Video4", "Video5"]
    var currentSong = "" {
        didSet {
            audioView.SongNameLabel.text = currentSong
        }
    }
    var currentIndex = 0
    var audioPlayer = AVAudioPlayer()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    let audioView: AudioView = {
        let view = AudioView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let recButton: UIButton = {
        let but = UIButton(frame: .zero)
        but.setImage(UIImage(systemName: "record.circle.fill"), for: .normal)
        but.tintColor = .red
        but.layer.borderColor = UIColor.black.cgColor
        but.translatesAutoresizingMaskIntoConstraints = false
        return  but
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureAudioButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .black)
        view.addSubview(audioView)
        view.addSubview(tableView)
        view.addSubview(recButton)
        currentSong = songList.first!
        prepareAudio()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        recButton.addTarget(self, action: #selector(presentRecVC), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
    
    func configureLayout(){
        [   audioView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            audioView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            audioView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            audioView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -40),
            tableView.topAnchor.constraint(equalTo: view.centerYAnchor),
            recButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5),
           
            recButton.heightAnchor.constraint(equalToConstant: 20)
        ].forEach { $0.isActive = true }
        
    }

    func configureAudioButton(){
        audioView.nextButton.onTap = pressNext
        audioView.playButton.onTap = pressPlay
        audioView.stopButton.onTap = pressStop
        audioView.pauseButton.onTap = pressPause
        audioView.previousButton.onTap = pressPrevious
    }
    
    func pressNext(){
        if currentIndex < songList.count-1 {
           currentIndex += 1
           
        }else {
            currentIndex = 0
        }
        currentSong = songList[currentIndex]
        prepareAudio()
        
    }
    
    func pressPlay(){
        audioPlayer.play()
    }
    
    func pressStop(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
    func pressPause(){
        audioPlayer.pause()
    }
    
    func pressPrevious(){
        if currentIndex != 0 {
           currentIndex -= 1
           
        }else {
            currentIndex = songList.count-1
        }
        currentSong = songList[currentIndex]
        prepareAudio()
    }
    
    func prepareAudio(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: currentSong, ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    @objc func presentRecVC(){
        present(RecViewController(), animated: true, completion: nil)
    }
}

extension MediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =  videoList[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
}

extension MediaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = videoList[indexPath.row]
        guard let VideoId = videoArchive[key] else {return}
        let controller = VideoPlayerViewController()
        controller.videoID = VideoId
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        present(controller, animated: true)
    }
}
