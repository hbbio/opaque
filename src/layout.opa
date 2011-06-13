package opaque.layout
import opaque.post
import opaque.bsl.native
import opaque.config

Layout = {{

  @private styles = [ "res/style.css"
                    , "res/sh_nedit.min.css" ]

  styled_page(t, p) = Resource.styled_page(t, styles, default_layout(p))
  post_layout(p) = 
    <div id=#post>{Post.to_xhtml(p)}</div>

  @client transform_content(s) =
    Dom.transform([#page_content <- s])

  @server default_layout(content) = 
    mem      = get_mem_usage()
    sysname  = get_sys_sysname()
    nodename = get_sys_nodename()
    release  = get_sys_release()
    machine  = get_sys_machine()

    <script type="text/javascript" src="res/sh_main.min.js"/>
    <script type="text/javascript" src="res/sh_haskell.min.js"/>
    <script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"/>
    <body>
    <div class="site">
      <div class="title">
      <a href="/">{Config.author}</a>
      <a class="extra" href="/">home</a>
    </div>
    <div id=#page_content>{content}</div>
    <div class="footer">
      <div class="contact">
        <p>
          {Config.author}<br />
          {Config.blurb}<br />
          {Config.email}
        </p>
      </div>
      <div class="contact">
        <p>
          {List.map( (l, t) -> <a href="{l}">{t}</a><br/>,Config.links)}
        </p>
      </div>

      <div class="rss">
      </div>
      <div class="info">
        <p>
           Served by '{nodename}' (a {sysname}/{machine}<br />
           machine, version {release}, using <br />
           {mem}MB of RAM.)
        </p>
      </div>
    </div>
  </div>
  </body>
}}
