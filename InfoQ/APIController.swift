import UIKit

class APIController {
    
    func fetchPresentations(since: NSString?, completionHandler: (Array<Presentation>) -> Void) {
        var endpoint = "http://infoqcast.herokuapp.com/api/v1/presentations" + (since ? "?since=\(since!)" : "")
        logInfo(endpoint)
        get(endpoint) { jsonResult in
            let data = self.parseJSONArray(jsonResult)
            if data.error {
                logError(data.error!.description)
                return
            }
            let result = data.result!.map { Presentation($0) }
            completionHandler(result)
        }
    }

    func fetchPresentation(id: String, completionHandler: (Presentation) -> Void) {
        var endpoint = "http://infoqcast.herokuapp.com/api/v1\(id)"
        logInfo(endpoint)
        get(endpoint) { jsonResult in
            let data = self.parseJSONObject(jsonResult)
            if data.error {
                logError(data.error!.description)
                return
            }
            let result = Presentation(data.result)
            completionHandler(result)
        }
    }

    func get(endpoint: String, completionHandler: (NSData) -> Void) {
        let url = NSURL(string: endpoint)
        NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            if error {
                logError(error.localizedDescription)
                return
            }

            if data.length == 0 {
                logError("Empty response")
                return
            }

            completionHandler(data)
        }.resume()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func parseJSONArray(data: NSData) -> (error: NSError?, result: Array<NSDictionary>?) {
        var error: NSError?
        let result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as Array<NSDictionary>
        return (error, result)
    }

    func parseJSONObject(data: NSData) -> (error: NSError?, result: NSDictionary?) {
        var error: NSError?
        let result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return (error, result)
    }
}
