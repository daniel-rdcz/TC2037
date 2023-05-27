defmodule ArithmeticLexer do
  defstruct func: nil, initial_state: nil, accept_states: nil

  def transition_fn(state, char) do
    case state do
      :start ->
        case char do
          _ when is_whitespace(char) -> {:start, false}
          _ when is_alpha(char) or char == "_" -> {:var, :start}
          _ when String.to_integer(char) != :error -> {:int, :start}
          _ when char == "(" -> {:open_par, :start}
          _ when char == "+" or char == "-" -> {:sign, :start}
          _ -> {:inv, false}
        end

      :int ->
        case char do
          _ when String.to_integer(char) != :error -> {:int, false}
          _ when is_whitespace(char) -> {:spa, :int}
          _ when char == "+" or char == "-" or char == "*" or char == "/" or char == "=" or char == "^" -> {:op, :int}
          _ when char == ")" -> {:close_par, :int}
          _ -> {:inv, false}
        end

      :float ->
        case char do
          _ when String.to_float(char) != :error -> {:float, false}
          _ when is_whitespace(char) -> {:spa, :float}
          _ when char == "+" or char == "-" or char == "*" or char == "/" or char == "=" or char == "^" -> {:op, :float}
          _ when char == ")" -> {:close_par, :float}
          _ -> {:inv, false}
        end

      :spa ->
        case char do
          _ when is_whitespace(char) -> {:spa, false}
          _ when is_alpha(char) or char == "_" -> {:var, false}
          _ when String.to_integer(char) != :error -> {:int, false}
          _ when char == "(" -> {:open_par, false}
          _ when char == "+" or char == "-" -> {:sign, false}
          _ -> {:inv, false}
        end

      :sign ->
        case char do
          _ when String.to_integer(char) != :error -> {:int, :sign}
          _ when is_whitespace(char) -> {:spa, :sign}
          _ -> {:inv, false}
        end

      :var ->
        case char do
          _ when is_alpha(char) or char == "_" -> {:var, false}
          _ when String.to_integer(char) != :error -> {:var, false}
          _ when is_whitespace(char) -> {:spa, :var}
          _ when char == "+" or char == "-" or char == "*" or char == "/" or char == "=" or char == "^" -> {:op, :var}
          _ when char == ")" -> {:close_par, :var}
          _ -> {:inv, false}
        end

      :open_var ->
        case char do
          _ when is_alpha(char) or char == "_" -> {:var, :open_var}
          _ when String.to_integer(char) != :error -> {:var, :open_var}
          _ when is_whitespace(char) -> {:parenthesis_spa, :open_var}
          _ when char == "+" or char == "-" -> {:sign, :open_var}
          _ when char == ")" -> {:close_par, :open_var}
          _ -> {:inv, false}
        end

      :op ->
        case char do
          _ when is_whitespace(char) -> {:op_spa, :op}
          _ when is_alpha(char) or char == "_" -> {:var, :op}
          _ when String.to_integer(char) != :error -> {:int, :op}
          _ when char == "+" or char == "-" -> {:sign, :op}
          _ when char == "(" -> {:open_par, :op}
          _ -> {:inv, false}
        end

      :op_spa ->
        case char do
          _ when is_whitespace(char) -> {:op_spa, false}
          _ when is_alpha(char) or char == "_" -> {:var, false}
          _ when String.to_integer(char) != :error -> {:int, false}
          _ when char == "(" -> {:open_par, false}
          _ when char == "+" or char == "-" -> {:sign, false}
          _ -> {:inv, false}
        end

      :close_par ->
        case char do
          _ when is_whitespace(char) -> {:parenthesis_spa, false}
          _ when char == "+" or char == "-" -> {:sign, :close_par}
          _ when is_alpha(char) or char == "_" -> {:var, :close_par}
          _ -> {:inv, false}
        end

      _ -> {:inv, false}
    end
  end

  def evaluate_dfa(dfa, input) do
    tokens = String.graphemes(input) |> Enum.reverse() |> evaluate_dfa(dfa.func, dfa.initial_state, [])
    Enum.each(tokens, fn [value, token] ->
      IO.puts("#{value} -> #{token}")
    end)
  end

  def evaluate_dfa(_, _, tokens), do: tokens

  def evaluate_dfa(transition_fn, state, tokens) do
    case IO.getc(:standard_io) do
      {char, _} ->
        {new_state, token_found} = transition_fn.(state, char)
        evaluate_dfa(transition_fn, new_state, if (token_found), do: [List.insert(tokens, [List.to_string(Enum.reverse(value)), token_found])], else: tokens)

      _ -> tokens
    end
  end

  defp is_whitespace(char) do
    String.match?(char, ~r/\s/)
  end
end
