package opaque.admin
import widgets.loginbox
import opaque.layout

// User types and user database
type Admin.user   = { passwd: string }
type Admin.status = { loggedin: string } / { notloggedin }
type Admin.info   = UserContext.t(Admin.status)

db /users : stringmap(Admin.user)

Admin = {{

  @private state = UserContext.make({ notloggedin } : Admin.status)

  /* Get the current user status - 'logged in, or not' */
  get_status() = UserContext.execute((a -> a), state)
  get_status_option() =
    match get_status() with
      | {loggedin = n} -> Option.some(n)
      | _              -> Option.none
  is_logged_in()  = Option.is_some(get_status_option())
  get_logged_in() = Option.get(get_status_option())

  /* Main login page */
  mainpage() =
    (t, p) = if is_logged_in() then ("Admin page", adminpage()) else ("Login page", loginbox())
    Layout.styled_page(t, p)

  /* Login box and login check */
  loginbox() = 
    <div id=#login_box>{WLoginbox.html(WLoginbox.default_config, "login_box", login, Option.none)}</div>
  login(username, pass) =
    do match ?/users[username] with
      | {some = u} -> if u.passwd == Crypto.Hash.sha2(pass) then
                         UserContext.change(( _ -> { loggedin = username }), state)
      | _ -> void
    Client.reload()


  /* Main administrative page */
  adminpage() = 
    <h3><a onclick={_ -> changepw()}>Change password</a></h3>
    <h3><a onclick={_ -> logout()}>Logout</a></h3>

  /* Changing passwords */
  changepw() =
    update_db(p) =
      username = get_logged_in()
      do /users[username] <- { passwd = Crypto.Hash.sha2(p) }
      do Client.reload()
      do Debug.jlog("Updated password for user '" ^ username ^ "'")
      Layout.transform_content(mainpage())
    update_form =
      <h3>New password:</h3><br />
      <input id=#newpasswd /><br />
      <button type="button" onclick={_ -> update_db(Dom.get_value(#newpasswd))}>Submit</button>
    Layout.transform_content(update_form)

  /* Logout */
  logout() =
    do UserContext.change(( _ -> { notloggedin }), state)
    Client.reload()


  /* Initializes the admin user */
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
