defmodule Microcosm.Game do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: GameServer)
  end

  @impl true
  def init(_) do
    species = %{1 => %{color: "blue"}}
    {:ok, %{board: initial_board(species), species: species}}
  end

  def start_game() do
    GenServer.call(GameServer, :start_game)
  end

  def next_step() do
    GenServer.call(GameServer, :next_step)
  end

  @impl true
  def handle_call(:start_game, _from, state) do
    species = initial_species()
    board = initial_board(species)
    {:reply, %{board: board, species: species}, %{state | board: board, species: species}}
  end

  @impl true
  def handle_call(:next_step, _from, state) do
    new_board = _next_board(state.board, state.species)
    {:reply, new_board, %{state | board: new_board}}
  end

  def initial_species() do
    %{
      1 => %{color: "blue"},
      2 => %{color: "yellow"}
    }

    # [
    #   [id: 1, color: "blue"],
    #   [id: 2, color: "yellow"]
    # ]
  end

  def initial_board(species) do
    0..99
    |> Enum.map(fn row_num ->
      0..109
      |> Enum.map(fn col_num ->
        {row_num, col_num, 0}
      end)
    end)
    |> randomize_board(species)
  end

  def randomize_board(board, species) do
    board
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn {row_num, col_num, _} ->
        case :rand.uniform() > 0.09 do
          true ->
            {row_num, col_num, 0}

          false ->
            s = species |> Enum.random() |> elem(0)
            {row_num, col_num, s}
        end
      end)
    end)
  end

  defp _next_board(board, species) do
    board
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn
        {r, c, 0} ->
          case count_live_neighbors(board, r, c) do
            3 ->
              s = species |> Enum.random() |> elem(0)
              {r, c, s}

            _ ->
              {r, c, 0}
          end

        {r, c, s_id} ->
          val =
            case count_live_neighbors(board, r, c) do
              n when n < 2 -> 0
              n when n in [2, 3] -> s_id
              _ -> 0
            end

          {r, c, val}
      end)
    end)
  end

  def count_live_neighbors(board, row, col) do
    total_board_rows = board |> length()

    total_board_cols =
      board
      |> hd()
      |> length()

    right_col =
      case col + 1 do
        ^total_board_cols -> 0
        val -> val
      end

    bottom_row =
      case row + 1 do
        ^total_board_rows -> 0
        val -> val
      end

    ul = board |> Enum.at(row - 1) |> Enum.at(col - 1) |> _0_or_1()
    u = board |> Enum.at(row - 1) |> Enum.at(col) |> _0_or_1()
    ur = board |> Enum.at(row - 1) |> Enum.at(right_col) |> _0_or_1()

    l = board |> Enum.at(row) |> Enum.at(col - 1) |> _0_or_1()
    r = board |> Enum.at(row) |> Enum.at(right_col) |> _0_or_1()

    dl = board |> Enum.at(bottom_row) |> Enum.at(col - 1) |> _0_or_1()
    d = board |> Enum.at(bottom_row) |> Enum.at(col) |> _0_or_1()
    dr = board |> Enum.at(bottom_row) |> Enum.at(right_col) |> _0_or_1()

    ul + u + ur + l + r + dl + d + dr
  end

  defp _0_or_1({_, _, 0}), do: 0

  defp _0_or_1(_), do: 1
end
