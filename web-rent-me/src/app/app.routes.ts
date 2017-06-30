import { Routes, RouterModule }  from '@angular/router';
import { RentMeMain } from './rent-me-main.component';
import { ProfileComponent } from './profile.component';
import { ItemSeachComponent } from './item-search.component'
import { StartPageComponent } from "./start-page.component";

// Route config let's you map routes to components
const routes: Routes = [
  // map '/persons' to the people list component
 
  {
    path: 'rent',
    component: RentMeMain,
  },

  {
    path: 'profile',
    component: ProfileComponent,
  },
   {
    path: 'app',
    component: StartPageComponent,
  },
  
  
  // map '/' to '/persons' as our default route
  {
    path: '',
    redirectTo: 'app',
    pathMatch: 'full'
  },
];

export const routing = RouterModule.forRoot(routes);