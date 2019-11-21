defmodule Microcosm.Rules do
  def evaluate_alive(board, row, col) do
    {_, _, %{species: species}} = board |> Enum.at(row) |> Enum.at(col)
    _evaluate(species.rules.alive, board, row, col)
  end

  def evaluate_dead(board, row, col, species_list) when is_list(species_list) do
    species_list
    |> Enum.reduce({false, nil}, fn
      _species, {true, x} ->
        {true, x}

      species, {false, nil} ->
        case _evaluate(species.rules.dead, board, row, col) do
          true -> "hi"
          false -> "bye"
        end
    end)
  end

  defp _evaluate(rules, board, row, col) do
  end
end
