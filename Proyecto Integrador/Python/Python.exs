defmodule Py do
  def writter(in_filename, out_filename) do
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
     .reserved-word-1{
      color: #ab77c9
     }
     .reserved-word-3{
      color: #ab77c9
     }

     .variable{
      color: #5dbcf8
     }

     .punctuation {
      color: LightGray;
    }
     .variable-lib {
      color: LightGray;
    }

    .class-name{
      color: #38d953
    }
    .class-input{
      color: #38d953
    }

    .recibers{
      color: #e8e35f
    }

    .function-name{
      color: #e8e35f
    }

    .reserved-word-2{
      color: #1f2dca
    }
    .comentario{
      color: #31b752
    }
    .variable{
      color: #7ae2ff
    }
    .operador{
      color: #e84e4e
    }
    .number{
      color: #54cc50
    }
    .string{
      color: #e8964e
    }

    """
    File.write(file_path, css)
  end

  def evaluateLine(line) do
    chars = String.graphemes(line)
    recursion_function(chars, [], [], :start)
    |> Enum.reverse()
    |> Enum.join("")
  end

  defp recursion_function([head | tail], tokens, current_token, state) do
    IO.inspect(head)
    IO.inspect(state)
    IO.inspect(current_token)
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
  defp recursion_function([], tokens, current_token, _state) do
    [Enum.join(current_token, "") | tokens]
  end


  def classer(token, state) do
    cond do
      state == :from -> "<span class=\"reserved-word-1\">#{token}</span>"
      state == :import -> "<span class=\"reserved-word-1\">#{token}</span>"
      state == :as -> "<span class=\"reserved-word-1\">#{token}</span>"
      state == :variable_lib -> "<span class=\"variable-lib\">#{token}</span>"
      state == :variable -> "<span class=\"variable\">#{token}</span>"
      state == :espacio_lib -> " "
      state == :espacio_class -> " "
      state == :espacio_func_name -> " "
      state == :espacio_func_input -> " "
      state == :espacio_resp -> " "
      state == :coma_class -> "<span class=\"punctuation\">#{token}</span>"
      state == :coma_func -> "<span class=\"punctuation\">#{token}</span>"
      state == :coma -> "<span class=\"punctuation\">#{token}</span>"
      state == :coma_lib -> "<span class=\"punctuation\">#{token}</span>"
      state == :class -> "<span class=\"reserved-word-2\">#{token}</span>"
      state == :class_name -> "<span class=\"class-name\">#{token}</span>"
      state == :recibers_class -> "<span class=\"recibers\">#{token}</span>"
      state == :recibers_func -> "<span class=\"recibers\">#{token}</span>"
      state == :recibers -> "<span class=\"recibers\">#{token}</span>"
      state == :salto -> "\n"
      state == :double_dots -> "<span class=\"punctuation\">#{token}</span>"
      state == :class_input -> "<span class=\"class-input\">#{token}</span>"
      state == :def -> "<span class=\"reserved-word-2\">#{token}</span>"
      state == :func_name -> "<span class=\"function-name\">#{token}</span>"
      state == :func_input -> "<span class=\"variable\">#{token}</span>"
      state == :espacio -> " "
      state == :comentario -> "<span class=\"comentario\">#{token}</span>"
      state == :operador -> "<span class=\"operador\">#{token}</span>"
      state == :dot -> "<span class=\"punctuation\">#{token}</span>"
      state == :number -> "<span class=\"number\">#{token}</span>"
      state == :string -> "<span class=\"string\">#{token}</span>"
      state == :comillas -> "<span class=\"string\">#{token}</span>"
      state == :while -> "<span class=\"reserved-word-3\">#{token}</span>"

    end
  end

  def stepper(state, char) do
    cond do
      #Palabra clave While
      state == :w and char == "h" -> {:wh, false}
      state == :w and is_variable?(char) -> {:variable, false}
      state == :wh and char == "i" -> {:whi, false}
      state == :wh and is_variable?(char) -> {:variable, false}
      state == :whi and char == "l" -> {:whil, false}
      state == :whi and is_variable?(char) -> {:variable, false}
      state == :whil and char == "e" -> {:while, false}
      state == :whil and is_variable?(char) -> {:variable, false}
      state == :while and is_variable?(char) -> {:variable, false}
      state == :while and char == " " -> {:espacio, true}
      state == :while and char == "#" -> {:comentario, true}
      #Palabra clave from
      state == :f and char == "r" -> {:fr, false}
      state == :f and is_variable?(char) -> {:variable, false}
      state == :fr and char == "o" -> {:fro, false}
      state == :fr and is_variable?(char) -> {:variable, false}
      state == :fro and char == "m" -> {:from, false}
      state == :fro and is_variable?(char) -> {:variable, false}
      state == :from and is_variable?(char) -> {:variable_lib, true}
      state == :from and char == " " -> {:espacio_lib, true}
      state == :from and char == "#" -> {:comentario, true}
      #Palabra clave import
      state == :i and char == "m" -> {:im, false}
      state == :i and is_variable?(char) -> {:variable, false}
      state == :im and char == "p" -> {:imp, false}
      state == :im and is_variable?(char) -> {:variable, false}
      state == :imp and char == "o" -> {:impo, false}
      state == :imp and is_variable?(char) -> {:variable, false}
      state == :impo and char == "r" -> {:impor, false}
      state == :impo and is_variable?(char) -> {:variable, false}
      state == :impor and char == "t" -> {:import, false}
      state == :impor and is_variable?(char) -> {:variable, false}
      state == :import and is_variable?(char) -> {:variable_lib, true}
      state == :import and char == " " -> {:espacio_lib, true}
      state == :import and char == "#" -> {:comentario, true}
      #Palabra clave as
      state == :a and char == "s" -> {:as, false}
      state == :a and is_variable?(char) -> {:variable_lib, false}
      state == :as and is_variable?(char) -> {:variable_lib, true}
      state == :as and char == " " -> {:espacio_lib, true}
      state == :as and char == "#" -> {:comentario, true}
      #Palabra clave class
      state == :c and char == "l" -> {:cl, false}
      state == :cl and char == "a" -> {:cla, false}
      state == :cla and char == "s" -> {:clas, false}
      state == :clas and char == "s" -> {:class, false}
      state == :class and is_variable?(char) -> {:variable_lib, true}
      state == :class and char == " " -> {:espacio_class, true}
      state == :class and char == "#" -> {:comentario, true}
      #Palabra clave def
      state == :d and char == "e" -> {:de, false}
      state == :de and char == "f" -> {:def, false}
      state == :def and char == " " -> {:espacio_func_name, true}
      state == :def and is_variable?(char) -> {:func_name, true}
      #start
      state == :start and char == "f" -> {:f, false}
      state == :start and char == "d" -> {:d, false}
      state == :start and char == "i" -> {:i, false}
      state == :start and char == "a" -> {:a, false}
      state == :start and char == "c" -> {:c, false}
      state == :start and char == "\n" -> {:salto, false}
      state == :start and char == " " -> {:espacio, false}
      state == :start and char == "#" -> {:comentario, false}
      state == :start and is_variable?(char) -> {:variable, false}
      #comentario
      state == :comentario and char == "\n" -> {:salto, true}
      state == :comentario and char == " " -> {:comentario, false}
      state == :comentario and char == "#" -> {:comentario, false}
      state == :comentario and is_variable?(char) -> {:comentario, false}
      state == :comentario and is_number?(char) -> {:comentario, false}
      #espacio general
      state == :espacio and char == " " -> {:espacio, true}
      state == :espacio and char == "w" -> {:w, false}
      state == :espacio and char == "d" -> {:d, false}
      state == :espacio and char == "c" -> {:c, false}
      state == :espacio and char == "\n" -> {:salto, false}
      state == :espacio and char == "#" -> {:comentario, false}
      state == :espacio and is_variable?(char) -> {:variable, false}
      state == :espacio and is_operador?(char) -> {:operador, false}
      state == :espacio and is_number?(char) -> {:number, false}
      state == :espacio and is_recibers?(char) -> {:recibers, true}
      state == :espacio and char == "," -> {:coma, true}
      #espacio resp
      state == :espacio_resp and char == " " -> {:espacio_resp, true}
      state == :espacio_resp and char == "\n" -> {:salto, false}
      state == :espacio_resp and char == "#" -> {:comentario, false}
      state == :espacio_resp and is_variable?(char) -> {:variable, false}
      state == :espacio_resp and is_operador?(char) -> {:operador, false}
      state == :espacio_resp and is_number?(char) -> {:number, false}
      state == :espacio_resp and is_recibers?(char) -> {:recibers, true}
      state == :espacio_resp and char == "," -> {:coma, true}
      #espacio_lib
      state == :espacio_lib and char == " " -> {:espacio_lib, false}
      state == :espacio_lib and char == "i" -> {:i, false}
      state == :espacio_lib and char == "a" -> {:a, false}
      state == :espacio_lib and char == "f" -> {:f, false}
      state == :espacio_lib and char == "d" -> {:d, false}
      state == :espacio_lib and is_variable?(char) -> {:variable_lib, true}
      state == :espacio_lib and char == "\n" -> {:salto, true}
      state == :espacio_lib and char == "#" -> {:comentario, true}
      #espacio class
      state == :espacio_class and char == " " -> {:espacio_class, false}
      state == :espacio_class and is_variable?(char) -> {:class_name, true}
      state == :espacio_class and is_recibers?(char) -> {:recibers_class, true}
      state == :espacio_class and char == "#" -> {:comentario, true}
      #espacio func name
      state == :espacio_func_name and char == " " -> {:espacio_func_name, false}
      state == :espacio_func_name and is_variable?(char) -> {:func_name, true}
      state == :espacio_func_name and is_recibers?(char) -> {:recibers_func, true}
      #espacio func
      state == :espacio_func_input and char == " " -> {:espacio_func_input, false}
      state == :espacio_func_input and char == "," -> {:coma_func, true}
      state == :espacio_func_input and is_variable?(char) -> {:func_input, false}
      state == :espacio_func_input and is_recibers?(char) -> {:recibers_func, true}
      #func name
      state == :func_name and is_variable?(char) -> {:func_name, false}
      state == :func_name and is_recibers?(char) -> {:recibers_func, false}
      #recibers
      state == :recibers and is_recibers?(char) -> {:recibers, false}
      state == :recibers and char == " " -> {:espacio, true}
      state == :recibers and char == "\n" -> {:salto, true}
      state == :recibers and char == "#" -> {:comentario, true}
      state == :recibers and is_number?(char) -> {:number, true}
      state == :recibers and char == "\"" -> {:comillas, true}
      state == :recibers and is_variable?(char) -> {:variable, true}

      #recibers class
      state == :recibers_class and is_recibers?(char) -> {:recibers_class, true}
      state == :recibers_class and is_variable?(char) -> {:class_input, false}
      state == :recibers_class and char == ":" -> {:double_dots, false}
      #recibers func
      state == :recibers_func and is_recibers?(char) -> {:recibers_func, true}
      state == :recibers_func and is_variable?(char) -> {:func_input, true}
      state == :recibers_func and char == " " -> {:espacio_func_input, false}
      state == :recibers_func and char == ":" -> {:double_dots, false}
      state == :recibers_func and char == "\n" -> {:salto, true}
      #coma
      state == :coma and char == "," -> {:coma, true}
      state == :coma and char == " " -> {:espacio, false}
      state == :coma and is_variable?(char) -> {:variable, true}
      state == :coma and is_number?(char) -> {:number, false}
      #coma_class
      state == :coma_class and char == " " -> {:espacio_class, true}
      state == :coma_class and char == "," -> {:coma_class, true}
      state == :coma_class and is_variable?(char) -> {:class_input, true}
      #coma lib
      state == :coma_lib and char == " " -> {:espacio_lib, true}
      state == :coma_lib and char == "," -> {:coma_lib, true}
      state == :coma_lib and is_variable?(char) -> {:variable_lib, true}
      state == :coma_lib and char == "i" -> {:i, true}
      state == :coma_lib and char == "a" -> {:a, true}
      state == :coma_lib and char == "f" -> {:f, true}
      #coma func
      state == :coma_func and char == " " -> {:espacio_func_input, true}
      state == :coma_func and char == "," -> {:coma_func, false}
      state == :coma_func and is_variable?(char) -> {:func_input, true}
      #class name
      state == :class_name and is_variable?(char) -> {:class_name, false}
      state == :class_name and char == " " -> {:espacio_class, true}
      state == :class_name and is_recibers?(char) -> {:recibers_class, true}
      #class input
      state == :class_input and is_variable?(char) -> {:class_input, false}
      state == :class_input and char == " " -> {:espacio_class, true}
      state == :class_input and is_recibers?(char) -> {:recibers_class, true}
      state == :class_input and char == "," -> {:coma_class, true}
      #func input
      state == :func_input and is_variable?(char) -> {:func_input, false}
      state == :func_input and char == " " -> {:espacio_func_input, true}
      state == :func_input and is_recibers?(char) -> {:recibers_func, true}
      state == :func_input and char == "," -> {:coma_func, true}
      state == :func_input and char == "." -> {:dot_func, true}
      #variables_lib
      state == :variable_lib and is_variable?(char) -> {:variable_lib, false}
      state == :variable_lib and char == " " -> {:espacio_lib, true}
      state == :variable_lib and char == "," -> {:coma_lib, true}
      state == :variable_lib and char == "\n" -> {:salto, true}
      state == :variable_lib and char == "#" -> {:comentario, true}
      #variables
      state == :variable and is_variable?(char) -> {:variable, false}
      state == :variable and char == " " -> {:espacio, true}
      state == :variable and char == "\n" -> {:salto, true}
      state == :variable and char == "#" -> {:comentario, true}
      state == :variable and char == "." -> {:dot, true}
      state == :variable and is_recibers?(char) -> {:recibers, false}
      state == :variable and is_operador?(char) -> {:operador, true}
      state == :variable and is_number?(char) -> {:number, false}
      state == :variable and char == ":" -> {:double_dots, true}
      #variable resp
      state == :variable_resp and is_variable?(char) -> {:variable, false}
      state == :variable_resp and char == " " -> {:espacio, true}
      state == :variable_resp and char == "\n" -> {:salto, true}
      state == :variable_resp and char == "#" -> {:comentario, true}
      state == :variable_resp and char == "." -> {:dot, true}
      state == :variable_resp and is_recibers?(char) -> {:recibers_func, false}
      state == :variable_resp and is_operador?(char) -> {:operador, true}
      #operador
      state == :operador and is_operador?(char) -> {:operador, true}
      state == :operador and char == " " -> {:espacio_resp, true}
      state == :operador and is_variable?(char) -> {:variable_resp, false}
      #number
      state == :number and is_number?(char) -> {:number, false}
      state == :number and char == " " -> {:espacio, true}
      state == :number and is_recibers?(char) -> {:recibers, true}
      state == :number and char == "," -> {:coma, true}
      state == :number and char == "\n" -> {:salto, true}
      #comillas
      state == :comillas and is_string?(char) -> {:string, false}
      state == :comillas and char == "\"" -> {:comillas, false}
      state == :comillas and is_recibers?(char) -> {:recibers, true}
      #string
      state == :string and is_string?(char) -> {:string, false}
      state == :string and char == "\"" -> {:comillas, false}
      #dot
      state == :dot and is_variable?(char) -> {:variable, false}
      state == :dot and char == "." -> {:dot, true}
      #double dots
      state == :double_dots and char == "#" -> {:comentario, true}
      state == :double_dots and char == " " -> {:espacio_class, true}
      state == :double_dots and char == "\n" -> {:salto, true}
      state == :double_dots and char == ":" -> {:double_dots, true}
      #salto
      state == :salto and char == "#" -> {:comentario, true}
      state == :salto and char == "\n" -> {:salto, true}
    end
  end

  def is_variable?(char) do
    Regex.match?(~r/[a-zA-Z_+&\/áéíóúÁÉÍÓÚ$%@&*~ñÑ]/u, char)
  end
  def is_string?(char) do
    Regex.match?(~r/[a-zA-Z_+&\/áéíóúÁÉÍÓÚ$%@&*~ñÑ¡!\d :,.{}]/u, char)
  end
  def is_recibers?(char) do
    Regex.match?(~r/[(){}[\]]/u, char)
  end
  def is_number?(char) do
    Regex.match?(~r/^[0-9]/, char)
  end
  def is_operador?(char) do
    Regex.match?(~r/[+\/-=!%]/, char) && !is_number?(char) && char != ":"
  end
end
Py.writter("base-file.py", "highlighted-sintaxis.html")
