package opaque.main
import opaque.admin
import opaque.layout
import opaque.config

mainpage() = Layout.styled_page(Config.title,
  <h1>Hello world!</h1>
)

start =
  | {path = [] ... }           -> mainpage()
  | {path = ["admin" | _] ...} -> Admin.mainpage() 
  | {path = _ ...}             -> mainpage()

server = Server.of_bundle([@static_resource_directory("res")])
server = Server.simple_dispatch(start)
