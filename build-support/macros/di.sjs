macro di {
  case { _ ( function ($params:ident (,) ...) { $body ...} ) } => {
    var tokens = #{$params...}.map(function(t) { return makeValue(t.token.value, #{here}) });
    letstx $annotations... = tokens;
    return #{
      [ $annotations (,) ... , function ($params ...) {
        $body ...
      } ]
    }
  }
}

export di;