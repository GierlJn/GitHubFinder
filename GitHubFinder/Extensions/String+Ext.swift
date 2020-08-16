
import Foundation

extension String{
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en-de")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    func convertToMonthYearDisplayFormat() -> String{
        guard let date = self.convertToDate() else { return "NA"}
        return date.convertMToMonthYearFormat()
    }
}
