## Project: eBay for Web and iOS

### Overview

This project showcases an iOS application developed as part of an academic assignment to deepen familiarity with Swift, Xcode, and iOS app development. The application allows users to search for products using the eBay API, view detailed product information, manage a wishlist, and share products on Facebook.

### Features

- **Search Functionality**: Users can search for products by keywords, categories, condition, and shipping options. There's also an option to specify the search radius from a custom location or use the current location.
- **Product Details**: Each product can be tapped to view detailed information across four tabs: Product Info, Shipping Info, Google Photos, and Similar Products.
- **Wishlist**: Users can add products to a wishlist, which is accessible via a heart-shaped icon. Products can be added or removed with a simple tap.
- **Social Sharing**: Products can be shared on Facebook directly from the product details page.

### Technologies Used

- **Swift and SwiftUI**: The app is built using Swift, leveraging SwiftUI for a more declarative and intuitive way to build the UI.
- **Xcode**: Developed in Xcode 15.0.1, making use of its integrated development environment features like the SwiftUI designer, simulators, and debugging tools.
- **SF Symbols**: Utilized for icons throughout the app, ensuring a consistent and native look and feel.
- **MongoDB**: Used to store and manage wishlist data.
- **Alamofire and Kingfisher**: These libraries were used for handling network requests and image rendering, respectively.

### Development Setup

- The app was developed on macOS Sonoma (14), using the latest stable release of Xcode available from the Mac App Store.
- SF Symbols 4 was installed to ensure access to all necessary icons.
- Libraries like Alamofire for HTTP requests and Kingfisher for image rendering were included via Swift Package Manager.

### Challenges and Solutions

- **API Integration**: Integrating the eBay API required careful handling of authentication and network responses. OAuth tokens were managed using a custom Node.js backend.
- **UI Consistency**: Ensuring the UI looked good across various devices and orientations was achieved by extensive testing with Xcode’s device simulators.
- **Data Management**: MongoDB was used for the wishlist feature, requiring careful setup and integration to ensure data integrity and performance.

### Conclusion

This iOS application serves as a comprehensive solution for searching and managing eBay product information. It demonstrates a robust use of modern iOS development tools and technologies, emphasizing clean architecture, efficient data handling, and a user-friendly interface.
