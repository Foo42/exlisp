defmodule Exlisp.EvaluatorTest do
  use ExUnit.Case

  test "evaluating flat expression with arithmetic function" do
  	result = "+ 5 1" |> Exlisp.evaluate
    assert result == 6
  end

  test "evaluating expression nested arithmetic function" do
    result = "+ 1 (* 2 3 (/ 1 2) (- 10 20))" |> Exlisp.evaluate
    assert result == -29
  end

  test "multiplication function" do
    result = "* 2 3 (* 3 5)" |> Exlisp.evaluate
    assert result == 90
  end

  test "subtraction function" do
    result = "- 3 2 (- 10 4)" |> Exlisp.evaluate
    assert result == -5
  end

  test "division function" do
    result = "/ 10 2 (/ 4 2)" |> Exlisp.evaluate
    assert result == 2.5
  end

end
