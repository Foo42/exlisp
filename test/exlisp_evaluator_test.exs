defmodule Exlisp.EvaluatorTest do
  use ExUnit.Case

  test "evaluating flat expression with arithmetic function" do
  	result = "+ 5 1" |> Exlisp.evaluate
    assert result == 6
  end

  test "evaluating expression nested arithmetic function" do
    result = "+ 1 (+ 2 3 (+ 1 2) 1)" |> Exlisp.evaluate
    assert result == 10
  end

  test "multiplication function" do
    result = "* 2 3 (* 3 5)" |> Exlisp.evaluate
    assert result == 90
  end

end
