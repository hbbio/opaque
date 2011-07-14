package opaque.main
import stdlib.core.map
import stdlib.core.date

import opaque.admin
import opaque.layout
import opaque.config
import opaque.post

mainpage() = 
  toBlogPostItem((i, v)) =
    <li><span>{Date.to_string(v.date)}</span> - <a href="/post/{Int.to_string(i)}">{v.title}</a></li>
  toSectionItem(x)  = <li>{x}</li>
  toSection((t, v)) = 
    <h1>{t}</h1>
    <ul class="posts">
      {Xml.list_to_xml(toSectionItem, v)}
    </ul>
  Layout.styled_page(Config.title,
    <h1>Blog Posts</h1>
    <ul class="posts">
      {Xml.list_to_xml(toBlogPostItem, Post.posts_to_list())}
    </ul>
    <>{Xml.list_to_xml(toSection, Config.sections)}</>
 )

start =
  | {path = [] ... }             -> mainpage()
  | {path = ["admin" | _] ...}   -> Admin.mainpage()
  | {path = ["post", x | _] ...} -> Post.postpage(x)
  | {path = _ ...}               -> mainpage()

server = Server.of_bundle([@static_resource_directory("res")])
server = Server.simple_dispatch(start)
