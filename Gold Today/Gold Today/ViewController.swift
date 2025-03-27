import UIKit

class ViewController: UIViewController {
    
    var types: [String] = ["Gold","Silver",  "Bitcoin"]
    
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var StHeader: UIStackView!

    
    var CurrencyType : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrencyType = "XAU"
        
        fetchGoldPrice()
        
    }

    @IBAction func stOnclick(_ sender: Any) {
        
        switch (sender.self as AnyObject).selectedSegmentIndex {
               case 0:
                   CurrencyType = "XAU"  // Gold
               case 1:
                   CurrencyType = "XAG"  // Silver
               case 2:
                   CurrencyType = "BTC"  // Bitcoin
               default:
                   CurrencyType = ""
               }

               // Fetch the price for the selected currency
               fetchGoldPrice()
    }
    // Picker view methods
   

    // Function to fetch price from the API
    func fetchGoldPrice() {
        guard let url = URL(string: "https://api.gold-api.com/price/\(CurrencyType)") else {
            print("Invalid URL")
            return
        }
        
        // Create a URL session task to fetch data
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            // Ensure data is not nil
            guard let data = data else {
                print("No data returned.")
                return
            }
            
            // Decode the JSON data into a struct (GoldData)
            do {
                let decoder = JSONDecoder()
                let goldInfo = try decoder.decode(GoldData.self, from: data)
                
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.lblName.text = goldInfo.name
                    self.lblSymbol.text = goldInfo.symbol
                    self.lblPrice.text = "\(goldInfo.price) $"
                    self.lblDate.text = goldInfo.updatedAt
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
}


