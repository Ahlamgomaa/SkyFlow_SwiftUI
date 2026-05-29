import SwiftUI
import AVKit

struct VideoBackgroundView: UIViewRepresentable {
    var videoName: String
    var videoType: String = "mp4"

    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(videoName: videoName, videoType: videoType)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let view = uiView as? LoopingPlayerUIView else { return }
        view.updateVideo(videoName: videoName, videoType: videoType)
    }
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    
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
    
    func setupPlayer(videoName: String, videoType: String) {
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
        queuePlayer?.play()
    }
    
    func updateVideo(videoName: String, videoType: String) {
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
        queuePlayer?.play()
    }
}
