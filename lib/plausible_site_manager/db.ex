defmodule DB do
  defmacro __using__(_) do
    quote location: :keep do
      @name __MODULE__

      def child_spec(opts) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [opts]}
        }
      end

      def start_link(config) do
        defaults = [name: @name, pool_size: 5]
        config = Keyword.merge(defaults, config)
        Postgrex.start_link(config)
      end

      def query!(sql, values \\ []) do
        Postgrex.query!(@name, sql, values)
      end

      def transaction!(fun, opts \\ []) do
        case Postgrex.transaction(@name, fun, opts) do
          {:ok, res} -> res
          {:error, :rollback} -> raise "transaction! rollback"
          err -> err
        end
      end

      # For queries that return 1 row with 1 column
      def scalar!(sql, values \\ []) do
        case query!(sql, values) do
          %{rows: []} ->
            nil

          %{rows: [[value]]} ->
            value

          %{rows: _} ->
            # maybe log sql and values?
            raise "scalar returned multiple columns and/or rows"
        end
      end

      # For queries that return 1 row
      def row!(sql, values \\ []) do
        case query!(sql, values) do
          %{rows: []} ->
            nil

          %{rows: [row]} ->
            row

          _ ->
            # maybe log sql and values?
            raise "row! returned multiple rows"
        end
      end

      # For queries that return mulitple rows
      def rows!(sql, values \\ []), do: query!(sql, values).rows

      # number of affected rows (generally used for updates or deletes)
      def affected!(sql, values \\ []), do: query!(sql, values).num_rows

      # For queries that return 1 row, which we want to turn into a map
      def map!(sql, values \\ []) do
        case query!(sql, values) do
          %{rows: []} ->
            nil

          %{rows: [row], columns: columns} ->
            mapify(columns, row)

          _ ->
            # maybe log sql and values?
            raise "map! returned multiple rows"
        end
      end

      # For queries that return multiple rows, which we want to turn into an array of maps
      def maps!(sql, values \\ []) do
        case query!(sql, values) do
          %{rows: []} ->
            nil

          %{rows: rows, columns: columns} ->
            Enum.map(rows, fn row -> mapify(columns, row) end)

          _ ->
            # maybe log sql and values?
            raise "maps! returned multiple rows"
        end
      end

      defp mapify(columns, row) do
        columns
        |> Enum.zip(row)
        |> Map.new()
      end
    end
  end
end

defmodule PlausibleSiteManager.DB do
  @moduledoc false

  use DB
end
