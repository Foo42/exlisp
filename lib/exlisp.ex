defmodule Exlisp do
	alias Exlisp.Parser

	def parse(s), do: Parser.parse(s)

	def evaluate(s) when is_binary(s), do: Parser.parse(s) |> evaluate_list
	
	def evaluate(term) when is_list(term), do: evaluate_list(term)
	
	def evaluate(%{type: :symbol, content: "true"}), do: true
	def evaluate(%{type: :symbol, content: "false"}), do: false
	def evaluate(%{type: :symbol, content: symbol}) do
		{number,_} = Float.parse(symbol)
		number
	end

	defp evaluate_list([op|args]), do: execute(op, args)

	defp evaluate_each(args), do: Enum.map(args, &evaluate(&1))

	defp execute(%{type: :symbol, content: "+"}, args) do
		evaluate_each(args) |> Enum.reduce(fn (num, total) -> total+num end)
	end

	defp execute(%{type: :symbol, content: "*"}, args) do
		evaluate_each(args) |> Enum.reduce(fn (num, total) -> total*num end)
	end

	defp execute(%{type: :symbol, content: "-"}, args) do
		evaluate_each(args) |> Enum.reduce(fn (num, total) -> total-num end)
	end

	defp execute(%{type: :symbol, content: "/"}, args) do
		evaluate_each(args) |> Enum.reduce(fn (num, total) -> total/num end)
	end

	defp execute(%{type: :symbol, content: ">"}, args) do
		evaluate_each(args) |> Enum.reduce(fn (num, prev) -> prev > num end)
	end

	defp execute(%{type: :symbol, content: "<"}, args) do
		evaluate_each(args) |> Enum.reduce(fn (num, prev) -> prev < num end)
	end

	defp execute(%{type: :symbol, content: "="}, args) do
		evaluate_each(args) |> Enum.reduce(fn (prev, current) -> prev == current end)
	end

	defp execute(%{type: :symbol, content: "!="}, args) do
		evaluate_each(args) |> Enum.reduce(fn (prev, current) -> prev != current end)
	end

	defp execute(%{type: :symbol, content: "list"}, args), do: evaluate_each(args)

	defp execute(%{type: :symbol, content: "if"}, args) do
		[predicate, true_clause, %{type: :symbol, content: "else"}, false_clause] = args
		if evaluate(predicate), do: evaluate(true_clause), else: evaluate(false_clause)
	end

	defp execute([%{type: :symbol, content: "fn"} | function_def], args) do
		[parameters, %{type: :symbol, content: "->"}, function_body] = function_def
		"todo"
	end

	defp execute(%{type: :symbol, content: unknown_function}, _args), do: throw "Unknown function '#{unknown_function}'"
end
