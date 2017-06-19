import { Component, NgModule, Input } from '@angular/core'
import { RentMeService } from './rent-me.service'
import { RentMeCookie } from './rent-me-cookie.service'
import { ActivatedRoute, Router} from '@angular/router'
import { User } from './data'
import { CityNames } from './city-names'

@Component({
  selector: 'item-preview',
  templateUrl: 'template/item-preview.component.html',
  styleUrls: ['template/app.component.css']
})

export class ItemPreviewComponent {
  @Input()
  item: any
}