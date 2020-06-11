//
//  LoginViewController.swift
//  MovieInfo
//
//  Created by tekwill on 6/10/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let movieService: MovieService = MovieStore.shared
    private var token: String = ""
    private var sessionId: String = ""
    private var username: String = ""
    private var name: String = ""
    private var page: Int = 0
    private var id: Int = 0
    var Dictionary = [Int: String]()


    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
       let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Type Username"
        field.leftView = UIView(frame: CGRect(x: 0,y: 0,width: 5,height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
         field.autocapitalizationType = .none
         field.autocorrectionType = .no
         field.returnKeyType = .done
         field.layer.cornerRadius = 12
         field.layer.borderWidth = 1
         field.layer.borderColor = UIColor.lightGray.cgColor
         field.placeholder = "Type Password"
         field.leftView = UIView(frame: CGRect(x: 0,y: 0,width: 5,height: 0))
         field.leftViewMode = .always
         field.backgroundColor = .white
        field.isSecureTextEntry = true
         return field
     }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loginButton: UIButton = {
       let button = UIButton()
        button.setTitle("Log in", for: .normal)
        if #available(iOS 13.0, *) {
            button.backgroundColor = .link
        } else {
            button.backgroundColor = .blue
        }
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        view.backgroundColor = .white
        
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.frame.size.width/3
        imageView.frame = CGRect(x: (scrollView.frame.size.width-size)/2,y: 20, width: size,height: size)
        emailField.frame = CGRect(x: 30,y: imageView.bottom+10, width: scrollView.width-60,height: 52)
        passwordField.frame = CGRect(x: 30,y: emailField.bottom+10, width: scrollView.width-60,height: 52)
        loginButton.frame = CGRect(x: 30,y: passwordField.bottom+10, width: scrollView.width-60,height: 52)
    }
    
    @objc private func  loginButtonTapped(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text,
            !email.isEmpty, !password.isEmpty, password.count >= 8 else {
                alertUserLoginError()
                return
        }
        //login
        movieService.requestToken( params: nil, successHandler: {[unowned self] (response) in
            
            self.token = response.requestToken
            print(response.requestToken)
            self.movieService.login(requestToken: self.token,username: self.emailField.text!,password: self.passwordField.text!,params: nil, successHandler: {[unowned self] (response) in
                self.token = response.requestToken
                print(response.requestToken)
                self.movieService.getSessionId(requestToken: self.token,params: nil, successHandler: {[unowned self] (response) in
                    self.sessionId = response.sessionId
                    print(response.sessionId)
                    self.movieService.getUserDetails(sessionId: self.sessionId,params: nil, successHandler: {[unowned self] (response) in
                        self.username = response.username
                        self.name = response.name
                        self.id = response.id
                        print(response.username)
                        print(response.name)
                        NotificationCenter.default.post(name: Notification.Name("username"), object: self.username)
                        NotificationCenter.default.post(name: Notification.Name("userid"), object: self.id)
                        NotificationCenter.default.post(name: Notification.Name("sessionid"), object: self.sessionId)
                        self.Dictionary[1] = self.sessionId
                        self.Dictionary[2] = String(self.id)
                        self.performSegue(withIdentifier: "account", sender: self.Dictionary)
                        
                        
                    }) { [unowned self] (error) in
                        print("error in receiving userid")
                    }
                    
                }) { [unowned self] (error) in
                    print("error in receiving session_id")
                }
                
            }) { [unowned self] (error) in
                print("error in receiving authentication")
                self.alertUserLoginError()
            }
            

        }) { [unowned self] (error) in
            print("error in receiving token")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! AccountViewController
        let myInt = Int(self.Dictionary[2]!) ?? 0
        vc.userid = myInt
        vc.sessionId = self.Dictionary[1]!
        
        }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Error",
                                      message: "Please enter correct information to log in",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
