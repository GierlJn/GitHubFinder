

import Foundation

extension Date{
    
    func convertMToMonthYearFormat() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        
        return dateFormatter.string(from: self)
    }
    
}



