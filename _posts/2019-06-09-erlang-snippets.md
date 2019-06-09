---
title: Erlang
---

# {{ page.title }}

Gotchas, things I've found surprisng in Erlang, or which I had to repeatedly look up on
the web.

## Pattern matching in functions

You can use pattern matching inside function calls, for example:
```erlang
element(2, {ok, _} = application:get_env(myapp, myenv)).
```

This is useful in macros as it removes the need to pollute scope with bounded
variables:
```erlang
% this creates bounded variable Env
-define(MYENV, begin
  {ok, Env} = application:get_env(myapp, myenv),
  Env
end).

% this does not
-define(MYENV, element(2, {ok, _} = application:get_env(myapp, myenv))).
```

## Bitstring and binaries matching

```erlang
% match 3 bytes as integer (unsigned, big endian)
<<_:24>> = <<"abc">>.
<<_:24/integer>> = <<"abc">>.
<<_:3/integer-unit:8>> = <<"abc">>.

% match 3 bytes as binary
<<_:3/binary>> = <<"abc">>.
<<_:3/binary-unit:8>> = <<"abc">>.
<<_:1/binary-unit:24>> = <<"abc">>.
```

For the rest of the syntax see [the bit syntax
documentation](http://erlang.org/doc/programming_examples/bit_syntax.html).

