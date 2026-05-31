import SwiftUI
import AVKit

struct VideoBackgroundView: UIViewRepresentable {
    var videoName: String
    var videoType: String = "mp4"

    func makeUIView(context: Context) -> LoopingPlayerUIView {
        return LoopingPlayerUIView(videoName: videoName, videoType: videoType)
    }

    func updateUIView(_ uiView: LoopingPlayerUIView, context: Context) {
        uiView.updateVideo(videoName: videoName, videoType: videoType)
    }
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    private var currentVideoName: String?
    init(videoName: String, videoType: String) {
        super.init(frame: .zero)
        setupPlayer(videoName: videoName, videoType: videoType)
        
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    private func setupPlayer(videoName: String, videoType: String) {
        guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else {
            print("Video \(videoName).\(videoType) not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = player
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        queuePlayer = player
        currentVideoName = videoName
        queuePlayer?.play()
    }
    
    func updateVideo(videoName: String, videoType: String) {
        guard videoName != currentVideoName else { return }
        
        guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else {
            print("Video \(videoName).\(videoType) not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        
        queuePlayer?.pause()
        playerLooper?.disableLooping()
        
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = player
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        queuePlayer = player
        currentVideoName = videoName
        queuePlayer?.play()
    }
}
