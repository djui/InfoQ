import UIKit

class PresentationViewController: UIViewController, APIControllerProtocol {

    lazy var api: APIController = APIController(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: UIViewController Protocol
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: APIController Protocol
    
    func didReceiveAPIResults(results: NSArray) {}

}
