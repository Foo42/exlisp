defmodule ExlispTest do
  use ExUnit.Case

  test "parsing flat expression" do
  	parsed_result = "+ 5 1" |> Exlisp.parse
    assert parsed_result == [%{type: :symbol, content: "+"}, %{type: :symbol, content: "5"}, %{type: :symbol, content: "1"}]
  end

  test "parsing expression with simple sub-expression" do
  	parsed_result = "(noop)" |> Exlisp.parse
    assert parsed_result == [[%{type: :symbol, content: "noop"}]]
  end

  test "parsing expression with terms at mixed sub-expression levels" do
  	parsed_result = "+ 5 (* 2 3) 1" |> Exlisp.parse
    assert parsed_result == [
    	%{type: :symbol, content: "+"},
    	%{type: :symbol, content: "5"},
    	[
    		%{type: :symbol, content: "*"},
    		%{type: :symbol, content: "2"},
    		%{type: :symbol, content: "3"}
    	],
    	%{type: :symbol, content: "1"}
    ]
  end

  test "parsing expression with mixed levels" do
    parsed_result = "a b (c d e (f g h))" |> Exlisp.parse
    assert [
      %{content: "a"},
      %{content: "b"},
      [
        %{content: "c"},
        %{content: "d"},
        %{content: "e"},
        [
          %{content: "f"},
          %{content: "g"},
          %{content: "h"}
        ]
      ]
    ] = parsed_result
  end
end
