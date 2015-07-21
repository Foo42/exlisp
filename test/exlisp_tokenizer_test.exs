defmodule Exlisp.TokenizerTest do
  use ExUnit.Case

  test "empty input" do
  	input = []
  	assert Exlisp.Tokenizer.tokenize(input) == []
  end

  test "single character symbol" do
  	input = ["a"]
  	expectedOutput = [%{type: :symbol, content: "a"}]
  	assert Exlisp.Tokenizer.tokenize(input) == expectedOutput
  end

  test "multi character symbol should collect all characters into symbol" do
  	input = "foo" |> String.codepoints
  	expectedOutput = [%{type: :symbol, content: "foo"}]
  	IO.puts inspect Exlisp.Tokenizer.tokenize(input)
  	assert Exlisp.Tokenizer.tokenize(input) == expectedOutput
  end

  test "symbol followed by space should discard space" do
  	input = "foo    " |> String.codepoints
  	expectedOutput = [%{type: :symbol, content: "foo"}]
  	IO.puts inspect Exlisp.Tokenizer.tokenize(input)
  	assert Exlisp.Tokenizer.tokenize(input) == expectedOutput
  end

  test "multiple symbols separated by spaces should become separate tokens" do
  	input = "foo bar" |> String.codepoints
  	expectedOutput = [%{type: :symbol, content: "foo"}, %{type: :symbol, content: "bar"}]
  	IO.puts inspect Exlisp.Tokenizer.tokenize(input)
  	assert Exlisp.Tokenizer.tokenize(input) == expectedOutput
  end

  test "parenthesis should be tokenized as such" do
    input = "(())" |> String.codepoints
    expectedOutput = [%{type: :open_brace}, %{type: :open_brace}, %{type: :close_brace}, %{type: :close_brace}]
    IO.puts inspect Exlisp.Tokenizer.tokenize(input)
    assert Exlisp.Tokenizer.tokenize(input) == expectedOutput
  end

  test "parenthesis not capture other tokens" do
    input = "(1)" |> String.codepoints
    expectedOutput = [%{type: :open_brace}, %{type: :symbol, content: "1"}, %{type: :close_brace}]
    IO.puts inspect Exlisp.Tokenizer.tokenize(input)
    assert Exlisp.Tokenizer.tokenize(input) == expectedOutput
  end

  test "quoted strings should be tokenized as a single token" do
    input = "\"hello (world)\"next" |> String.codepoints
    expectedOutput = [%{type: :quoted_string, content: "hello (world)"}, %{type: :symbol, content: "next"}]
    IO.puts inspect Exlisp.Tokenizer.tokenize(input)
    assert Exlisp.Tokenizer.tokenize(input) == expectedOutput
  end
end
