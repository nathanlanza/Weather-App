import Foundation

protocol WeatherModel {
    func getDailyForecast(completion: @escaping ([Forecast]?,Error?) -> Void)
}

class OpenWeatherMapModel: WeatherModel {
    static let main = OpenWeatherMapModel()
    private let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?q=Winter%20Park,FL&mode=json&units=metric&cnt=14&appid=f8fdae74c29544baebdb927d392c5538"
    private init() { }
    
    func getDailyForecast(completion: @escaping ([Forecast]?,Error?) -> Void) {
        guard let url = URL(string: urlString) else { fatalError("Check urlString") }
        let session = URLSession.shared
        
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard error == nil else { completion(nil,error); return }
            
            var forecasts: [Forecast]?
            var jsonError: Error?
            
            do {
                if let data = data {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    forecasts = Forecast.fromJSON(json)
                }
            } catch let newError {
                jsonError = newError
            }
            completion(forecasts,jsonError)
            
        }).resume()
    }
}

