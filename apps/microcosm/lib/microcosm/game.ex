defmodule Microcosm.Game do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: GameServer)
  end

  @impl true
  def init(_) do
    {:ok, %{board: initial_board()}}
  end

  def start_game() do
    GenServer.call(GameServer, :start_game)
  end

  def next_step() do
    GenServer.call(GameServer, :next_step)
  end

  @impl true
  def handle_call(:start_game, _from, state) do
    new_board = initial_board()
    {:reply, new_board, %{state | board: new_board}}
  end

  @impl true
  def handle_call(:next_step, _from, state) do
    new_board = _next_board(state.board)
    {:reply, new_board, %{state | board: new_board}}
  end

  def initial_board() do
    0..99
    |> Enum.map(fn row_num ->
      0..109
      |> Enum.map(fn col_num ->
        {row_num, col_num, 0}
      end)
    end)
    |> randomize_board()
  end

  def randomize_board(board) do
    board
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn {row_num, col_num, _} ->
        case :rand.uniform() > 0.09 do
          true -> {row_num, col_num, 0}
          false -> {row_num, col_num, 1}
        end
      end)
    end)
  end

  defp _next_board(board) do
    board
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn
        {r, c, 1} ->
          val =
            case count_live_neighbors(board, r, c) do
              n when n < 2 -> 0
              n when n in [2, 3] -> 1
              _ -> 0
            end

          {r, c, val}

        {r, c, 0} ->
          case count_live_neighbors(board, r, c) do
            3 -> {r, c, 1}
            _ -> {r, c, 0}
          end
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

    {_, _, ul} = board |> Enum.at(row - 1) |> Enum.at(col - 1)
    {_, _, u} = board |> Enum.at(row - 1) |> Enum.at(col)
    {_, _, ur} = board |> Enum.at(row - 1) |> Enum.at(right_col)

    {_, _, l} = board |> Enum.at(row) |> Enum.at(col - 1)
    {_, _, r} = board |> Enum.at(row) |> Enum.at(right_col)

    {_, _, dl} = board |> Enum.at(bottom_row) |> Enum.at(col - 1)
    {_, _, d} = board |> Enum.at(bottom_row) |> Enum.at(col)
    {_, _, dr} = board |> Enum.at(bottom_row) |> Enum.at(right_col)

    ul + u + ur + l + r + dl + d + dr
  end

  defp _print_board(board) do
    board
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn {_, _, val} -> val end)
    end)
    |> IO.inspect(label: "the new board")

    :timer.sleep(500)
    board
  end
end
