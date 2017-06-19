import { Component } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { FormBuilder, Validators, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router} from '@angular/router';
import { CityNames } from './city-names'

@Component({
  selector: 'create-user',
  templateUrl: 'template/create-user.component.html',
  styleUrls: ['template/login.component.css']
})

export class CreateUserComponent {
  choices: string[]
  location: string
  email: string
  password: string
  name: string
  createUser: FormGroup
  error: string
  cn: CityNames

  constructor(public fb: FormBuilder, private rentMeService: RentMeService, private router: Router) {
    this.cn = new CityNames(rentMeService)
    this.createUser = fb.group({
      name: '',
      email: '',
      password: ''
    })
  }


  newUser(event: any){
    if(this.cn.city != null && this.createUser.status == "VALID"){
      this.error = null
      console.log("ok valid user")
      let email = this.createUser.value.email
      let password = this.createUser.value.password
      let name = this.createUser.value.name

      let user = {name, password, email, city:this.cn.city}
     

      this.rentMeService.request(user, "user/new").subscribe(
        res=>window.location.reload(),
        error => this.error = "failed to create user, server resonded with error " + error._body
      )

      
    }
    else{
      this.error = "Invlaid! All fields required"
    }
  }

}