import { Component } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { Router } from '@angular/router';
import { FormBuilder, Validators } from '@angular/forms';
import { User } from './data'
import { RentMeCookie } from './rent-me-cookie.service'

@Component({
    selector: 'header-component',
    templateUrl: 'template/header.component.html',
    styleUrls: ['template/app.component.css']
})
export class HeaderComponent {
    show_profile: boolean = false
    login: boolean = true
    login_btn: boolean = false

    constructor(private rentMeCookie: RentMeCookie, private router: Router) {
        if (this.rentMeCookie.get_user() == undefined) {
            this.login = false
        }
    }

    logout() {
        this.rentMeCookie.remove_user_cookie()
        this.login = false
        this.router.navigate(['/app'])
    }

    show_profile_btn() {
        if (this.show_profile == false) {
            this.show_profile = true
        }
        else {
            this.show_profile = false
        }
    }


    show_login_btn() {
        console.log(this.login_btn)
        if (this.login_btn == false) {
            this.login_btn = true
        }
        else {
            this.login_btn = false
        }
    }
}