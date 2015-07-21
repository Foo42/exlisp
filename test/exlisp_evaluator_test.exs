defmodule Exlisp.EvaluatorTest do
  use ExUnit.Case

  test "evaluating flat expression with arithmetic function" do
  	result = "+ 5 1" |> Exlisp.evaluate
    assert result == 6
  end

  # test "evaluating expression with simple sub-expression" do
  # 	parsed_result = "(noop)" |> Exlisp.parse
  #   assert parsed_result == [[%{type: :symbol, content: "noop"}]]
  # end

  # test "evaluating expression with terms at mixed sub-expression levels" do
  # 	parsed_result = "+ 5 (* 2 3) 1" |> Exlisp.parse
  #   assert parsed_result == [
  #   	%{type: :symbol, content: "+"},
  #   	%{type: :symbol, content: "5"},
  #   	[
  #   		%{type: :symbol, content: "*"},
  #   		%{type: :symbol, content: "2"},
  #   		%{type: :symbol, content: "3"}
  #   	],
  #   	%{type: :symbol, content: "1"}
  #   ]
  # end
end
