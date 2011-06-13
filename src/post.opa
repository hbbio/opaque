package opaque.post
import stdlib.date
import stdlib.map

import opaque.bsl.upskirt

type Post.post = { title: string;
                   date: Date.date
                   content: string;
                   author: string; }

db /posts : intmap(Post.post)

@server Post = {{

  insert_new_post(p) = /posts[?] <- p
  update_post(i,p)   = /posts[i] <- p
  get_posts() = /posts
  get_post(i) = ?/posts[i]

  posts_to_list() =
    List.rev(Map_make(Int.order).To.val_list(get_posts()))

  to_xhtml(p) =
    content = Upskirt.render_to_xhtml(p.content)
    <h1>{p.title}</h1>
    <p class="meta">{Date.to_string(p.date)}, by {p.author}</p>
    <>{content}</>
}}
