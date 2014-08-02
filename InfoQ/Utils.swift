import UIKit


// MARK: Logging

func logInfo(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    let filename = file.lastPathComponent.stringByDeletingPathExtension
    println("[INFO ] \(filename):\(line) \(function) \(message)")
}

func logError(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    let filename = file.lastPathComponent.stringByDeletingPathExtension
    println("[ERROR] \(filename):\(line) \(function) \(message)")
}


// MARK: Date

func dateFromISO8601String(date: NSString) -> NSDate {
    let iso8601DateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.dateFormat = iso8601DateFormat
    return dateFormatter.dateFromString(date)
}

func localizedStringFromDate(date: NSDate?) -> String {
    let locale = NSLocale.currentLocale()
    let dateFormat = NSDateFormatter.dateFormatFromTemplate("MMM d yyyy", options: 0, locale: locale)
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    dateFormatter.locale = locale
    return dateFormatter.stringFromDate(date)
}


// MARK: Dispatch

class async {
    class func bg(block: dispatch_block_t) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
    }

    class func main(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}


// MARK: Color

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


// MARK: Array

extension Array {
    var last: T? {
    return isEmpty ? nil : self[endIndex - 1]
    }
}


// MARK: Descriptions

extension CGRect {
    var description: String { return "\(self.origin.x),\(self.origin.y): \(self.width)x\(self.height)" }
}

extension CGSize {
    var description: String { return "\(self.width)x\(self.height)" }
}
