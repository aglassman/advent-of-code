defmodule AocElixir2 do
  @moduledoc """
  Documentation for AocElixir2.
  """

  defmodule Op do
    defstruct opcode: :halt, addr1: 0, addr2: 0, addr3: 0

    def matchOpcode(intOp) do
      case intOp do
        1 -> :add
        2 -> :multiply
        3 -> :input
        4 -> :output
        99 -> :halt
        _ -> :halt
      end
    end

    def fromProgram(program) do

      opcode = List.pop_at(program,0)|> elem(0) |> matchOpcode

      case opcode do
        :halt ->
          %Op{}
        _ ->
          %Op{
             opcode: opcode,
             addr1: List.pop_at(program,1)|> elem(0),
             addr2: List.pop_at(program,2)|> elem(0),
             addr3: List.pop_at(program,3)|> elem(0),
           }
      end
    end
  end

  def outputForInput(program, input) do
    program
    |> List.replace_at(1,input.noun)
    |> List.replace_at(2,input.verb)
    |> AocElixir2.runProgram(0)
    |> List.first()
  end

  def runProgram(program, offset) do
    op = program
    |> Enum.chunk_every(4)
    |> Enum.drop(offset)
    |> List.first()
    |> Op.fromProgram()

    case op.opcode do
      :halt -> program
      _ -> runProgram(performOperation(op, program), offset + 1)
    end


  end

  def performOperation(operation, program) do

    val1 = fetchValue(program, operation.addr1)
    val2 = fetchValue(program, operation.addr2)

    case operation.opcode do
      :halt -> program
      :add -> storeValue(program, operation.addr3, val1 + val2)
      :input ->
      :output ->
      :multiply -> storeValue(program, operation.addr3, val1 * val2)
    end

  end

  def fetchValue(program, address) do
    List.pop_at(program, address) |> elem(0)
  end

  def storeValue(program, address, value) do
    List.replace_at(program, address, value)
  end

end
