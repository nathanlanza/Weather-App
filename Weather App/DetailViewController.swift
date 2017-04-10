import UIKit

class DetailViewController: UIViewController {
    var forecast: Forecast?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let forecast = forecast else { fatalError("Should always have a forecast") }
        
        temperatureLabel.text = forecast.displayTemperature
        descriptionLabel.text = forecast.displayDescription
        humidityLabel.text = forecast.displayHumidity
        dateLabel.text = forecast.displayDate
    }
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}
