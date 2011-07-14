package opaque.config

Config = {{
  author   = "John Doe"
  email    = "joe@blog.me"
  blurb    = "Super radical dude"
  title    = "John Doe's epic blog"

  links    = [ ("http://google.com", "google.com")
             , ("http://opalang.org", "opalang.org") ]

  sections = [ ("A section of things you want to list, like interviews",
                 [ <><span>21 Dec 2012</span> - <a href="http://google.com">A link!</a></> ])
             , ("Another one, like your papers or open source projects",
                 [ <><a href="http://github.com">blah:</a> my foobar project.</> ])
             ]
}}
