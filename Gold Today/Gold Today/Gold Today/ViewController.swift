import UIKit

class ViewController: UIViewController {
    
    var types: [String] = ["Gold","Silver",  "Bitcoin"]
    var CurrencyType : String = ""

    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var StHeader: UIStackView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _Load();
        
    }

    func _Load()
    {
        CurrencyType = "XAU"
        fetchGoldPrice()
    }
    
    
    
    @IBAction func stOnclick(_ sender: Any) {
        
        switch (sender.self as AnyObject).selectedSegmentIndex {
        case 0:
            CurrencyType = "XAU"
        case 1:
            CurrencyType = "XAG"
        case 2:
            CurrencyType = "BTC"
        default:
            CurrencyType = "XAU"
        }
        
        fetchGoldPrice()
    }

    func fetchGoldPrice()
    {
        guard let url = URL(string: "https://api.gold-api.com/price/\(CurrencyType)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let goldInfo = try decoder.decode(GoldData.self, from: data)
                

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


