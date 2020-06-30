defmodule TypeInferenceTest do
  use ExUnit.Case
  doctest ABACthem
  alias ABACthem.{Types}

  test "infer type" do
    assert %{data_type: "string", name: "id", value: "alice"} = Types.infer_type(%{"id" => "alice"})
    assert %{data_type: "number", name: "age", value: 20} = Types.infer_type(%{"age" => 20})
    assert %{data_type: "number", name: "reputation", value: 4.0} = Types.infer_type(%{"reputation" => 4.0})
    assert %{data_type: "range", name: "year", value: %{max: 2030}} = Types.infer_type(%{"year" => %{"max" => 2030}})
  end
end