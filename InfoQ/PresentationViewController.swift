import AVFoundation
import AVKit
import UIKit

class PresentationViewController: UIViewController {

    var presentation: Presentation?
    var playerViewController: AVPlayerViewController?
    lazy var api: APIController = APIController()

    
    convenience init(_ presentation: Presentation) {
        self.init()
        self.presentation = presentation
    }


    // MARK: UIViewController Protocol

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Use AutoLayout
        let DIM_WIDTH: CGFloat = 320
        let MARGIN: CGFloat = 10
        let WIDTH: CGFloat = DIM_WIDTH - 2 * MARGIN
        let DEFAULT_ASPECT_RATIO: CGFloat = 1.0 //0.5625
        var OFFSET = MARGIN

        let title = UILabel()
        title.frame = CGRect(x: MARGIN, y: OFFSET, width: WIDTH, height: 100.0)
        title.numberOfLines = 0
        title.textAlignment = .Center
        title.font = .boldSystemFontOfSize(22)
        title.backgroundColor = .whiteColor()
        title.text = presentation!.title
        OFFSET += MARGIN + 100.0

        let author = UILabel()
        author.frame = CGRect(x: MARGIN, y: OFFSET, width: WIDTH, height: 20.0)
        author.numberOfLines = 1
        author.textAlignment = .Center
        author.backgroundColor = .whiteColor()
        author.text = "by \(presentation!.authorsFormatted!)"
        OFFSET += MARGIN + 20.0

        let summary = UILabel()
        summary.frame = CGRect(x: MARGIN, y: OFFSET, width: WIDTH, height: 150.0)
        summary.numberOfLines = 0
        summary.textAlignment = .Center
        summary.backgroundColor = .whiteColor()
        summary.text = presentation!.summary
        OFFSET += MARGIN + 150.0

        playerViewController = AVPlayerViewController()
        playerViewController!.view.frame = CGRect(
            x: MARGIN,
            y: OFFSET,
            width: WIDTH,
            height: WIDTH * DEFAULT_ASPECT_RATIO)
        OFFSET += WIDTH * DEFAULT_ASPECT_RATIO

        let scrollView = UIScrollView(frame: view.frame)
        scrollView.addSubview(title)
        scrollView.addSubview(author)
        scrollView.addSubview(summary)
        scrollView.addSubview(playerViewController!.view)
        scrollView.contentSize = CGSize(width: CGFloat(DIM_WIDTH), height: OFFSET)

        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(scrollView)
    }

    override func viewDidAppear(animated: Bool) {
        api.fetchPresentation(presentation!.id!) { presentation in
            let playerItem = AVPlayerItem(URL: presentation.videoUrl)
            playerItem.addObserver(self, forKeyPath: "presentationSize", options: NSKeyValueObservingOptions.New, context: nil)
            self.playerViewController!.player = AVPlayer(playerItem: playerItem)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: Internals

    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<()>) {
        if keyPath == "presentationSize" {
            let size = (change[NSKeyValueChangeNewKey] as NSValue).CGSizeValue()
            adjustPlayerSize(size)
        }
    }

    func adjustPlayerSize(size: CGSize) {
        let playerFrame = playerViewController!.view.frame
        let aspectRatio = size.height / size.width
        let adjustedPlayerFrame = CGRect(
            x: playerFrame.origin.x,
            y: playerFrame.origin.y,
            width: playerFrame.width,
            height: playerFrame.width * aspectRatio)
        playerViewController!.view.frame = adjustedPlayerFrame
    }

}
