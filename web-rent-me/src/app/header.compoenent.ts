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
    constructor(private rentMeCookie: RentMeCookie, private router: Router ){}
    
    logout(){
        this.rentMeCookie.remove_user_cookie()
        this.router.navigate(['/start'])
    }
}