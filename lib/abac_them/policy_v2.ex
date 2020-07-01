defmodule ABACthem.PolicyV2 do
  @moduledoc """
  Specifies a Policy model for access control in the Swarm.

  This specification follows a number of requirements. Sometimes these requirements conflict with each other,
  so we try to flexibilize them and obtain a hybrid system, harmonizing theoretical and practical goals.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias ABACthem.Rule

  @derive {Jason.Encoder, only: [:id, :version, :name]}

  @primary_key false
  embedded_schema do
    field :id, :string
    field :version, :string, default: "2.0"
    field :name
    embeds_one :privileges, Rule
  end

  def changeset(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:id, :version, :name])
    |> cast_embed(:privileges)
  end
end
