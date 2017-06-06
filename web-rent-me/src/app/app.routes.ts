import { Routes, RouterModule }  from '@angular/router';
import { LoginComponent } from './login.component';
import { RentMeMain } from './rent-me-main.component';

// Route config let's you map routes to components
const routes: Routes = [
  // map '/persons' to the people list component
  {
    path: 'start',
    component: LoginComponent,
  },
  
  {
    path: 'rent',
    component: RentMeMain,
  },
  
  // map '/' to '/persons' as our default route
  {
    path: '',
    redirectTo: 'start',
    pathMatch: 'full'
  },
];

export const routing = RouterModule.forRoot(routes);