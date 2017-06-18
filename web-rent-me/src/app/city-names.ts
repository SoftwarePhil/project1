import { RentMeService } from './rent-me.service'

export class CityNames{
    city: string
    cities: string[]

    constructor(private rentMeService: RentMeService) {
        this.get_locations()
    }

    get_locations(){
        this.rentMeService.get_request("base/locations").subscribe(
        loc=>this.set_loc(loc),
        error=> this.cities = ["error getting location data"]
        )
    }

    private set_loc(loc){
        this.cities = loc
        this.city = loc[0]
    }

   selectCity() {
    var e: any = document.getElementById("loc");
    var val = e.options[e.selectedIndex].value;
    this.city = val
    console.log(val)
  }
}