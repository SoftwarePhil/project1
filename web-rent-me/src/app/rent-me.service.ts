
import { Observable } from 'rxjs/Rx';
import { User } from './data';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { Injectable }     from '@angular/core';

// Import RxJs required methods
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

@Injectable()
export class RentMeService{
    base_url: string = "localhost:4000/"
    url: string = "http://"+this.base_url+"api/"

    constructor (private http: Http){}

    request(object: any, path: string) :Observable<any> {
        let body = JSON.stringify(object)

        return this.http.post(this.url + path, 
            body, {headers: this.header()})
            .map(data => data.json())
    }

    header(): Headers {
        let headers = new Headers()
        headers.append('Content-Type', 'application/json')

        return headers
    }

    get_request(path) :Observable<any>{
        return this.http.get(this.url + path).map(data => data.json())
    }
}