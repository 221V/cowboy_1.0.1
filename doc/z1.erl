-module(z1).
-compile([export_all, nowarn_export_all]).


html(Title, V) ->
  [ <<"<!DOCTYPE html>\n"
    "<html>\n"
    "<head>\n"
    "<title>">>, Title, <<"</title>\n"
    "<meta charset=\"utf8\">\n"
    "<style>\n"
    "div.layout{width:800px;margin:0 auto;}\n"
    "</style>\n"
    "<link rel=\"stylesheet\" href=\"slides.css\" type=\"text/css\">\n"
    "</head>\n"
    "<body>\n"
    "<div class=\"layout\">\n">>,
    V,
    <<"</div>\n"
	"<script>SyntaxHighlighter.all();</script>\n"
	"</body>\n"
	"</html>\n">> ].


gen0() ->
  AST = ezdoc:parse_file("../0doc/src/README.ezd"),
  %io:format("~p~n", [AST]),
  %file:write_file("../0doc/man7/ezdoc.1", ezdoc_man:export(7, AST)),
  
  %file:write_file("../0doc/html/ezdoc.html", ezdoc_html:export(AST)),
  [{_, Title}|_] = AST,
  file:write_file("../0doc/html/ezdoc.html", ?MODULE:html( Title, ezdoc_html:export(AST) ) ),
  
  %file:write_file("../README.md", ezdoc_markdown:export(AST)),
  ok.
  %init:stop(). % вимикає консоль


gen1() ->
  {ok, L1} = file:list_dir("doc/src/guide"),
  ?MODULE:gen_h1(L1, "doc/src/guide/", "doc/html/guide/"),
  
  {ok, L2} = file:list_dir("doc/src/manual"),
  ?MODULE:gen_h1(L2, "doc/src/manual/", "doc/html/manual/"),
  
  %io:format("~p~n~n~p~n~n", [L1, L2]),
  ok.


gen_h1([], _, _) -> ok;
gen_h1([H|T], Path1, Path2) ->
  io:format("~p~n", [H]),
  [N,V2|_] = string:split(H, "."),
  case V2 of
    "ezdoc" ->
      AST = ezdoc:parse_file(Path1 ++ H),
      [{_, Title}|_] = AST,
      file:write_file(Path2 ++ N ++ ".html", ?MODULE:html( Title, ezdoc_html:export(AST) ) );
    _ ->
      ok
  end,
  ?MODULE:gen_h1(T, Path1, Path2).


