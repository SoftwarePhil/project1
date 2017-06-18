import { BrowserModule } from '@angular/platform-browser'
import { NgModule } from '@angular/core'
import { FormsModule, ReactiveFormsModule } from '@angular/forms'
import { HttpModule } from '@angular/http'
import { routing } from './app.routes'

import { AppComponent } from './app.component'
import { LoginComponent } from './login.component'
import { RentMeService } from './rent-me.service'
import { CreateUserComponent } from './create-user.component'
import { RentMeMain } from './rent-me-main.component'
import { HeaderComponent} from './header.component'
import { AddItem } from './add-item.component'
import { ProfileComponent } from './profile.component'
import { ItemSeachComponent } from "./item-search.component"

import { CookieService } from 'angular2-cookie/services/cookies.service'
import { RentMeCookie } from './rent-me-cookie.service'


@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    CreateUserComponent,
    RentMeMain,
    HeaderComponent,
    AddItem,
    ProfileComponent,
    ItemSeachComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpModule,
    routing
  ],
  providers: [ RentMeService, CookieService, RentMeCookie ],
  bootstrap: [ AppComponent ]
})
export class AppModule { }
