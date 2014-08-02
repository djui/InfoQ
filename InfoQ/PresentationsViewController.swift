import UIKit

class PresentationsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var presentations = Array<Presentation>()
    var isLoadingMore = false
    lazy var api: APIController = APIController()
    
    
    // MARK: UIViewDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(PresentationsTableViewCell.self, forCellReuseIdentifier: "PresentationCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

        adjustEmptySourceView()
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: UITableViewDelegate

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    func contentSizeCategoryChanged(notification: NSNotification) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return presentations.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("PresentationCell", forIndexPath: indexPath) as PresentationsTableViewCell
        let presentation = presentations[indexPath.row]

        //cell.titleTextLabel.numberOfLines = 0
        cell.titleTextLabel.lineBreakMode = .ByTruncatingTail
        cell.titleTextLabel.text = presentation.title
        cell.descriptionTextLabel.text = presentation.authorsFormatted
        cell.dateTextLabel.textAlignment = .Right
        cell.dateTextLabel.text = presentation.onlineDateFormatted

        cell.posterImageView.image = UIImage(named: "BlankImage")
        ImageLoader.sharedLoader.imageForUrl(presentation.poster!) { image in
            if image {
                cell.posterImageView.image = image
            }
        }

        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let presentationViewController = PresentationViewController(presentations[indexPath.row])
        navigationController.pushViewController(presentationViewController, animated: true)
    }


    // MARK: UIScrollViewDelegate

    override func scrollViewDidScroll(scrollView: UIScrollView!) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if bottomEdge >= scrollView.contentSize.height {
            fetchData()
        }
    }


    // MARK: -

    func fetchData() {
        if !isLoadingMore {
            isLoadingMore = true
            api.fetchPresentations(presentations.last?.id, updateDataSource)
        }
    }

    func updateDataSource(data: Array<Presentation>) {
        isLoadingMore = false

        if data.isEmpty {
            return
        }

        async.main {
//            let oldCount = self.presentations.count
            self.presentations += data
//            let diff = self.toArray(oldCount..<self.presentations.count)
//            logInfo(diff.debugDescription)
//            self.tableView.reloadRowsAtIndexPaths(diff, withRowAnimation: UITableViewRowAnimation.None)
            self.tableView.reloadData()
            self.adjustEmptySourceView()
        }
    }

    func adjustEmptySourceView() {
        let NAVIGATIONBAR_HEIGHT = 98

        if presentations.count > 0 {
            tableView.tableFooterView = nil
        } else {
            // A little trick for removing the cell separators
            let frame = CGRectMake(
                CGRectGetMinX(view.bounds),
                CGRectGetMinY(view.bounds),
                CGRectGetWidth(view.bounds),
                CGRectGetHeight(view.bounds) - NAVIGATIONBAR_HEIGHT)
            tableView.tableFooterView = EmptyDatasetView(frame: frame)
        }
    }

//    func toArray<S : Sequence>(seq: S) -> Array<S.GeneratorType.Element> {
//        return Array<S.GeneratorType.Element>(seq)
//    }

}


class PresentationsTableViewCell: UITableViewCell {

    var titleTextLabel: UILabel
    var descriptionTextLabel: UILabel
    var dateTextLabel: UILabel
    var posterImageView: UIImageView

    init(style: UITableViewCellStyle, reuseIdentifier: String!) {

        posterImageView = UIImageView()
        posterImageView.frame = CGRectMake(10, 5, 53, 39)

        titleTextLabel = UILabel()
        titleTextLabel.textColor = UIColor.blackColor()
        //titleTextLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.03)
        titleTextLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        titleTextLabel.frame = CGRectMake(68, 5, 247, 20)

        descriptionTextLabel = UILabel()
        descriptionTextLabel.textColor = UIColor.darkGrayColor()
        //descriptionTextLabel.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.03)
        descriptionTextLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        descriptionTextLabel.frame = CGRectMake(68, 25, 152, 19)

        dateTextLabel = UILabel()
        dateTextLabel.textColor = UIColor.darkGrayColor()
        //dateTextLabel.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.03)
        dateTextLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        dateTextLabel.frame = CGRectMake(220, 25, 95, 19)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleTextLabel)
        contentView.addSubview(descriptionTextLabel)
        contentView.addSubview(dateTextLabel)
        contentView.addSubview(posterImageView)


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
