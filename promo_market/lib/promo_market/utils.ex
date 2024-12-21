defmodule PromoMarket.Utils do
  @moduledoc """
  This module defines utility functions. When the project grows this module can be separated
  into specific utils modules.
  """
  import Ecto.Changeset
  alias Ecto.Changeset

  @spec validate_money(Changeset.t(), atom()) :: Changeset.t()
  def validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount > 0 -> []
      _, _ -> [{field, "must be greater than 0"}]
    end)
  end

  @spec validate_not_empty_map(Changeset.t(), atom()) :: Changeset.t()
  def validate_not_empty_map(changeset, field) do
    field_value = get_field(changeset, field)

    case map_size(field_value) do
      0 ->
        add_error(changeset, field, "cannot be an empty map")

      _ ->
        changeset
    end
  end
end
