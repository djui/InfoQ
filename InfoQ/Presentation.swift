import Foundation

class Presentation {

    let id: NSString
    let title: NSString
    let summary: NSString
    let authors: [NSString]
    let keywords: [NSString]
    let length: UInt
    let link: NSString
    let linkUrl: NSURL
    let poster: NSString
    let posterUrl: NSURL
    let onlineDate: NSDate
    let onlineDateFormatted: NSString
    let publishDate: NSDate
    let publishDateFormatted: NSString
    let recordDate: NSDate
    let recordDateFormatted: NSString

    init(jsonDict: NSDictionary) {        
        id = jsonDict["id"] as NSString
        title = jsonDict["title"] as NSString
        summary = jsonDict["summary"] as NSString
        authors = jsonDict["authors"] as [NSString]
        keywords = jsonDict["keywords"] as [NSString]
        length = jsonDict["length"] as UInt
        link = jsonDict["link"] as NSString
        poster = jsonDict["poster"] as NSString

        linkUrl = NSURL(string: link)
        posterUrl = NSURL(string: poster)
        
        onlineDate = dateFromISO8601String(jsonDict["online-date"] as NSString)
        publishDate = dateFromISO8601String(jsonDict["publish-date"] as NSString)
        recordDate = dateFromISO8601String(jsonDict["record-date"] as NSString)
        
        onlineDateFormatted = localizedStringFromDate(onlineDate)
        publishDateFormatted = localizedStringFromDate(publishDate)
        recordDateFormatted = localizedStringFromDate(recordDate)
    }

}
