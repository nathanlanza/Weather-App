import Foundation

struct Forecast {
    
    struct DailyTemperature {
        let day: Double
        let eve: Double
        let max: Double
        let min: Double
        let morn: Double
        let night: Double
    }
    
    struct City {
        let city: String
        let country: String
        let longitude: String
        let latitude: String
    }
    
    struct Weather {
        let description: String
        let icon: String
        let id: Int
        let main: String
    }
    
    let city: City
    
    let clouds: Int
    let temperature: Int
    let dt: Int
    let humidity: Int
    let pressure: String
    let rain: String
    let windSpeed: String
    
    let dailyTemperature: DailyTemperature
    let weather: Weather
    
    static let df: DateFormatter = {
        let df = DateFormatter()
        
        df.dateStyle = .full
        df.timeStyle = .none
        
        return df
    }()
    
    var displayTemperature: String {
        let fahrenheit = Int(((dailyTemperature.day * 9/5) + 32).rounded())
        let string = String(fahrenheit) + "℉"
        return string
    }

    var displayDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let string = Forecast.df.string(from: date)
        return string
    }
    var displayHumidity: String { return String(humidity) + "%" }
    var displayDescription: String { return weather.description }
    
    
    static func fromJSON(_ json: Any) -> [Forecast] {
        
        guard let json = json as? [String:Any] else { fatalError("Something wrong with JSON") }
        
        let cityDict = json["city"] as? [String:Any]
        let latitude = cityDict?["lat"] as? String ?? ""
        let longitude = cityDict?["lon"] as? String ?? ""
        let country = cityDict?["country"] as? String ?? "None"
        let name = cityDict?["name"] as? String ?? "None"
        
        let city = City(city: name, country: country, longitude: longitude, latitude: latitude)
        
        guard let list = json["list"] as? [[String:Any]] else { return [] }
        
        let forecasts = list.map { element -> Forecast in
            let clouds = element["clouds"] as? Int ?? 0
            let temperature = element["deg"] as? Int ?? 0
            let dt = element["dt"] as? Int ?? 0
            let humidity = element["humidity"] as? Int ?? 0
            let pressure = element["pressure"] as? String ?? ""
            let rain = element["rain"] as? String ?? ""
            let speed = element["speed"] as? String ?? ""
            
            let tempDict = element["temp"] as? [String:Any]
            let day = tempDict?["day"] as? Double ?? 0
            let eve = tempDict?["eve"] as? Double ?? 0
            let max = 0.0 //Double(tempDict?["max"] ?? "0") ?? 0
            let min = 0.0 //Double(tempDict?["min"] ?? "0") ?? 0
            let morn = 0.0 //Double(tempDict?["morn"] ?? "0") ?? 0
            let night = 0.0 //Double(tempDict?["night"] ?? "0") ?? 0
            
            let dailyTemperature = DailyTemperature(day: day, eve: eve, max: max, min: min, morn: morn, night: night)
            
            let weatherDict = (element["weather"] as? [[String:Any]])?.first
            
            let desc = weatherDict?["description"] as? String ?? ""
            let icon = weatherDict?["icon"] as? String ?? ""
            let id = weatherDict?["id"] as? Int ?? 0
            let main = weatherDict?["main"] as? String ?? ""
            
            let weather = Weather(description: desc, icon: icon, id: id, main: main)
            
            let forecast = Forecast(city: city, clouds: clouds, temperature: temperature, dt: dt, humidity: humidity, pressure: pressure, rain: rain, windSpeed: speed, dailyTemperature: dailyTemperature, weather: weather)
            return forecast
        }
        
        return forecasts
    }
}
