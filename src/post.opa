package opaque.post
import stdlib.date
import opaque.bsl.upskirt

type Post.post = { title: string;
                   date: Date.date
                   content: string;
                   author: string; }

db /posts : intmap(Post.post)

Post = {{
  to_xhtml(p) =
    content = Upskirt.render_to_xhtml(p.content)
    <h1>{p.title}</h1>
    <p class="meta">{Date.to_string(p.date)}</p>
    <>{content}</>
}}
