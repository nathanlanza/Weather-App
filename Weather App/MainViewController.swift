import UIKit

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Daily Forecast for Winter Park"
        
    }
    
    var forecasts: [Forecast] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WeatherModel.main.getTenDayForecast { forecasts, error in
            if let error = error {
                print(error) //TODO - Handle this properly
            }
            
            guard let forecasts = forecasts else { return }
            
            DispatchQueue.main.async {
                self.forecasts = forecasts
            }
        }
    }
    
    
}


//Navigation
extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detail = segue.destination as? DetailViewController else { fatalError("This should always successfully return a DetailViewController") }
        guard let cell = sender as? ForecastCell else { fatalError("This should always be a forecastcell") }
        guard let index = tableView.indexPath(for: cell) else { fatalError("This should always be a cell in the tableview and thus a valid index") }
        
        let forecast = forecasts[index.row]
        detail.title = "Forecast for " + forecast.city.city
        detail.forecast = forecast
        
        
    }
    
}


//UITableViewDataSource
extension MainViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ForecastCell else { fatalError("This should always return a ForecastCell") }
        
        let forecast = forecasts[indexPath.row]
        
        cell.config(for: forecast)
        
        return cell
    }
    
}



