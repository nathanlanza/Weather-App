import UIKit


class ForecastCell: UITableViewCell {
    
    func config(for forecast: Forecast) {
        dateLabel.text = forecast.displayDate
        temperatureLabel.text = forecast.displayTemperature
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
}
