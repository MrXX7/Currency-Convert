I developed this simple iOS application to convert Euro amounts to other currencies for use in my job. 

Development process of the application.

1. Needs Analysis 
 - Identify the need for a currency converter application for your business. - 

2. Create SwiftUI Project
 - Create a new SwiftUI project using Xcode.

3. Define State Variables
 - Define state variables to hold user input, selected currency index, custom exchange rate, dark mode status, and exchange rate data.

4. Integrate Alamofire Library 
 - Integrate the Alamofire library into the project for network requests.

5. Use ExchangeRate-API
 - Use the ExchangeRate-API to fetch current exchange rates based on the selected currency.

6. UI Design 
 - Design the user interface using SwiftUI components (TextField, Picker, Button, etc.).
 
7. Dark Mode Support
 - Implement the feature to switch between light and dark mode.

8. Implement Conversion Logic
 - Apply the logic to convert the entered Euro amount using the selected exchange rate.

9. Fetch Exchange Rates on Page Load
 - Use `onAppear` to fetch exchange rates when the page view loads.

10. Process API Response
 - Create the `ExchangeRatesResponse` model to handle the response from the ExchangeRate-API.

11. Display Integrated Information on Page View
 - Show information such as exchange rates and converted amounts to users.
