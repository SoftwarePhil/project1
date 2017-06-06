import { Component } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { Router }  from '@angular/router';
import { FormBuilder, Validators } from '@angular/forms';
import { User } from './data'

@Component({
  selector: 'main-page',
  templateUrl: 'template/login.component.html',
  styleUrls: ['template/login.component.css']
})
export class MainPage {
   title = 'RentMe';
   newUser: boolean = false; 
   user: User

   constructor(public fb: FormBuilder, private rentMeService: RentMeService, private router: Router) {}

 
}
