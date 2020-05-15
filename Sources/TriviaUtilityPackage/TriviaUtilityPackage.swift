/*
 File name: TriviaUtilityPackage.swift
 
 Author: Kevin Bodie
 
 Purpose: Set of utility functions to make a call to an external url that supplies REST request response for obtaining trivia questions. This is a public API that runs without authentication and has no cost of use.       
 
 May 2020
 
 */

import Foundation

public class TriviaUtilityPackage
{
    static public let shared = TriviaUtilityPackage()
       
    var isRequestPending = false
    
    // These variables are for the local storage of the trivia question and answer
    var triviaQuestion = String()
    var triviaAnswer = String()
    
    // These variables will hold the trivia questions and answers
    var triviaQuestions = [String]()
    var triviaAnswers = [String]()

    private init() { }

    public func makeAPIRequest()
    {
        print("It's a really crazy miracle inside TriviaUtilityPackage.makeAPIRequest.......")
        
        if isRequestPending {
            return
        }

        isRequestPending = true

        // Make the API HTTPS request...
    }

    public func onReturnAPIRequest()
    {
        print("It's a miracle inside TriviaUtilityPackage.onReturnAPIRequest.......")
        
        isRequestPending = false

        // Do something with request data...
    }
    
    public func generateTriviaFunction(count:Int) {
        
        // Make call to API to get a trivia question via REST call.
        // The API below takes a number that signifiies the number of questions to request.
        var todoEndpoint: String = "https://opentdb.com/api.php?amount="
        todoEndpoint += String(count)
        
          guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
          }
          let urlRequest = URLRequest(url: url)

          // set up the session
          let config = URLSessionConfiguration.default
          let session = URLSession(configuration: config)

          // make the request
          let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            print("URL call returned - Starting to execute the completion handler code insider generateTriviaFunction(count:Int)")
            // Below is the completion handler code
            // check for any errors
            guard error == nil else {
              print("error calling GET on /todos/1")
              print(error!)
              return
            }
            // make sure we got data
            guard let responseData = data else {
              print("Error: did not receive data")
              return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
              guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                as? [String: Any] else {
                  print("error trying to convert data to JSON")
                  return
              }
                
                //KWB start of MKB code
                let todoResults = todo["results"]
                
                let JSON = todoResults as! NSArray
                
                var i = Int()
                i = 0
                while(i < count)
                {
                    let firstResult = JSON[i]
                    let firstResultDict = firstResult as! NSDictionary
                    var keyValueCount = 1
                
                    print("We are now going to print out the name value pairs for JSON[" + String(i) + "]")
                    for (key, value) in firstResultDict {
                        print(keyValueCount)
                        print("The key is '\(key)' and the value is '\(value)'.")
                        var updateText = key as! String
                    
                        if("\(key)" == "question")
                        {
                            /* Remove the code below as it does not need to run in the main thread since it is in a completion handler April 28, 2020 KWB.
                            DispatchQueue.main.async {
                                self.triviaQuestion = "\(value)"
                            } */
                            self.triviaQuestions.append("\(value)")
                        }
                        if("\(key)" == "correct_answer")
                        {
                            /* Remove the code below as it does not need to run in the main thread since it is in a completion handler April 28, 2020 KWB.
                            DispatchQueue.main.async {
                                self.triviaAnswer = "\(value)"
                            } */
                            self.triviaAnswers.append("\(value)")
                        }
                        keyValueCount += 1
                    
                    }
                
                    print("triviaQuestion:" + self.triviaQuestion + " triviaAnswer:" + self.triviaAnswer)
                    i += 1
                }
           
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
          }
          task.resume()
        
        return
    }
    
    // If the user calls for an index greater than the number of elements (Questions) in the array, return a null string
    public func getTriviaQuestion(index:Int) -> String{
        print("Inside TriviaUtilityPackage.shared.getTriviaQuestion:", triviaQuestion)
        if(index >= triviaQuestions.count){
            return("")
        }
        return (triviaQuestions[index])
    }

    // If the user calls for an index greater than the number of elements (Answers) in the array, return a null string
    public func getTriviaAnswer(index:Int) -> String{
        if(index >= triviaAnswers.count){
            return("")
        }
        return (triviaAnswers[index])
    }
    
    /* Utility function to return the number of trivia functions currently stored in the array */
    public func getNumTriviaQuestions() -> Int{
        return (triviaAnswers.count)
    }
    
    public func clearTriviaQuestions() {
        triviaQuestions.removeAll()
        triviaAnswers.removeAll()
        
        print("Questions Cleared")
        print("Array size = ", triviaAnswers.count)
    }
    
    
    /* Utility function to filter the Trivia questions from the storage array. After they are filtered they will need to replaced with valid questions. Have to figure this one out. This is to get rid of the multiple choice questions or the questions that are True/False */
    public func filterTriviaQuestions(){
        
        /* Add code below to look at the Data in the array and decide to keep the entry or remove. Note, question and answers MUST be removed concurrently otherwise the questions and answers will be out of sync.*/
        
        var i = Int()
        var count = Int()
        
        i = 0
        count = triviaQuestions.count
        while(i < count)
        {
            /* Here is where the filter code will go */
            print(triviaQuestions[i])
            print(triviaAnswers[i])
        }
        
    }
    
    
}
