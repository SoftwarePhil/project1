import { CookieService } from 'angular2-cookie/services/cookies.service'
import { Injectable }     from '@angular/core';
import { User } from './data'

@Injectable()
export class RentMeCookie{
    private user: User
    private key: string = "rent-me-cookie-523"

    constructor(private cookieService: CookieService){}

    set_user(user: User){
        this.user = user
        this.cookieService.putObject(this.key, user)
        console.log("user saved " + user.email)
    }

    get_user(): User{
        if(this.user == undefined){
            console.log("..geting user from cookie")
            let res = this.cookieService.get(this.key)
           
            if(res == undefined){
                return undefined
            }

            else{
                this.user = <User>JSON.parse(res)
            }
        }
        return this.user
    }

    remove_user_cookie(){
        this.cookieService.removeAll()
        this.user = undefined
    }

}
