import { Routes, RouterModule }  from '@angular/router';
import { LoginComponent } from './login.component';


// Route config let's you map routes to components
const routes: Routes = [
  // map '/persons' to the people list component
  {
    path: 'start',
    component: LoginComponent,
  },
  
  // map '/' to '/persons' as our default route
  {
    path: '',
    redirectTo: 'start',
    pathMatch: 'full'
  },
];

export const routing = RouterModule.forRoot(routes);