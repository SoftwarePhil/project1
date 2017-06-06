import { Component } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { FormBuilder, Validators, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router} from '@angular/router';

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

  constructor(public fb: FormBuilder, private rentMeService: RentMeService, private router: Router) {
    this.get_locations()
    this.createUser = fb.group({
      name: '',
      email: '',
      password: ''
    })
  }


  newUser(event: any){
    if(this.location != null && this.createUser.status == "VALID"){
      this.error = null
      console.log("ok valid user")
      let email = this.createUser.value.email
      let password = this.createUser.value.password
      let name = this.createUser.value.name

      let user = {name, password, email, location:this.location}
     

      this.rentMeService.request(user, "user/new").subscribe(
        res=>this.router.navigate(['/']),
        error => this.error = "failed to create user, server resonded with error " + error._body
      )

      
    }
    else{
      this.error = "Invlaid! All fields required"
    }
  }

  seeVal() {
    var e: any = document.getElementById("loc");
    var val = e.options[e.selectedIndex].value;
    this.location = val
    console.log(val)
  }

  get_locations(){
    this.rentMeService.get_request("base/locations").subscribe(
      loc=>this.set_loc(loc),
      error=> this.choices = ["error getting location data"]
    )
  }

  private set_loc(loc){
    this.choices = loc
    this.location = loc[0]
  }

}