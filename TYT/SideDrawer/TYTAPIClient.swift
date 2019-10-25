import Stripe
import Firebase
import Alamofire

class TYTAPIClient: STPAPIClient, STPEphemeralKeyProvider {
    
     static let sharedClient = TYTAPIClient()
    
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    override func createToken(withCard card: STPCardParams, completion: STPTokenCompletionBlock? = nil) {
        guard let completion = completion else { return }
        
        // Generate a mock card model using the given card params
        var cardJSON: [String: Any] = [:]
        cardJSON["id"] = "\(card.hashValue)"
        cardJSON["exp_month"] = "\(card.expMonth)"
        cardJSON["exp_year"] = "\(card.expYear)"
        cardJSON["name"] = card.name
        cardJSON["address_line1"] = card.address.line1
        cardJSON["address_line2"] = card.address.line2
        cardJSON["address_state"] = card.address.state
        cardJSON["address_zip"] = card.address.postalCode
        cardJSON["address_country"] = card.address.country
        cardJSON["last4"] = card.last4()
        if let number = card.number {
            let brand = STPCardValidator.brand(forNumber: number)
            cardJSON["brand"] = STPCard.string(from: brand)
        }
        cardJSON["fingerprint"] = "\(card.hashValue)"
        cardJSON["country"] = "US"
        let tokenJSON: [String: Any] = [
            "id": "\(card.hashValue)",
            "object": "token",
            "livemode": false,
            "created": NSDate().timeIntervalSince1970,
            "used": false,
            "card": cardJSON,
            ]
        let token = STPToken.decodedObject(fromAPIResponse: tokenJSON)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion(token, nil)
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
            if let customerid = user?.customer_id
            {
                let url = self.baseURL.appendingPathComponent("createEphemeralKeys")
                print("URL: ", url)
                Alamofire.request(url, method: .post, parameters: [
                    "api_version": apiVersion,
                    "customerId": customerid
                    ])
                    .validate(statusCode: 200..<300)
                    .responseJSON { responseJSON in
                        print(responseJSON)
                        switch responseJSON.result {
                        case .success(let json):
                            completion(json as? [String: AnyObject], nil)
                        case .failure(let error):
                            completion(nil, error)
                        }
                }
        
            }
        }
    }
   
    
    
    
   
    
}
