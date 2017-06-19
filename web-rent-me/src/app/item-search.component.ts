import { Component, NgModule } from '@angular/core'
import { RentMeService } from './rent-me.service'
import { RentMeCookie } from './rent-me-cookie.service'
import { ActivatedRoute, Router} from '@angular/router'
import { User } from './data'
import { CityNames } from './city-names'

@Component({
  selector: 'item-search',
  templateUrl: 'template/item-search.component.html',
  styleUrls: ['template/app.component.css']
})

export class ItemSeachComponent {
  results: any[]
  current: any
  term: string
  error: string
  cn: CityNames

  constructor(private rentMeService: RentMeService,) {
      this.cn = new CityNames(rentMeService)
  }

  search(){
    this.error = undefined
    let city = this.cn.city
    let term = this.term
    console.log({city, term})
    if(city != undefined && term != undefined ){
        this.rentMeService.request({city, search: this.term}, "base/search")
        .subscribe(ok=>this.results = ok, error=>console.log("search error"))
    }
    else{
        this.error = "please select a city and enter an item yo search for"
    }
  }

  item_click(item: any){
    console.log(item)
    this.current = item
  }

}