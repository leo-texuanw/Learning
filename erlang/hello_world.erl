-module(hello_world).
-export([add/2,hello/0,greet_and_add_two/1]).

    add(A, B) ->
        A + B.

    %% shows greetings.
    hello() ->
        io:format("hello world!~n").

    greet_and_add_two(X) ->
        hello(),
        add(X, 2).
