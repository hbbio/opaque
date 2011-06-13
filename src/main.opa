package opaque.main
import stdlib.map
import stdlib.date

import opaque.admin
import opaque.layout
import opaque.config
import opaque.post

mainpage() = 
  toListItem(v) = <li><span>{Date.to_string(v.date)}</span> - {v.title}</li>
  Layout.styled_page(Config.title,
  <h1>Blog Posts</h1>
  <ul class="posts">
    {Xml.list_to_xml(toListItem, Post.posts_to_list())}
  </ul>

  <h1>A section of things you want to list, like interviews</h1>
  <ul class="posts">
    <li><span>21 Dec 2012</span> - <a href="http://google.com">A link!</a></li>
  </ul>

  <h1>Another one, like your papers or open source projects</h1>
  <ul class="posts">
    <li><a href="http://github.com">blah:</a> my foobar project.</li>
  </ul>
 )

start =
  | {path = [] ... }           -> mainpage()
  | {path = ["admin" | _] ...} -> Admin.mainpage() 
  | {path = _ ...}             -> mainpage()

server = Server.of_bundle([@static_resource_directory("res")])
server = Server.simple_dispatch(start)
