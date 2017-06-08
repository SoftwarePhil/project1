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
import { HeaderComponent} from './header.compoenent'


import { CookieService } from 'angular2-cookie/services/cookies.service'
import { RentMeCookie } from './rent-me-cookie.service'


@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    CreateUserComponent,
    RentMeMain,
    HeaderComponent
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
