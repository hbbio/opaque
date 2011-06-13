package opaque.user
import widgets.loginbox

// User types and user database
type User.user   = { passwd: string }
type User.status = { loggedin: string } / { notloggedin }
type User.info   = UserContext.t(User.status)

db /users : stringmap(User.user)

User = {{

  @private state = UserContext.make({ notloggedin } : User.status)

  /* Get the current user status - 'logged in, or not' */
  get_status() = UserContext.execute((a -> a), state)
  is_logged_in() =
    match get_status() with
      | {loggedin = _} -> true
      | _              -> false

  /* Main login page */
  mainpage() =
    (t, p) = if is_logged_in() then ("User page", userpage()) else ("Login page", loginbox())
    Resource.html(t, p)

  /* Login box and login check */
  loginbox() = 
    <div id=#login_box>{WLoginbox.html(WLoginbox.default_config, "login_box", login, Option.none)}</div>
  login(username, pass) =
    do match ?/users[username] with
      | {some = u} -> if u.passwd == Crypto.Hash.sha2(pass) then
                         UserContext.change(( _ -> { loggedin = username }), state)
      | _ -> void
    Client.reload()

  userpage() = 
    <h3><a onclick={_ -> logout()}>Logout</a></h3>

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
