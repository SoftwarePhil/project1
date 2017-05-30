# users
##### creating a user
#
    curl -X POST -H "Content-Type: application/json" -d '
        {"email":"test@gmail.com", "password":"123456", "name":"Phil", 
        "location":"Dallas, TX", "picture":"no-picture", "bio":"I rent things"}
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