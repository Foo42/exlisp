defmodule Exlisp do
	alias Exlisp.Parser
	alias Exlisp.Scope

	def parse(s), do: Parser.parse(s)

	def evaluate(s) when is_binary(s), do: Parser.parse(s) |> evaluate_list Scope.open
	def evaluate(term, stack) when is_list(term), do: evaluate_list(term, stack)
	
	def evaluate(%{type: :symbol, content: "true"}, _stack), do: true
	def evaluate(%{type: :symbol, content: "false"}, _stack), do: false
	def evaluate(%{type: :symbol, content: symbol}, stack) do
		case Float.parse(symbol) do
			{number,_} -> 
				number
			_ ->
				{:ok, value} = Scope.get_value(stack,symbol)
				value
		end
	end

	defp evaluate_list([op|args], stack), do: execute(op, args, Scope.open(stack))

	defp evaluate_each(args, stack), do: Enum.map(args, &evaluate(&1, stack))

	defp execute(%{type: :symbol, content: "+"}, args, stack) do
		evaluate_each(args, stack) |> Enum.reduce(fn (num, total) -> total+num end)
	end

	defp execute(%{type: :symbol, content: "*"}, args, stack) do
		evaluate_each(args, stack) |> Enum.reduce(fn (num, total) -> total*num end)
	end

	defp execute(%{type: :symbol, content: "-"}, args, stack) do
		evaluate_each(args, stack) |> Enum.reduce(fn (num, total) -> total-num end)
	end

	defp execute(%{type: :symbol, content: "/"}, args, stack) do
		evaluate_each(args, stack) |> Enum.reduce(fn (num, total) -> total/num end)
	end

	defp execute(%{type: :symbol, content: ">"}, args, stack) do
		evaluate_each(args, stack) |> Enum.reduce(fn (num, prev) -> prev > num end)
	end

	defp execute(%{type: :symbol, content: "<"}, args, stack) do
		evaluate_each(args, stack) |> Enum.reduce(fn (num, prev) -> prev < num end)
	end

	defp execute(%{type: :symbol, content: "and"}, args, stack) do
		evaluate_each(args, stack) |> Enum.all?
	end

	defp execute(%{type: :symbol, content: "or"}, args, stack) do
		evaluate_each(args, stack) |> Enum.any?
	end

	defp execute(%{type: :symbol, content: "="}, args, stack) do
		evaluate_each(args, stack) |> Enum.reduce(fn (prev, current) -> prev == current end)
	end

	defp execute(%{type: :symbol, content: "!="}, args, stack) do
		evaluate_each(args, stack) |> Enum.reduce(fn (prev, current) -> prev != current end)
	end

	defp execute(%{type: :symbol, content: "list"}, args, stack), do: evaluate_each(args, stack)

	defp execute(%{type: :symbol, content: "if"}, args, stack) do
		[predicate, true_clause, %{type: :symbol, content: "else"}, false_clause] = args
		if evaluate(predicate, stack), do: evaluate(true_clause, stack), else: evaluate(false_clause, stack)
	end

	defp execute([%{type: :symbol, content: "fn"} | function_def], args, stack) do
		[parameters, %{type: :symbol, content: "->"}, function_body] = function_def
		stack_with_bound_params = 
			Enum.zip(parameters,args)
			|> Enum.reduce(stack, fn ({%{content: name},value},stack) -> Scope.bind(stack,name,evaluate(value,stack)) end)
		evaluate(function_body, stack_with_bound_params)
	end

	defp execute(%{type: :symbol, content: "let"}, [%{type: :symbol, content: name}, value, body], stack) do
		stack_with_bound_params =  Scope.bind(stack,name,evaluate(value,stack))
		evaluate(body, stack_with_bound_params)
	end

	defp execute(%{type: :symbol, content: "do"}, statements, stack) do
		args |> Enum.reduce(stack, fn statement ->  end) # problem - we need to let statements modify the stack (state) in that they need to be able to define things, this isnt posible currently as executing statements dont return the stack
	end

	defp execute(%{type: :symbol, content: unknown_function}, _args, _stack), do: throw "Unknown function '#{unknown_function}'"
end
