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

  test "'>' boolean comparison function" do
    result = "> 3 4" |> Exlisp.evaluate
    assert result == false
  end

  test "'<' boolean comparison function" do
    result = "< 3 4" |> Exlisp.evaluate
    assert result == true
  end

  test "'=' boolean comparison function" do
    result = "= 3 4" |> Exlisp.evaluate
    assert result == false

    result = "= 3 3" |> Exlisp.evaluate
    assert result == true
  end

  test "'!=' boolean comparison function" do
    result = "!= 3 4" |> Exlisp.evaluate
    assert result == true
  end

  test "'and' boolean function" do
    result = "and true true" |> Exlisp.evaluate
    assert result == true

    result = "and true false" |> Exlisp.evaluate
    assert result == false
  end

  test "'list' function returns list unmodified" do
    result = "list 3 false" |> Exlisp.evaluate
    assert result == [3, false]
  end

  test "'and' boolean function" do
    result = "and true true" |> Exlisp.evaluate
    assert result == true

    result = "and true false" |> Exlisp.evaluate
    assert result == false
  end

  test "'or' boolean function" do
    result = "or false false" |> Exlisp.evaluate
    assert result == false

    result = "or true false" |> Exlisp.evaluate
    assert result == true
  end

  test "'if' function can return values conditionally" do
    result = "if true 1 else 2" |> Exlisp.evaluate
    assert result == 1

    result = "if (> 1 2) 1 else 2" |> Exlisp.evaluate
    assert result == 2
  end

  test "Anonymous functions can operate on a list" do
    result = "(fn (a b) -> (> a  b)) 1 2" |> Exlisp.evaluate
    assert result == false
  end

  test "value bindings from function paramter list do not leak to outer scope" do
    assert catch_error("(fn (a b) -> (> a  b)) a 2" |> Exlisp.evaluate) == {:badmatch, {:undefined}}
  end
end
