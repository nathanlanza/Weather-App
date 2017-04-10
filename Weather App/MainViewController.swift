import UIKit

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Daily Forecast for Winter Park"
        
    }
    
    let weatherModel: WeatherModel = OpenWeatherMapModel.main
    
    var forecasts: [Forecast] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    @IBAction func refresh(_ sender: UIRefreshControl) {
        forecasts = []
        getForecasts {
            sender.endRefreshing()
        }
    }
    
    func getForecasts(doneHandler: (() -> ())? = nil) {
        weatherModel.getDailyForecast { forecasts, error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: "There was an error:\n " + error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                    doneHandler?()
                }
            }
            
            guard let forecasts = forecasts else { return }
            
            DispatchQueue.main.async {
                self.forecasts = forecasts
                doneHandler?()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getForecasts()
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



