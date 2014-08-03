import UIKit
import MediaPlayer

class PresentationViewController: UIViewController {

    var presentation: Presentation?
    var moviePlayer: MPMoviePlayerController?
    lazy var api: APIController = APIController()

    
    convenience init(_ presentation: Presentation) {
        self.init()
        self.presentation = presentation
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let DIM_WIDTH = 320
        let MARGIN = 10
        let WIDTH = DIM_WIDTH - 2*MARGIN

        let title = UILabel()
        title.frame = CGRect(x: MARGIN, y: 1 * MARGIN + 0, width: WIDTH, height: 100)
        title.numberOfLines = 0
        title.textAlignment = .Center
        title.font = .boldSystemFontOfSize(22)
        title.backgroundColor = .whiteColor()
        title.text = presentation!.title

        let author = UILabel()
        author.frame = CGRect(x: MARGIN, y: 2 * MARGIN + 100, width: WIDTH, height: 20)
        author.numberOfLines = 1
        author.textAlignment = .Center
        author.backgroundColor = .whiteColor()
        author.text = "by \(presentation!.authorsFormatted!)"

        let summary = UILabel()
        summary.frame = CGRect(x: MARGIN, y: 3 * MARGIN + 100+20, width: WIDTH, height: 150)
        summary.numberOfLines = 0
        summary.textAlignment = .Center
        summary.backgroundColor = .whiteColor()
        summary.text = presentation!.summary

        moviePlayer = MPMoviePlayerController()
        moviePlayer!.view.frame = CGRect(x: MARGIN, y: 4 * MARGIN + 100+20+150, width: WIDTH, height: 150)
        moviePlayer!.movieSourceType = MPMovieSourceType.Unknown
        moviePlayer!.controlStyle = MPMovieControlStyle.Embedded

        api.fetchPresentation(presentation!.id!) { presentation in
            logInfo("Preparing \(presentation.videoUrl!.description)")
            self.moviePlayer!.movieSourceType = MPMovieSourceType.Unknown
            self.moviePlayer!.contentURL = presentation.videoUrl
            self.moviePlayer!.prepareToPlay()
            self.moviePlayer!.play()
            println(self.moviePlayer!.contentURL)
            println(self.moviePlayer!.errorLog)
            println(self.moviePlayer!.accessLog)
            logInfo("Playing \(presentation.videoUrl!.description)")
        }

        let scrollView = UIScrollView(frame: view.frame)
        scrollView.addSubview(title)
        scrollView.addSubview(author)
        scrollView.addSubview(summary)
        scrollView.addSubview(moviePlayer!.view)

        // Calculate content size based on last/latest subview offset
        let lastSubView = scrollView.subviews.last as UIView
        let bottomOffset = lastSubView.frame.origin.y + lastSubView.frame.size.height
        scrollView.contentSize = CGSize(width: CGFloat(DIM_WIDTH), height: bottomOffset)

        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(scrollView)
    }


    // MARK: UIViewController Protocol
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
