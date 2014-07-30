import UIKit

class PresentationsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol {

    var presentations = [Presentation]()
    var imageCache = [String: UIImage]()
    lazy var api: APIController = APIController(delegate: self)
    
    
    // MARK: UIViewController Protocol
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(PresentationsTableViewCell.self, forCellReuseIdentifier: "PresentationCell")

        // A little trick for removing the cell separators
        let frame = CGRectMake(CGRectGetMinX(view.bounds), CGRectGetMinY(view.bounds), CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) - 98)
        tableView.tableFooterView = EmptyDatasetView(frame: frame)
        api.fetchPresentations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UITableViewController Protocol
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return presentations.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("PresentationCell", forIndexPath: indexPath) as UITableViewCell
        let presentation = presentations[indexPath.row]
        let poster = imageCache[presentation.posterUrl.absoluteString]

        cell.textLabel.text = presentation.title

        // BUG: Not sure if this is a SWIFT bug or I am doing something wrong
        //cell.detailTextLabel.text = (presentation.authors.count > 2 ? ", " : " & ").join(presentation.authors)
        switch presentation.authors.count {
            case 1: cell.detailTextLabel.text = presentation.authors[0]
            case 2: cell.detailTextLabel.text = "\(presentation.authors[0]) & \(presentation.authors[1])"
            default: cell.detailTextLabel.text = ", ".join(presentation.authors)
        }
        
        if poster? {
            cell.imageView.image = poster
        } else {
            cell.imageView.image = UIImage(named: "BlankImage")
            ImageLoader.sharedLoader.imageForUrl(presentation.poster) { image in
                if image {
                    cell.imageView.image = image
                }
            }
        }
    
        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let presentation = presentations[indexPath.row]
        // UIAlertView(title: presentation.onlineDateFormatted, message: presentation.summary, delegate: nil, cancelButtonTitle: "OK").show()
        let presentationViewController = PresentationViewController()
        self.navigationController.pushViewController(presentationViewController, animated: true)
    }
    
    
    // MARK: APIController Protocol

    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.presentations = results as [Presentation]
            self.tableView.reloadData()
        })
    }

}

class PresentationsTableViewCell: UITableViewCell {

    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
    }

}

class EmptyDatasetView: UIView {

    init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    }

    override func drawRect(rect: CGRect) {
        let label = UILabel()
        label.textColor = UIColor.grayColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = "No presentations loaded."
        label.sizeToFit()
        label.center = center
        addSubview(label)
    }

}
