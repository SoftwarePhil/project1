import { Component } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { FormBuilder, Validators } from '@angular/forms';

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

  constructor(public fb: FormBuilder, private rentMeService: RentMeService) {
    this.get_locations()
  }

  public createUser = this.fb.group({
    name: ["", Validators.required],
    email: ["", Validators.required],
    password: ["", Validators.required]
  });

  newUser(event: any){
    console.log(this.createUser)
    if(this.location != null){
      let email = this.createUser.value.email
      let password = this.createUser.value.password
      let name = this.createUser.value.name

      let user = {name, password, email, location:this.location}
      console.log(user)

      //new user request here

      
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
      loc=>this.choices = loc,
      error=> this.choices = ["error getting location data"]
    )
  }

}