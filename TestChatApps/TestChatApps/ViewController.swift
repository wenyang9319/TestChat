//
//  ViewController.swift
//  TestChatApps
//
//  Created by Lee Wen Yang  on 11/25/15.
//  Copyright © 2015 Lee Wen Yang . All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tfMessage: UITextField!

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kbHeight: NSLayoutConstraint!
    var msgArray = ["Welcome to test chat server"]
    let socket = SocketIOClient(socketURL: "localhost:3000")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addHandlers()
        self.socket.connect()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addHandlers(){
        self.socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        
        self.socket.on("chat message") {data, ack in
            self.msgArray.append(data[0] as! String)
            self.tableView.reloadData()
        }
        
    }

    @IBAction func btnSendClicked(sender: AnyObject) {
        if (tfMessage.text != ""){
             self.socket.emit("chat message", tfMessage.text!)
        }
        
        tfMessage.text = ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("SimpleCell")
        
        tableViewCell?.textLabel!.text = msgArray[indexPath.row]
        
        return tableViewCell!
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("show")
        adjustingHeight(true, notification: notification)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
       adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 4
        let changeInHeight = (CGRectGetHeight(keyboardFrame) ) * (show ? 1 : -1)
        //5
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            self.kbHeight.constant += changeInHeight
        })
        
    }
    
 
    

}

