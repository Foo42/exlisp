defmodule Exlisp do
	def parse(s), do: Exlisp.Parser.parse(s)

	def evaluate(s) when is_binary(s), do: Exlisp.Parser.parse(s) |> evaluate_list
	
	def evaluate(term) when is_list(term), do: evaluate_list(term)
	
	def evaluate(%{type: :symbol, content: symbol}) do
		{number,_} = Float.parse(symbol)
		number
	end

	defp evaluate_list([op|args]), do: execute(op, Enum.map(args, &evaluate(&1)))

	defp execute(%{type: :symbol, content: "+"}, args) do
		result = Enum.reduce(args,fn (num, total) -> total+num end)
		result
	end

	defp execute(%{type: :symbol, content: "*"}, args) do
		result = Enum.reduce(args,fn (num, total) -> total*num end)
		result
	end
end
