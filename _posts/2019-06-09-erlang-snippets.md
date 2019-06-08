---
title: Erlang snippets
---

Things I've found surprisng in Erlang, or which I had to repeatedly look up on
the web.

## Pattern matching in functions

You can use pattern matching inside function calls, for example:
```erlang
element(2, {ok, _} = application:get_env(myapp, myenv))
```

This is useful in macros as it removes the need to pollute scope with bounded
variables:
```erlang
% this creates bounded variable
-define(MYENV, begin
  {ok, Env} = application:get_env(myapp, myenv),
  Env
end).

% this does not
-define(MYENV, element(2, {ok, _} = application:get_env(myapp, myenv))).
```

