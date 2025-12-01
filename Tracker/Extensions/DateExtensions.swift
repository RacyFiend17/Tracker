import UIKit

extension Date {
    var weekday: Weekday? {
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: self)
        let corrected = weekdayNumber == 1 ? 7 : weekdayNumber - 1
        return Weekday(rawValue: corrected)
    }
}
