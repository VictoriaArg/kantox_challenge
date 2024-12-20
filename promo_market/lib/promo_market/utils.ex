defmodule PromoMarket.Utils do
  @moduledoc """
  This module defines utility functions. When the project grows this module can be separated
  into specific utils modules.
  """
  import Ecto.Changeset

  @spec validate_money(Changeset.t(), atom()) :: Changeset.t() | list()
  def validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount > 0 -> []
      _, _ -> [{field, "must be greater than 0"}]
    end)
  end
end
