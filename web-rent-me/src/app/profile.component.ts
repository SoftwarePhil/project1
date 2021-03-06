import { Component, NgModule } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { RentMeCookie } from './rent-me-cookie.service'
import { FormBuilder, Validators, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router} from '@angular/router';
import { User } from './data'

@Component({
  selector: 'profile',
  templateUrl: 'template/profile.component.html',
  styleUrls: ['template/app.component.css']
})

export class ProfileComponent {
  user: User

  constructor(private rentMeService: RentMeService, private rentMeCookie: RentMeCookie, private router: Router) {
    this.user = this.rentMeCookie.get_user()
    
    if(this.user == undefined){
      this.user = <User>{name: "not logged in"}
    }
  }

  api_key_test(){
    this.rentMeService.auth_request({test: "hello"}, "user/key_test",this.user.email, this.user.api_key)
    .subscribe(ok=> console.log(ok), error=>console.log({error: error}))
  }

  edit_bio(){
    this.rentMeService.auth_request({bio: this.user.bio}, "user/bio", this.user.email, this.user.api_key)
    .subscribe(ok=> console.log(this.rentMeCookie.set_user(this.user)), error=>console.log({error: error}))
  }

}