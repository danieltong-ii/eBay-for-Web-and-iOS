//
//  ProductSearch.swift
//  ebay
//
//  Created by Daniel Tong on 11/17/23.
//

import SwiftUI
import Alamofire
import AlertToast

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    var query : String = ""
    @State var zipcodeArray : [Location]?
    var onSelect: ((String, [Location]) -> Void)  // Closure to be called with the postal code and place name

    @State private var isLoading = true
    var zipcodeManager = ZipcodeManager()
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView()
            } else {
                Text("Pincode Suggestions").font(.title).fontWeight(.heavy).padding(.top, 15)
                
                if let zipcodeArray = zipcodeArray {
                    List {
                        ForEach(zipcodeArray) { item in
                            Button(action: {
                                onSelect(item.postalCode, zipcodeArray)
                                dismiss()
                                // Action to perform when button is tapped
                                print("Postal Code \(item.postalCode) was tapped")
                            }) {
                                Text(item.postalCode) // This text is displayed as the button's label
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }.onAppear() {
            print("Inside SheetView")
            print("the query: \(query)")
            Task {
                do {
                    zipcodeArray = try await zipcodeManager.getZipcodeSuggestions(query: query)
                    print("Just recieved the array\(zipcodeArray)")
                    isLoading = false
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct ProductSearch: View {
    @State var productKey: String = ""
    @State var final_zipcode: String = ""
    @State var custom_zipcode: String = ""
    @State var ip_zipcode: String = ""
    @State private var cat_selected : String = "0"
    let categories = ["All", "Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]
    @State var used_con : Bool = false
    @State var new_con : Bool = false
    @State var unspec_con : Bool = false
    @State var pickup_shipping : Bool = false
    @State var free_shipping : Bool = false
    @State var distance: String = ""
    @State var resultsLoading: Bool = false
    @State var customLocation = false
    @State var submitted : Bool = false
    @State var ready = false
    @State private var showToast = false
    @State var showZipcodeToast = false
    @State var showingSheet = false
    @State private var timer: Timer?
    
    @State private var showAdded : Bool = false
    @State private var showRemoved : Bool = false
    @State var zipcodeArray : [Location] = []
    
    @EnvironmentObject var toastManager : WishButtonToastManager
    
    @Environment(ResultsData.self) private var resultsData

    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 6){
                Form {
                    Section {
                        HStack {
                            Text("Keyword: ")
                            TextField("Required", text: $productKey)
                        }.onAppear {
                            getZipcode()
                        }
                        HStack {
                            VStack {
                                Picker("Category", selection: $cat_selected) {
                                    Text("All").tag("0")
                                    Text("Art").tag("550")
                                    Text("Baby").tag("2984")
                                    Text("Books").tag("267")
                                    Text("Clothing, Shoes, and Accessories").tag("11450")
                                    Text("Computers/Tablets and Networking").tag("58058")
                                    Text("Health and Beauty").tag("26395")
                                    Text("Music").tag("11233")
                                    Text("Video Games and Consoles").tag("1249")
                                }.pickerStyle(.menu)
                            }
                        }.padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/).padding(.vertical, 4.0)
                        VStack(alignment: .leading) {
                            Text("Condition").padding(.bottom, 4.0)
                            HStack(alignment: .center) {
                                Spacer()
                                Toggle(isOn : $used_con) {
                                    Text("Used")
                                }.toggleStyle(iOSCheckbox())
                                Toggle(isOn : $new_con) {
                                    Text("New")
                                }.toggleStyle(iOSCheckbox())
                                Toggle(isOn : $unspec_con) {
                                    Text("Unspecified")
                                }.toggleStyle(iOSCheckbox())
                                Spacer()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Shipping").padding(.bottom, 4.0)
                            VStack {
                                HStack {
                                    Spacer()
                                    Toggle(isOn : $pickup_shipping) {
                                        Text("Pickup")
                                    }.toggleStyle(iOSCheckbox())
                                    Spacer()
                                    Toggle(isOn : $free_shipping) {
                                        Text("Free Shipping")
                                    }.toggleStyle(iOSCheckbox())
                                    Spacer()
                                }
                            }
                        }
                        HStack {
                            Text("Distance: ")
                            TextField("10", text: $distance)
                        }
                        VStack {
                            HStack {
                                Text("Custom location")
                                Spacer()
                                Toggle(isOn: $customLocation) {
                                }.onChange(of: customLocation) {
                                    final_zipcode = ""
                                }
                            }
                            if customLocation {
                            
                                HStack {
                                    Text("Zipcode: ")
                                    TextField("Required", text: $custom_zipcode)
                                        .onChange(of : custom_zipcode) {
                                            // Invalidate and nullify the existing timer
                                            timer?.invalidate()
                                            timer = nil
                                            
                                            // Start a new timer
                                            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                                // This block is called after 0.5 seconds of inactivity in typing
                                                print("User paused typing. Search zipcode: \(custom_zipcode)")
                                        
                                                    if !zipcodeArray.contains(where: { $0.postalCode == custom_zipcode}) {
                                                            self.zipcodeArray = zipcodeArray
                                                            showingSheet = true
                                                    }
                                                
                                            }
                                        }
                                }
                            }
                        }
                        HStack(alignment: .center) {
                            Spacer()
                            Button(action: {
                                if !customLocation {
                                    final_zipcode = ip_zipcode
                                } else {
                                    if final_zipcode == "" {
                                        final_zipcode = custom_zipcode
                                    }
                                }
                                let searchParams = loadSearchParams()
                                let handler = APIFetchHandler(mainSearchParams: searchParams)
                                resultsLoading = true
                                if productKey == "" {
                                    showToast = true
                                    submitted = false
                                } else {
                                    if final_zipcode == "" {
                                        showZipcodeToast = true
                                        submitted = false
                                    } else {
                                        submitted = true
                                    }
                                }
                                Task {
                                    
                                    do {
                                        try await handler.mainSearch()
                                        
                                        DispatchQueue.main.async {
                                            ready = ResultsData.sharedInstance.ready
                                            print("results data is ready: \(ready)")
                                            if ready {
                                                resultsLoading = false
                                            }
                                        }
                                    } catch {
                                        print("error: \(error)")
                                    }
                                    
                                }
                            }) {
                                Text("Submit")
                                    .padding(EdgeInsets(top: 10, leading: 22, bottom: 10, trailing: 22)) // Apply padding to the Text view inside the Button
                            }
                            .buttonStyle(.borderedProminent)

                            Spacer()
                          
                            Button(action: resetAll) {
                                Text("Clear")
                                    .padding(EdgeInsets(top: 10, leading: 22, bottom: 10, trailing: 22))
                            }
                            .buttonStyle(.borderedProminent)

                            Spacer()
                        }
                    }
                    if submitted {
                        Section {
                            Text("Results")
                                .fontWeight(.bold)
                                .font(.title)
                                .padding(.vertical, 5.0)
                            if resultsLoading { // implement ready, but we need a source of truth
                                VStack {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                        Spacer()
                                    }
                                    Text("Please wait...")
                                        .foregroundColor(Color.gray)
                                }
                            } else {
                                if let itemsArray = resultsData.results?.findItemsAdvancedResponse[0].searchResult[0].item {
                                    ForEach(itemsArray) { item in
                                        NavigationLink(destination: DetailedView(item : item)) {
                                            ProductRow(item: item)
                                        }
                                    }
                                } else {
                                    Text("No results found.")
                                        .foregroundColor(Color.red)
                                }
                            }
                        }
                    }
                }.navigationTitle("Product search")
                    .toolbar {
                        NavigationLink(destination: Favorites()) {
                            Label("Favorites", systemImage: "heart.circle")
                        }
                    }
            }.toast(isPresented: $toastManager.showAdded) {
                Text("Added to favorites")
                    .foregroundColor(Color.white)
            }.toast(isPresented: $toastManager.showRemoved) {
                Text("Removed from favorites")
                    .foregroundColor(Color.white)
            }.toast(isPresented: $showToast) {
                Text("Keyword is mandatory")
                    .foregroundColor(Color.white)
            }
            .toast(isPresented: $showZipcodeToast) {
                Text("Zipcode is mandatory")
                    .foregroundColor(Color.white)
            }
            .sheet(isPresented: $showingSheet) {
                SheetView(query : custom_zipcode) { selectedCode, array in
                    custom_zipcode = selectedCode
                    final_zipcode = selectedCode
                    zipcodeArray = array
                    }
                }
            }
        }
    
    func onSubmit() {
        if !customLocation {
            final_zipcode = ip_zipcode
        }
        let searchParams = loadSearchParams()
        let handler = APIFetchHandler(mainSearchParams : searchParams)
        resultsLoading = true
        if productKey == "" {
            showToast = true
            submitted = false
        } else {
            if final_zipcode == "" {
                showZipcodeToast = true
                submitted = false
            } else {
                submitted = true
            }
        }
        Task {
            
            do {
                try await handler.mainSearch()
                
                DispatchQueue.main.async {
                    ready = ResultsData.sharedInstance.ready
                    print("results data is ready: \(ready)")
                    if ready {
                        resultsLoading = false
                    }
                }
            } catch {
                print("error: \(error)")
            }
            
        }
    }

    func getZipcode() {
        let url = "https://ipinfo.io/json?token=96c70a10c71627"
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let postal = json["postal"] as? String {
                    DispatchQueue.main.async {
                        self.ip_zipcode = postal
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func resetAll() {
        productKey = ""
        final_zipcode = ""
        cat_selected = "0"
        used_con = false
        new_con = false
        unspec_con = false
        pickup_shipping = false
        resultsLoading = false
        free_shipping = false
        distance = ""
        customLocation = false
        submitted = false
        showToast = false
        showZipcodeToast = false
        custom_zipcode = ""
    }
    
    func loadSearchParams() -> ProductSearchParams {
        var used : Int = 0
        var new : Int = 0
        var local_pickup : Int = 0
        var free_ship : Int = 0
        var dist : Int = 10
        
        if used_con {
            used = 1
        }
        if new_con {
            new = 1
        }
        if unspec_con {
            used = 0
            new = 0
        }
        if pickup_shipping {
            local_pickup = 1
        }
        if free_shipping {
            free_ship = 1
        }
        if distance != "" {
            if let convertedDistance = Int(distance) {
                dist = convertedDistance
            }
        }
        if cat_selected == "0" {
            cat_selected = ""
        }
        let searchParams = ProductSearchParams(
            keywords: productKey,
            buyerPostalCode: final_zipcode,
            categoryId: cat_selected,
            condition_new: new,
            condition_used: used,
            LocalPickupOnly: local_pickup,
            FreeShippingOnly: free_ship,
            MaxDistance: dist)
        return searchParams
    }
    
    struct iOSCheckbox : ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                Image(systemName: configuration.isOn ?  "checkmark.square.fill" : "square")
                    .onTapGesture{
                        configuration.isOn.toggle()
                    }
                    .foregroundColor(configuration.isOn ? .blue : .gray)

                configuration.label
            }
        }
    }
    
}
