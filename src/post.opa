package opaque.post
import stdlib.date
import stdlib.map

import opaque.layout

import opaque.bsl.upskirt
import opaque.bsl.shjs

type Post.post = { title: string;
                   date: Date.date
                   content: string;
                   author: string; }

db /posts : intmap(Post.post)

@server Post = {{

  /* Utility functions, mostly */
  insert_new_post(p) = /posts[?] <- p
  update_post(i,p)   = /posts[i] <- p
  get_posts() = /posts
  get_post(i) = ?/posts[i]
  posts_to_list() =
    List.rev(Map_make(Int.order).To.assoc_list(get_posts()))

  postpage(x) = 
    match Parser.int(x) with
      | {none}     -> Layout.styled_page("Invalid URL",<h1>Invalid URL</h1>)
      | {some = i} -> render_page(i)

  render_page(i) = 
    match get_post(i) with
      | {none}     -> Layout.styled_page("Invalid post number",<h1>Invalid post number</h1>)
      | {some = p} -> Layout.styled_page(p.title, to_xhtml(p))

  to_xhtml(p) =
    content = Upskirt.render_to_xhtml(p.content)
    <div id=#post onready={_ -> SHJS.highlight()}>
      <h1>{p.title}</h1>
      <p class="meta">{Date.to_string(p.date)}, by {p.author}</p>
      <>{content}</>
    </div>
}}
