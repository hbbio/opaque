package opaque.user

// User types and user database
type User.user = { passwd: string }
db /users : stringmap(User.user)

User = {{
  // Initializes the admin user
  @server init_admin_user() =
    match ?/users["admin"] with
      | _ /* {none} */ -> // NOTE: remove when done
        pass = Random.string(8)
        admin : User.user = { passwd = Crypto.Hash.sha2(pass) }
        do Debug.jlog("Creating admin user, password is: '" ^ pass ^ "'")
        /users["admin"] <- admin
      // | _ -> void // NOTE: remove when done
}}

// make sure we create the admin user
do User.init_admin_user()
