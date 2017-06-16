import { Component, NgModule } from '@angular/core';
import { RentMeService } from './rent-me.service'
import { RentMeCookie } from './rent-me-cookie.service'
import { FormBuilder, Validators, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router} from '@angular/router';
import { User } from './data'

@Component({
  selector: 'add-item',
  templateUrl: 'template/add-item.component.html',
  styleUrls: ['template/login.component.css']
})

export class AddItem {
  user: User

  //item creation
  name: string
  location: string = "temp"
  price: string
  tags_input: string = ""
  tags: string[] = []
  description: string
  picture: string = "no-picture"

  errors: string[]

  constructor(private rentMeService: RentMeService, private rentMeCookie: RentMeCookie) {
      this.user = this.rentMeCookie.get_user()
   }

   save_item(){
     let item = {
                 name: this.name, location: 
                 this.location, price: parseFloat(this.price), 
                 tags: this.tags, 
                 description: this.description, 
                 picture: this.picture
                }
     
     if(this.all_inputs_valid(item)){
        console.log(item)

        this.rentMeService.auth_request(item, "rental/add", this.user.email, this.user.api_key)
        .subscribe(ok=>this.add_item_to_user(ok), error=>console.log(error))
     }
   }

   add_item_to_user(res: any){
    let temp: string = res.ok
    let item = temp.split(":")
    let item_arr = {id: temp, name: item[2]}
    
    this.user.items.push(item_arr)
    //this.rentMeCookie.set_user(this.user)
    console.log(res)
   }

   create_tags(){
     console.log({0:this.tags_input, 1:this.tags_input.charAt(this.tags_input.length - 1)})
    if(this.tags_input.charAt(this.tags_input.length - 1) == " "){
      let tag = this.tags_input.trim()
      
      if(tag != ""){
        this.tags.push(tag)
        this.tags_input = ""
      }
    }
      console.log(this.tags)
   }

   all_inputs_valid(item: any): boolean{
     this.errors = []
     let valid = true

     if(item.name == undefined){
       this.errors.push("invalid name")
       valid = false
     }
     if(item.location == undefined){
       this.errors.push("undefined location")
       valid = false
     }
     if(item.price == undefined || isNaN(item.price)){
       this.errors.push("price must be a number")
       valid = false
    }
    if(item.tags.length < 1){
       this.errors.push("please enter atleast 1 tag")
       valid = false
    }
    if(item.description == undefined){
       this.errors.push("please enter a description")
       valid = false
     }
    if(item.picture == undefined){
       this.errors.push("please add a picture")
       valid = false
     }
     
     return valid
   }

   delete_tag(tag: string){
    let i = this.tags.indexOf(tag)
    if (i > -1) {
      this.tags.splice(i, 1);
    }
   }
}
