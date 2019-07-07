---
title: Barrier between two hosts using bash and netcat
---

Recently I needed a quick and dirty solution to achieve a synchronisation barrier between two hosts, as in:
```bash
host1> prepare-stuff && notify-host2
host2> wait-for-host1 && use-stuff
```

What I came up with is this netcat solution, which makes host2 wait until host1 opens a TCP connection at specific port. After that both hosts continue executing their commands.


## TLDR - the bash oneliners
```bash
# listen at 0.0.0.0:$PORT
host2> nc -l -p $PORT

# wait for netcat to listen at $HOST:$PORT and immediately close connection
# when it is achieved.
# For portability attempt netcat command with different option sets
host1> while ! nc $HOST $PORT -v -q 0 && ! nc $HOST $PORT -v -c; do sleep 0.1; done < /dev/null 2> /dev/null
```

## Explanation
Let's walk through the netcat flags:
- `-l` - listen for a connection
- `-p $PORT` - listen at given port
- `-v` - be verbose (optional)
- `-q 0` - close connection 0 seconds after EOF on stdin
- `-c` - close connection after EOF (alternative flag)

By piping `< /dev/null` netcat receives EOF right after achieving the connection. Due to the `-q 0`/`-c` flag the connection is closed immediately and processing on both hosts can continue.

## Fish functions
My shell of choice is [Fish](https://fishshell.com/), so here are the original functions I use:
```fish
function ncnotify
        while not nc $argv[1] 4444 -v -q 0 < /dev/null 2> /dev/null; 
      and not nc $argv[1] 4444 -v -c < /dev/null 2> /dev/null; 
      sleep 0.1;
  end
end

function ncwait
        nc -l -p 4444 $argv
end
```

## Further work
As you can see it is quite a quick&dirty solution. It could use better error reporting than `2>/dev/null`. And for production use it is much better to use a domain-specific approach for awaiting events rather than relying on flawless network connectivity.


Do you know a better or simpler approach? Let me know on [Twitter](https://twitter.com/Ciechosz)!

