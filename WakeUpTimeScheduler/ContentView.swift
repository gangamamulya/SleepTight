//
//  ContentView.swift
//  WakeUpTimeScheduler
//
//  Created by Amulya Gangam on 5/21/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.mint.opacity(0.2).ignoresSafeArea()
           
                VStack {
                    
                    Form {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("When do you want to wakeup?")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                DatePicker("Please enter time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .padding(.vertical, 10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text("Desired sleep Amount?")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                                .padding(.vertical, 10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("How many cups of coffee did you drink?")
                                .font(.headline)
                                .foregroundColor(.primary)
                            //                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount.formatted()) cups", value: $coffeeAmount, in: 1...20)
                            Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                                .padding(.vertical, 10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        .alert(alertTitle, isPresented: $showingAlert) {
                            Button("Ok") {}
                        } message: {
                            Text(alertMessage)
                        }
                    }
                    .tint(.mint.opacity(3))
                    .scrollContentBackground(.hidden)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
    
                                Text("Sleep well")
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                                Image(systemName: "powersleep")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.mint.opacity(3))
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                            .padding(.top, 16)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: SleepWell) {
                        Text("Calculate")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mint.opacity(3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    
                }
                .padding()
            }
        }
        
    }
    
    func SleepWell() {
        do {
            //
            let config = MLModelConfiguration()
            
            //reads in all our data and makes predictions for us
            let model = try SleepCalculator(configuration: config)
            
            //time at which user wants to wake up in seconds
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute  = (components.minute ?? 0) * 60
            
            //prediction by the model which says total amount of sleep the user will actually get
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            //at what time user should sleep - determined by subtracting what time user should wakeup and the predicted number of sleep hours user should sleep.
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            //we can avoid the datem we just need time
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }
        catch {
            alertTitle = "Error"
            alertMessage = "Sorry there was a problem in predicting your bedtime"
        }
        showingAlert = true
    }
}


#Preview {
    ContentView()
}
