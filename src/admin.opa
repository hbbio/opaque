package opaque.admin
import widgets.loginbox

// User types and user database
type Admin.user   = { passwd: string }
type Admin.status = { loggedin: string } / { notloggedin }
type Admin.info   = UserContext.t(Admin.status)

db /users : stringmap(Admin.user)

Admin = {{

  @private state = UserContext.make({ notloggedin } : Admin.status)

  /* Get the current user status - 'logged in, or not' */
  get_status() = UserContext.execute((a -> a), state)
  is_logged_in() =
    match get_status() with
      | {loggedin = _} -> true
      | _              -> false

  /* Main login page */
  mainpage() =
    (t, p) = if is_logged_in() then ("User page", adminpage()) else ("Login page", loginbox())
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

  adminpage() = 
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
        admin : Admin.user = { passwd = Crypto.Hash.sha2(pass) }
        do Debug.jlog("Creating admin user, password is: '" ^ pass ^ "'")
        /users["admin"] <- admin
      | _ -> void // NOTE: remove when done
}}

// make sure we create the admin user
do Admin.init_admin_user()
