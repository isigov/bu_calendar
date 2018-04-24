//
//  ViewController.swift
//  FollowerCheck
//
//  Created by Illya Sigov on 7/14/16.
//  Copyright © 2016 Illya Sigov. All rights reserved.
//

import UIKit
import Foundation
import EventKit
import GoogleAPIClientForREST
import GoogleSignIn

class ViewController: UIViewController, UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var appleCal: UISwitch!
    @IBOutlet weak var googleCal: UISwitch!
    @IBOutlet weak var statusInd: UIActivityIndicatorView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var webview: UIWebView!
    var user: String = ""
    var pass: String = ""
    var counter: Int32 = 0
    var auth = false
    
    let cellIdentifier = "CellIdentifier"

    var classes: [String] = []
    var class_times: [String] = []
    var class_loc: [String] = []
    
    var urlArray = [String]()
    
    private let scopes = [kGTLRAuthScopeCalendar]
    
    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    let output = UITextView()

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            
        }
    }
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doLogin(userN: user, passW: pass)
        // Configure Google Sign-in.
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().scopes = scopes
//        GIDSignIn.sharedInstance().signInSilently()
//
//        // Add the sign-in button.
//        view.addSubview(signInButton)
//
//        // Add a UITextView to display output.
//        output.frame = view.bounds
//        output.isEditable = false
//        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
//        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        output.isHidden = true
//        view.addSubview(output);
        //NavBar.hidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let fruit = classes[indexPath.row]
        cell.textLabel?.text = fruit
        return cell
    }
    func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        //mergedComponments.timeZone = TimeZone(abbreviation: "EST")
        return calendar.date(from: mergedComponments)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        if(cell.accessoryType == UITableViewCellAccessoryType.none){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        
    }
    
    func doLogin(userN: String, passW: String)
    {
        statusLbl.isHidden = false
        statusInd.startAnimating()
        let url = URL (string: "https://www.bu.edu/link/bin/uiscgi_studentlink.pl/1468612320?ModuleName=allsched.pl")
        let requestObj = URLRequest(url: url!)
        self.webview.delegate = self
        self.webview.loadRequest(requestObj)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if(!auth)
//        {
//            auth = true
//
//            let storage = HTTPCookieStorage.shared
//            for cookie in storage.cookies! {
//                storage.deleteCookie(cookie)
//            }
//
//            let alertController = UIAlertController(title: "User", message: "Enter your BU Username/Password", preferredStyle: .alert)
//
//            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
//                let field = alertController.textFields![0] as UITextField
//                self.user = field.text!
//                let field2 = alertController.textFields![1] as UITextField
//                self.pass = field2.text!
//
//                let url = URL (string: "https://www.bu.edu/link/bin/uiscgi_studentlink.pl/1468612320?ModuleName=allsched.pl")
//                let requestObj = URLRequest(url: url!)
//                self.webview.delegate = self
//                self.webview.loadRequest(requestObj)
//            }
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//
//            alertController.addTextField { (textField) in
//                textField.placeholder = "Username"
//            }
//            alertController.addTextField { (textField2) in
//                textField2.placeholder = "Password"
//                textField2.isSecureTextEntry = true
//            }
//
//            alertController.addAction(confirmAction)
//            alertController.addAction(cancelAction)
//
//            self.present(alertController, animated: true, completion: nil)
//
//        }
    }


    @IBAction func googleValChanged(_ sender: Any) {
        if(googleCal.isOn){
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().scopes = scopes
            GIDSignIn.sharedInstance().signIn()
        }
        
    }
    @IBAction func addCal(_ sender: Any) {
        for cell in self.table.visibleCells as! Array<UITableViewCell>{
            if(cell.accessoryType == UITableViewCellAccessoryType.checkmark)
            {
                let index: Int = (self.table.indexPath(for: cell)?.row)!
                let className = self.classes[index]
                let classDays = self.class_times[index].components(separatedBy: " ")[0]
                let classTimesBegin = self.class_times[index].components(separatedBy: " - ")[0].replacingOccurrences(of: classDays, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                let classTimesEnd = self.class_times[index].components(separatedBy: " - ")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let classLoc = self.class_loc[index]
                
                var daysofweek: [EKRecurrenceDayOfWeek] = []
                var gcaldays = ""
                
                if classDays.range(of:  "Mon") != nil {
                    daysofweek.append(EKRecurrenceDayOfWeek(.monday))
                    gcaldays += "MO,"
                }
                if classDays.range(of:  "Tue") != nil {
                    daysofweek.append(EKRecurrenceDayOfWeek(.tuesday))
                    gcaldays += "TU,"
                }
                if classDays.range(of:  "Wed") != nil {
                    daysofweek.append(EKRecurrenceDayOfWeek(.wednesday))
                    gcaldays += "WE,"
                }
                if classDays.range(of:  "Thu") != nil {
                    daysofweek.append(EKRecurrenceDayOfWeek(.thursday))
                    gcaldays += "TH,"
                }
                if classDays.range(of:  "Fri") != nil {
                    daysofweek.append(EKRecurrenceDayOfWeek(.friday))
                    gcaldays += "FR,"
                }
                gcaldays = String(gcaldays.characters.dropLast(1))
                debugPrint(gcaldays)
                let startDate = Calendar.current.startOfDay(for: Date())
                let store = EKEventStore()
                var dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mma"
                timeFormatter.timeZone = NSTimeZone.local
                var start = timeFormatter.date(from: classTimesBegin)
                var end = timeFormatter.date(from: classTimesEnd)
                start = combineDateWithTime(date: startDate, time: start!)
                end = combineDateWithTime(date: startDate, time: end!)
                

                if(appleCal.isOn){
                    store.requestAccess(to: .event) {(granted, error) in
                        if !granted {
                                return
                            }
                        let event = EKEvent(eventStore: store)
                        event.isAllDay = false
                        event.title = className
                        event.startDate = start
                        event.endDate = end
                        event.location = classLoc
                        event.calendar = store.defaultCalendarForNewEvents
                        let ekrules: EKRecurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: daysofweek, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
                        event.recurrenceRules = [ekrules]
                        do {
                            try store.save(event, span: .thisEvent, commit: true)
                        }
                        catch {
                        }
                    }

                }
                if(googleCal.isOn){
                    let newEvent: GTLRCalendar_Event = GTLRCalendar_Event()
                    
                    newEvent.summary = (className)
                    newEvent.location = (classLoc)
                    
                    let startDateTime: GTLRDateTime = GTLRDateTime(date: start!)
                    let startEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
                    startEventDateTime.dateTime = startDateTime
                    debugPrint(NSTimeZone.local.identifier)
                    startEventDateTime.timeZone = NSTimeZone.local.identifier
                    newEvent.start = startEventDateTime
                    
                    let endDateTime: GTLRDateTime = GTLRDateTime(date: end!)
                    let endEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
                    endEventDateTime.dateTime = endDateTime
                    endEventDateTime.timeZone = NSTimeZone.local.identifier
                    newEvent.end = endEventDateTime
                    debugPrint(newEvent.start, newEvent.end)
                    newEvent.recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=" + gcaldays]
                    debugPrint(newEvent.recurrence)
                    let service: GTLRCalendarService = GTLRCalendarService()
                    let query =
                        GTLRCalendarQuery_EventsInsert.query(withObject: newEvent, calendarId: "primary")
                    self.service.executeQuery(query, completionHandler: {(callbackTicket:GTLRServiceTicket,event:GTLRCalendar_Event,callbackError: Error?) -> Void in} as? GTLRServiceCompletionHandler)
                }
            }
        }
        classes.removeAll()
        class_loc.removeAll()
        class_times.removeAll()
        self.table.reloadData()
        appleCal.isOn = false
        googleCal.isOn = false
        showAlert(title: "Success!", message: "Successfully added specified classes to calendar.")
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {

        let text = webView.request?.url?.absoluteString
        
        if urlArray.count > 0
        {
            urlArray.remove(at: 0)
            let doc:String = self.webview.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")!
            var classSplit = doc.components(separatedBy: "<h3>")
            var rangeSplit = classSplit[1].components(separatedBy: "</h3>")
            let className: String = rangeSplit[0]

            classSplit = doc.components(separatedBy: "<p class=\"bu-mobile-bold-text ui-li-desc\">")
            rangeSplit = classSplit[1].components(separatedBy: "</p>")
            
            let classTime: String = rangeSplit[0]
            let classLoc: String = rangeSplit[1].components(separatedBy: "<p class=\"ui-li-desc\">")[1] + rangeSplit[2].components(separatedBy: "<p class=\"ui-li-desc\">")[1] + ", " + rangeSplit[3].components(separatedBy: "<p class=\"ui-li-desc\">")[1]
            classes.append(className)
            class_times.append(classTime)
            class_loc.append(classLoc)
            table.beginUpdates()
            table.insertRows(at: [IndexPath(row: classes.count-1, section: 0)], with: .automatic)
            table.endUpdates()
            
            if urlArray.count > 0 {
                let requestObj = URLRequest(url: URL(string: urlArray[0])!);
                self.webview.loadRequest(requestObj)
            }
            else{
                statusInd.stopAnimating()
                statusLbl.isHidden = true
            }
        }
        else if text?.range(of:"SAML2") != nil
        {
            let doc:String = self.webview.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")!
            if(doc.range(of: "entered") != nil){
                return
            }
            self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('ui-link')[5].click()")
            self.webview.stringByEvaluatingJavaScript(from: "canCopyData = 1;")
            self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByName('pw')[0].value = '" + self.pass + "';")
            self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('input-text')[0].value='" + self.user + "';")
            self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('input-text')[1].value='" + self.pass + "';")
            self.webview.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('button')[0].click();")
        }
        else if text?.range(of: "mobile/schedule/class") != nil
        {
            
            let doc:String = self.webview.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")!
            let classSplit = doc.components(separatedBy: "<a href=\"")
            
            for var i in 3 ..< classSplit.count {
                var rangeSplit = classSplit[i].components(separatedBy: "\">")[0].components(separatedBy: "\"")
                let urlinfo: String = rangeSplit[0].replacingOccurrences(of: "amp;", with: "")
                urlArray.append(urlinfo)

            }

            let url = URL (string: String(urlArray[0]))
            let requestObj = URLRequest(url: url!);
            self.webview.loadRequest(requestObj)
            
        }
        else if text?.range(of: "uiscgi_studentlink.pl") != nil
        {
            let url = URL (string: "https://www.bu.edu/link/bin/uiscgi_studentlink.pl?ModuleName=mobile/schedule/class/_start.pl");
            let requestObj = URLRequest(url: url!);
            self.webview.loadRequest(requestObj)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

