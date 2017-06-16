import { Component } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { Router }  from '@angular/router';
import { FormBuilder, Validators } from '@angular/forms';
import { User } from './data'
import { RentMeCookie } from './rent-me-cookie.service'

@Component({
  selector: 'header-component',
  templateUrl: 'template/header.component.html',
  styleUrls: ['template/login.component.css']
})
export class HeaderComponent {
    show_profile: boolean = false

    constructor(private rentMeCookie: RentMeCookie, private router: Router ){}
    
    logout(){
        this.rentMeCookie.remove_user_cookie()
        this.router.navigate(['/start'])
    }

    show_profile_btn(){
        if(this.show_profile == false){
            this.show_profile = true
        }
        else{
            this.show_profile = false
        }
    }
}