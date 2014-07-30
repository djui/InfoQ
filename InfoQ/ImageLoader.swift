import UIKit

class ImageLoader {
    
    var cache = NSCache()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler: (image: UIImage?) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            if let imageData = self.cache.objectForKey(urlString) as? NSData {
                let image = UIImage(data: imageData)
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(image: image)
                }
                return
            }
            
            let url = NSURL(string: urlString)
            NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                if error {
                    logError(error.localizedDescription)
                    completionHandler(image: nil)
                    return
                }
                
                if data {
                    let image = UIImage(data: data)
                    self.cache.setObject(data, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(image: image)
                    }
                }
            }.resume()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        })
    }
    
}
