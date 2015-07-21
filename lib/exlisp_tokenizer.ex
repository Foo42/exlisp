defmodule Exlisp.Tokenizer do
	def tokenize(characters), do: tokenize(characters, []) |> Enum.reverse |> Enum.map(&Dict.delete(&1,:closed))
	
	defp tokenize([], tokens), do: tokens
	defp tokenize([" "|other_characters],tokens), do: tokenize(other_characters, tokens)
	defp tokenize(["("|other_characters],tokens), do: tokenize(other_characters,[%{type: :open_brace}|tokens])
	defp tokenize([")"|other_characters],tokens), do: tokenize(other_characters,[%{type: :close_brace}|tokens])
	defp tokenize(["\""|other_characters],tokens), do: tokenize_quoted_string(other_characters,[%{type: :quoted_string, content: ""}|tokens])
	defp tokenize([character|other_characters],tokens), do: tokenize_symbol(other_characters,[%{type: :symbol, content: character}|tokens])
	
	# defp tokenize_whitespace(["\""|other_characters], tokens), do: tokenize(other_characters, tokens)

	defp tokenize_symbol([],tokens), do: tokens
	defp tokenize_symbol([" " | other_characters],tokens), do: tokenize(other_characters, tokens)
	defp tokenize_symbol(characters = ["(" | other_characters],tokens), do: tokenize(characters, tokens)
	defp tokenize_symbol(characters = [")" | other_characters],tokens), do: tokenize(characters, tokens)
	defp tokenize_symbol([character | other_characters],[symbol_token = %{content: symbol_characters}|other_tokens]) do 
		tokenize_symbol(other_characters, [Dict.put(symbol_token, :content, symbol_characters <> character)|other_tokens])
	end

	defp tokenize_quoted_string([],tokens), do: tokens
	defp tokenize_quoted_string(["\"" | other_characters],tokens), do: tokenize(other_characters, tokens)
	defp tokenize_quoted_string([character | other_characters],[symbol_token = %{content: symbol_characters}|other_tokens]) do 
		tokenize_quoted_string(other_characters, [Dict.put(symbol_token, :content, symbol_characters <> character)|other_tokens])
	end
end
