import { Component } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { RentMeCookie } from './rent-me-cookie.service'
import { FormBuilder, Validators, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router} from '@angular/router';
import { User } from './data'

@Component({
  selector: 'main',
  templateUrl: 'template/rent-me-main.component.html',
  styleUrls: ['template/login.component.css']
})

export class RentMeMain {
  user: User

  constructor(private rentMeService: RentMeService, private rentMeCookie: RentMeCookie, private router: Router) {
    this.user = this.rentMeCookie.get_user()
    
    if(this.user == undefined){
      this.user = <User>{name: "not logged in"}
    }
  }

}