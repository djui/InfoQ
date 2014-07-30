import UIKit

protocol APIControllerProtocol {
    
    func didReceiveAPIResults(results: NSArray)

}

class APIController {
    
    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func fetchPresentations() {
        get("http://infoqcast.herokuapp.com/api/v1/presentations") { jsonResult in
            let result = jsonResult.map { Presentation(jsonDict: $0) }
            self.delegate.didReceiveAPIResults(result)
        }
    }

    func get(endpoint: NSString, completionHandler: ([NSDictionary]) -> Void) {
        let url = NSURL(string: endpoint)
        NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if error {
                logError(error.localizedDescription)
                return
            }
            
            var err: NSError?
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as [NSDictionary]
            if err? {
                logError(err!.localizedDescription)
                return
            }
            
            completionHandler(jsonResult)
        }.resume()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
}
