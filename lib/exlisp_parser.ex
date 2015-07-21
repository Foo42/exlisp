defmodule Exlisp.Parser do
	def parse(s) when is_binary(s) do 
		result = s |> String.codepoints |> parse
		result
	end

	def parse(l) when is_list(l) do
		l |> Exlisp.Tokenizer.tokenize |> collect_terms
	end

	defp collect_terms(tokens), do: collect_terms(tokens, [[]])
	defp collect_terms([], terms), do: terms |> Enum.at(0) |> Enum.reverse

	defp collect_terms([%{type: :open_brace} | other_tokens], terms), do: collect_terms(other_tokens,[[]|terms])
	
	defp collect_terms([%{type: :close_brace} | other_tokens], terms) do
		[completed_term | [current_term |other_terms]] = terms
		current_term = [Enum.reverse(completed_term) | current_term]
		terms = [current_term | other_terms]
		collect_terms(other_tokens,terms)
	end
	
	defp collect_terms([token | other_tokens], terms) do
		[current_term|other_terms] = terms
		current_term = [token | current_term]
		terms = [current_term|other_terms]
		collect_terms(other_tokens,terms)
	end
end
