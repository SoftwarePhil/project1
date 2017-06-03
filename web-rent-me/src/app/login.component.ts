import { Component } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { Router }  from '@angular/router';
import { FormBuilder, Validators } from '@angular/forms';
import { User } from './data'

@Component({
  selector: 'login',
  templateUrl: 'template/login.component.html',
  styleUrls: ['template/login.component.css']
})
export class LoginComponent {
   title = 'RentMe';
   newUser: boolean = false; 

   constructor(public fb: FormBuilder, private rentMeService: RentMeService, private router: Router) {}

   public loginForm = this.fb.group({
    email: ["", Validators.required],
    password: ["", Validators.required]
  });

  do_login(){
    let email = this.loginForm.value.email
    let password = this.loginForm.value.password

    //make a 'cookie service to save session'
    this.rentMeService.request({email, password}, "user/login")
    .subscribe(
      r => console.log(<User>r),
      error => console.log("bad login")
    )
  }

  new_user(){
    this.newUser = true
  }
}
