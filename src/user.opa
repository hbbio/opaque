package opaque.user
import widgets.loginbox

// User types and user database
type User.user   = { passwd: string }
type User.status = { loggedin: string } / { notloggedin }
type User.info   = UserContext.t(User.status)

db /users : stringmap(User.user)

User = {{

  @private state = UserContext.make({ notloggedin } : User.status)

  /* Get the current user status 'logged in, or not' */
  get_status() = UserContext.execute((a -> a), state)

  /* Main login page */
  loginpage() = Resource.html("User page",<div id=#login_box>{loginbox()}</div>)

  /* Login and login box */
  loginbox() = 
    opt = match get_status() with
            | {loggedin = _} -> Option.some(<><a onclick={_ -> logout()}>Logout</a></>)
            | _ -> Option.none
    WLoginbox.html(WLoginbox.default_config, "login_box", login, opt)

  login(username, pass) =
    user = ?/users[username]
    do match user with
      | {some = u} -> if u.passwd == Crypto.Hash.sha2(pass) then
                         UserContext.change(( _ -> { loggedin = username }), state)
      | _ -> void
    Client.reload()

  /* Logout */
  logout() =
    do UserContext.change(( _ -> { notloggedin }), state)
    Client.reload()

  // Initializes the admin user
  @server init_admin_user() =
    match ?/users["admin"] with
      | {none} -> // NOTE: remove when done
        pass = Random.string(8)
        admin : User.user = { passwd = Crypto.Hash.sha2(pass) }
        do Debug.jlog("Creating admin user, password is: '" ^ pass ^ "'")
        /users["admin"] <- admin
      | _ -> void // NOTE: remove when done
}}

// make sure we create the admin user
do User.init_admin_user()
