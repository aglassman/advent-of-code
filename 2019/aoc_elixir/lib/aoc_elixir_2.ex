defmodule IntComp do
  @moduledoc """
  Documentation for IntComp.
  """

  @doc """
    An Op struct looks like this:
    %{  opcode: add,
        params: [
          { 3, :immediate },
          { 4, :position },
          { 30, :position }
        ]}
  """
  defmodule Op do

    defstruct opcode: :halt, params: []

    @doc """
      Returns tuple of { operation, parameter_count }
    """
    def match_opcode(int_op) do
      case int_op do
        1 -> { :add, 4 }
        2 -> { :multiply, 4}
        3 -> { :input, 2 }
        4 -> { :output, 2 }
        5 -> { :jump_if_true, 3 }
        6 -> { :jump_if_false, 3 }
        7 -> { :less_than, 4 }
        8 -> { :equals, 4 }
        99 -> { :halt, 1 }
        _ -> { :unknown, 1 }
      end
    end

    def parse_opcode(full_opcode) do
      full_opcode |> Integer.mod(100) |> match_opcode
    end

    def to_mode(mode_int) do
      case mode_int do
        0 -> :position
        1 -> :immediate
      end
    end

    def instruction_to_op(instruction) do

      full_opcode = instruction |> List.pop_at(0)|> elem(0)

      { opcode, num_of_params } = parse_opcode(full_opcode)

      modes = [
        full_opcode |> Integer.mod(1000) |> Integer.floor_div(100) |> to_mode,
        full_opcode |> Integer.mod(10000) |> Integer.floor_div(1000) |> to_mode,
        full_opcode |> Integer.mod(100000) |> Integer.floor_div(10000) |> to_mode
      ]

      case opcode do
        :halt ->
          %Op{}
        _ ->

          params = case num_of_params > 1 do
            true ->
              Enum.map(
                1..(num_of_params-1),
                fn x ->
                  {
                    instruction |> List.pop_at(x)|> elem(0),
                    List.pop_at(modes, x - 1) |> elem(0) }
                end)
             false -> []
          end

          %Op{
             opcode: opcode,
             params: params
           }
      end
    end
  end

  def output_for_input(program, input) do
    program
    |> List.replace_at(1,input.noun)
    |> List.replace_at(2,input.verb)
    |> run_program(0)
    |> List.first()
  end


  def run_program(program, instruction_pointer \\ 0)

  def run_program({:halt, program}, instruction_pointer) do
   program
  end

  def run_program(program, instruction_pointer) do

    current_program_head = Enum.drop(program, instruction_pointer)

    {_opcode, op_length} = current_program_head
      |> List.first()
      |> Op.parse_opcode()

    op = Op.instruction_to_op(Enum.take(current_program_head, op_length))

    IO.inspect(op)
    {program, instruction_pointer} = perform_operation(op, program, instruction_pointer)
    run_program(program, instruction_pointer)

  end

  def at_index(list, index) do
    List.pop_at(list, index) |> elem(0)
  end

  def perform_operation(%{opcode: :add, params: params }, program, instruction_pointer) do
    [param1, param2, address ] = params
    {
      store_value(program, address |> elem(0), resolve_value(program, param1) + resolve_value(program, param2)),
      instruction_pointer + 1 + Enum.count(params)
    }
  end

  def perform_operation(%{opcode: :multiply, params: params }, program, instruction_pointer) do
    [param1, param2, address] = params
    { store_value(program, address |> elem(0) , resolve_value(program, param1) * resolve_value(program, param2)),
      instruction_pointer + 1 + Enum.count(params)
    }

  end

  def perform_operation(%{opcode: :output, params: params }, program, instruction_pointer) do
    [param1] = params
    IO.puts(resolve_value(program, param1))
    {
      program,
      instruction_pointer + 1 + Enum.count(params)
    }
  end

  def perform_operation(%{opcode: :input, params: params }, program, instruction_pointer) do
    [address] = params
    input_value = IO.gets "Program Input:"
    input_value = input_value |> Integer.parse() |> elem(0)
    {
      store_value(program, address |> elem(0) , input_value),
      instruction_pointer + 1 + Enum.count(params)
    }

  end

  def perform_operation(%{opcode: :jump_if_true, params: params }, program, instruction_pointer) do
    [param1,param2] = params

    val1 = resolve_value(program, param1)

    IO.inspect(["jit", val1])
    if val1 != 0 do
      {
        program,
        resolve_value(program, param2)
      }
    else
      {
        program,
        instruction_pointer + 1 + Enum.count(params)
      }
    end

  end

  def perform_operation(%{opcode: :jump_if_false, params: params }, program, instruction_pointer) do
    [param1,param2] = params

    val1 = resolve_value(program, param1)

    IO.inspect(["jif", val1])
    if val1 == 0 do
      {
        program,
        resolve_value(program, param2)
      }
    else
      {
        program,
        instruction_pointer + 1 + Enum.count(params)
      }
    end

  end

  def perform_operation(%{opcode: :less_than, params: params }, program, instruction_pointer) do
    [param1,param2,address] = params

    val1 = resolve_value(program, param1)
    val2 = resolve_value(program, param2)
    IO.inspect(["lt", val1, val2])
    if val1 < val2 do
      {

        store_value(program, address |> elem(0), 1),
        instruction_pointer + 1 + Enum.count(params)
      }
    else
      {

        store_value(program, address |> elem(0), 0),
        instruction_pointer + 1 + Enum.count(params)
      }
    end
  end

  def perform_operation(%{opcode: :equals, params: params }, program, instruction_pointer) do
    [param1,param2,address] = params

    val1 = resolve_value(program, param1)
    val2 = resolve_value(program, param2)

    IO.inspect(["eq", val1, val2])
    if val1 == val2 do
      {

        store_value(program, address |> elem(0), 1),
        instruction_pointer + 1 + Enum.count(params)
      }
    else
      {

        store_value(program, address |> elem(0), 0),
        instruction_pointer + 1 + Enum.count(params)
      }
    end
  end

  def perform_operation(%{opcode: :output, params: params }, program, instruction_pointer) do
    [param1] = params
    IO.puts(resolve_value(program, param1))
    {
      program,
      instruction_pointer + 1 + Enum.count(params)
    }
  end

  def perform_operation(%{opcode: :halt, params: _params }, program, instruction_pointer) do
  {{:halt, program}, instruction_pointer}
  end

  def resolve_value(program, param) do
    case param |> elem(1) do
      :immediate -> param |> elem(0)
      :position -> List.pop_at(program, param |> elem(0)) |> elem(0)
    end
  end

  def store_value(program, address, value) do
    List.replace_at(program, address, value)
  end



end
