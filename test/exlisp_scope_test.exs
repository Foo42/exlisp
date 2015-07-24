defmodule Exlisp.ScopeTest do
	use ExUnit.Case

	test "open scope creates a scope stack with an entry" do
		assert scope = [scope_frame] = Exlisp.Scope.open()
		assert %{bindings: %{}} = scope_frame

		assert [_new_scope_frame,scope_frame] = Exlisp.Scope.open scope
	end

	test "close scope removes a frame from the scope" do
		#create a couple of stack frames
		scope = Exlisp.Scope.open |> Exlisp.Scope.open
		assert 2 = Enum.count(scope)
		scope = Exlisp.Scope.close(scope)
		assert 1 = Enum.count(scope)
	end

	test "bind sets a binding in the head scope frame" do
		#create a couple of stack frames
		scope = Exlisp.Scope.open |> Exlisp.Scope.open
		[%{bindings: %{"foo" => 42}} | other_frames] = Exlisp.Scope.bind scope, "foo", 42
	end

	test "get_value gets the innermost scoped value of a binding" do
		scope = Exlisp.Scope.open |> Exlisp.Scope.bind("x", 1) |> Exlisp.Scope.open |> Exlisp.Scope.bind("x", 2)
		assert {:ok, 2} = Exlisp.Scope.get_value(scope,"x")
		assert {:ok, 1} = scope |> Exlisp.Scope.close |> Exlisp.Scope.get_value "x"
	end
end
