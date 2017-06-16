# users
##### creating a user
#
    curl -X POST -H "Content-Type: application/json" -d '
        {"email":"test@gmail.com", "password":"123456", "name":"Phil", 
        "location":"Dallas, TX"}
    ' "http://localhost:4000/api/user/new"

##### login in
#
    curl -X POST -H "Content-Type: application/json" -d '
        {"email":"test@test.com", "password":"1"}
    ' "http://localhost:4000/api/user/login"

##### api key
#
    curl -X POST -H "Content-Type: application/json" -d '
        {"email":"test@test.com", "password":"1"}
    ' "http://localhost:4000/api/user/key"

## Auth required
##### api key test
#
    curl -X POST -H "Content-Type: application/json" -H "authorization: dp@gmail.com-Busx0wUMf4A5jPlZHa8oGRApd6v0zxao" -d '
        {"test":"hello"}
    ' "http://localhost:4000/api/user/key_test"

#
response:

    {"hello":"dp@gmail.com"}

#

##### update bio
#
    curl -X POST -H "Content-Type: application/json" -H "authorization: dp@gmail.com-Busx0wUMf4A5jPlZHa8oGRApd6v0zxao" -d '
        {"bio":"I am a profession renter with lots of passion"}
    ' "http://localhost:4000/api/user/bio"

#
response:
    
    {"bio":"I am a profession renter with lots of passion"}

#

# Rentals
##### Add Item
#
     curl -X POST -H "Content-Type: application/json" -H "authorization: dp@gmail.com-YKTTgiczukSiNbiOXd+HN3VcTzf5h6H/" -d '
        {"name":"Nice Red Bike", "location":"some-gps-cords/location", "price":10, "tags":["bike", "two-wheels", "fast"],
         "description":"a really nice bike, rides great! Rent today!", "picture":"some-picture-doc"}
    ' "http://localhost:4000/api/rental/add"

#
response:

    {"ok":"Dallas, TX:dp@gmail.com:Nice Red Bike"}


# Base
##### locations
# 
    curl http://localhost:4000/api/base/locations

#
response:

    ["Dallas, TX", "New York, NY", ...]
#


