export interface User {
    email: string 
    name: string
    city: string 
    picture: string 
    bio: string
    rating: number 
    created: string
    items: {id: string, name: string}[]
    active_rentals: string[]
    api_key: string
}


