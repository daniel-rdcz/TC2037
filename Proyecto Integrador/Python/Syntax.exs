defmodule JSON do
  def readerWritter(in_filename, out_filename) do
    data =
      in_filename
      |> File.stream!()
      |> Enum.map(&evaluateLine/1)
      |> Enum.join("")

    write_html_file(out_filename, data)
    write_css_file("token_colors.css")
  end

  def write_html_file(file_path, text) do
    html = """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Resaltador de Sintaxis</title>
      <link rel="stylesheet" href="token_colors.css">
    </head>
    <body>
      <h1>Date: 2023-05-30</h1>
      <p> Created By Daniel Rodriguez, David Vieyra and Miguel Cabrera </p>
      <pre>#{text}</pre>
    </body>
    </html>
    """
    File.write(file_path, html)
  end

  def write_css_file(file_path) do
    css = """
    body {
      background-color: Black;
      color: Gray;
    }
     pre {
      font-family: Monospace;
      font-size: 20px;
    }
     h1 {
      color: Black;
      border: 4px solid red;
      background-color: Aquamarine;
      text-align: center;
    }
     .number {
      color: Lime;
    }
     .string {
      color: Yellow;
      font-style: italic;
    }
     .object-key {
      color: LightSkyBlue;
      font-weight: bold;
    }
     .reserved-word {
      font-weight: bold;
      color: SandyBrown;
    }
    .punctuation {
      color: LightGray;
    }
    """
    File.write(file_path, css)
  end

  def evaluateLine(line) do
    chars = String.graphemes(line)
    recursion_function(chars, [], [], :start)
    |> Enum.reverse() # Invertir la lista para obtener el orden correcto
    |> Enum.join("") # Unir los elementos en una cadena
  end

  defp recursion_function([], tokens, current_token, _state) do
    [Enum.join(current_token, "") | tokens]
  end
  defp recursion_function([" " | rest], tokens, current_token, state) do
    if state == :string do
      recursion_function(rest, tokens, [" " | current_token], state)
    else
      recursion_function(rest, [" " | tokens], [], state)
    end
  end
  defp recursion_function(["\n" | rest], tokens, current_token, state) do
    tokens = [classer(Enum.reverse(current_token) |> Enum.join(""), state) | tokens]
    recursion_function(rest, ["\n" | tokens], [], state)
  end
  defp recursion_function([head | tail], tokens, current_token, state) do
    {new_state, token_found} = stepper(state, head)
    if token_found do
      if Enum.empty?(current_token) do
        tokens = [classer(head, state) | tokens]
        recursion_function(tail, tokens, [], new_state)
      else
        tokens = [classer(Enum.reverse(current_token) |> Enum.join(""), state) | tokens]
        recursion_function([head | tail], tokens, [], new_state)
      end
    else recursion_function(tail, tokens, [head | current_token], new_state) end
  end

  def classer(token, state) do
    cond do
      state == :t4 -> "<span class=\"reserved-word\">#{token}</span>"
      # state == :start and is_punctuation?(token) -> "<span class=\"punctuation\">#{token}</span>"
      # state == :start and is_object_key?(token) -> "<span class=\"object-key\">#{token}</span>"
      # state == :start and is_corchete?(token) -> "<span class=\"punctuation\">#{token}</span>"
      # state == :punctuation -> "<span class=\"punctuation\">#{token}</span>"
      # state == :object_key -> "<span class=\"object-key\">#{token}</span>"
      # state == :double_dots -> "<span class=\"punctuation\">#{token}</span>"
      # state == :string -> "<span class=\"string\">#{token}</span>"
      # state == :close_str -> "<span class=\"string\">#{token}</span>"
      # state == :number -> "<span class=\"number\">#{token}</span>"
      # state == :corchete -> "<span class=\"punctuation\">#{token}</span>"
      # state == :lista -> "<span class=\"punctuation\">#{token}</span>"
      # state == :f6 -> "<span class=\"reserved-word\">#{token}</span>"
      # state == :t5 -> "<span class=\"reserved-word\">#{token}</span>"

    end
  end

  def stepper(state, char) do
    cond do
      state == :start and (char == "d") -> {:t2, false}
      state == :t2 and (char == "e") -> {:t3, false}
      state == :t3 and (char == "f") -> {:t4, false}
      state == :t4 and (char == "b") -> {:punctuation, true}

      # state == :start and is_punctuation?(char) -> {:punctuation, true}
      # state == :start and is_object_key?(char) -> {:object_key, false}
      # state == :start and is_double_dots?(char) -> {:double_dots, true}
      # state == :start and is_corchete?(char) -> {:corchete, true}
      # state == :punctuation and is_punctuation?(char) -> {:punctuation, true}
      # state == :punctuation and is_double_dots?(char) -> {:double_dots, true}
      # state == :double_dots and is_comillas?(char) -> {:string, false}
      # state == :double_dots and is_double_dots?(char) -> {:double_dots, true}
      # state == :double_dots and is_punctuation?(char) -> {:punctuation, true}
      # state == :double_dots and is_comillas?(char) -> {:string, false}
      # state == :object_key and is_object_key?(char) -> {:object_key, false}
      # state == :object_key and is_punctuation?(char) -> {:punctuation, true}
      # state == :object_key and is_double_dots?(char) -> {:double_dots, true}
      # state == :string and is_string?(char) -> {:string, false}
      # state == :string and is_punctuation?(char) -> {:string, false}
      # state == :string and is_dot?(char) -> {:string, false}
      # state == :string and is_double_dots?(char) -> {:string, false}
      # state == :string and is_comillas?(char) -> {:close_str, false}
      # state == :close_str and is_punctuation?(char) -> {:punctuation, true}
      # state == :double_dots and is_number?(char) -> {:number, false}
      # state == :double_dots and is_corchete?(char) -> {:corchete, true}
      # state == :corchete and is_number?(char) -> {:number, false}
      # state == :corchete and is_punctuation?(char) -> {:punctuation, true}
      # state == :corchete and is_lista?(char) -> {:lista, true}
      # state == :punctuation and is_number?(char) -> {:number, false}
      # state == :number and is_punctuation?(char) -> {:punctuation, true}
      # state == :number and
      # state == :number and is_number?(char) -> {:number, false}
      # state == :double_dots and is_lista?(char) -> {:lista, true}
      # state == :lista and is_object_key?(char) -> {:object_key, false}
      # state == :punctuation and is_object_key?(char) -> {:object_key, false}
      # state == :number and is_dot?(char) -> {:number, false}
      # state == :f2 and (char == "a") -> {:f3, false}
      # state == :f3 and (char == "l") -> {:f4, false}
      # state == :f4 and (char == "s") -> {:f5, false}
      # state == :f5 and (char == "e") -> {:f6, false}
      # state == :f6 and is_punctuation?(char) -> {:punctuation, true}
      # state == :t2 and (char == "r") -> {:t3, false}
      # state == :t3 and (char == "u") -> {:t4, false}
      # state == :t4 and (char == "e") -> {:t5, false}
      # state == :t5 and is_punctuation?(char) -> {:punctuation, true}
      # state == :double_dots and (char == "f") -> {:f2, false}
      # state == :double_dots and (char == "t") -> {:t2, false}
    end
  end

  # def is_dot?(char) do
  #   dot_regex = ~r/[.]/
  #   Regex.match?(dot_regex, char)
  # end
  # def is_corchete?(char) do
  #   corchete_regex = ~r/[\[]/
  #   Regex.match?(corchete_regex, char)
  # end
  # def is_lista?(char) do
  #   lista_regex = ~r/[{]/
  #   Regex.match?(lista_regex, char)
  # end
  # def is_punctuation?(char) do
  #   punctuation_regex = ~r/[,;\]}()]/
  #   Regex.match?(punctuation_regex, char)
  # end
  # def is_double_dots?(char) do #quitar esto
  #   double_dots_regex = ~r/[:]/
  #   Regex.match?(double_dots_regex, char)
  # end
  # def is_comillas?(char) do
  #   str_cierre_regex = ~r/["]/
  #   Regex.match?(str_cierre_regex, char)
  # end
  # def is_object_key?(char) do
  #   object_key_regex = ~r/["a-zA-Z0-9_\- ]/
  #   Regex.match?(object_key_regex, char)
  # end
  # def is_string?(char) do
  #   string_regex = ~r/[a-zA-Z0-9_\-+&#\/]/
  #   Regex.match?(string_regex, char)
  # end
  # def is_number?(char) do
  #   int_regex = ~r/[0-9]+/
  #   Regex.match?(int_regex, char)
  # end
end
JSON.readerWritter("Pythons/example1.py", "highlighted-sintaxis.html")
