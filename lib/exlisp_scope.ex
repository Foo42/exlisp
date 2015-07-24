defmodule Exlisp.Scope do
	def open(), do: open([])
	def open(stack), do: [new_stack_frame | stack]
	def close([current|other]), do: other

	def bind([current_frame|other_frames], name, value) do
		current_frame = bind_in_frame(current_frame, name, value)
		[current_frame|other_frames]
	end

	def get_value(stack, name) do
		frame = Enum.find(stack, fn frame -> Dict.has_key?(frame[:bindings],name) end)
		case frame do
			nil -> {:undefined}
			_   -> {:ok, frame[:bindings][name]}
		end
	end 

	defp bind_in_frame(frame, name, value), do: frame |> Dict.put(:bindings, Dict.put(frame[:bindings], name, value))
	defp new_stack_frame, do: %{bindings: %{}}
end
