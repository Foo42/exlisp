defmodule Exlisp do
	def parse(s), do: Exlisp.Parser.parse(s)

	def evaluate(s) when is_binary(s), do: Exlisp.Parser.parse(s) |> evaluate_list
	
	def evaluate(term) when is_list(term), do: evaluate_list(term)
	
	def evaluate(%{type: :symbol, content: "true"}), do: true
	def evaluate(%{type: :symbol, content: "false"}), do: false
	def evaluate(%{type: :symbol, content: symbol}) do
		{number,_} = Float.parse(symbol)
		number
	end

	defp evaluate_list([op|args]), do: execute(op, Enum.map(args, &evaluate(&1)))

	defp execute(%{type: :symbol, content: "+"}, args) do
		Enum.reduce(args,fn (num, total) -> total+num end)
	end

	defp execute(%{type: :symbol, content: "*"}, args) do
		Enum.reduce(args,fn (num, total) -> total*num end)
	end

	defp execute(%{type: :symbol, content: "-"}, args) do
		Enum.reduce(args,fn (num, total) -> total-num end)
	end

	defp execute(%{type: :symbol, content: "/"}, args) do
		Enum.reduce(args,fn (num, total) -> total/num end)
	end

	defp execute(%{type: :symbol, content: ">"}, args) do
		Enum.reduce(args,fn (num, prev) -> prev > num end)
	end

	defp execute(%{type: :symbol, content: "<"}, args) do
		Enum.reduce(args,fn (num, prev) -> prev < num end)
	end

	defp execute(%{type: :symbol, content: "="}, args) do
		Enum.reduce(args,fn (prev, current) -> prev == current end)
	end

	defp execute(%{type: :symbol, content: "!="}, args) do
		Enum.reduce(args,fn (prev, current) -> prev != current end)
	end

	defp execute(%{type: :symbol, content: "list"}, args), do: args

	defp execute(%{type: :symbol, content: unknown_function}, _args), do: throw "Unknown function '#{unknown_function}'"
end
