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
      color: #3142ff
    }
    .comentario{
      color: #31b752
    }
    .variable{
      color: #ffffff
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
    .function-input{
      color: #6af9f9
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
      state == :espacio_function_input -> " "
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
      state == :recibers_function_input -> "<span class=\"recibers\">#{token}</span>"
      state == :coma_function_input -> "<span class=\"punctuation\">#{token}</span>"
      state == :function_input -> "<span class=\"function-input\">#{token}</span>"
      state == :if -> "<span class=\"reserved-word-3\">#{token}</span>"
      state == :else -> "<span class=\"reserved-word-3\">#{token}</span>"
      state == :elif -> "<span class=\"reserved-word-3\">#{token}</span>"
      state == :for -> "<span class=\"reserved-word-3\">#{token}</span>"
      state == :in -> "<span class=\"reserved-word-3\">#{token}</span>"
      state == :return -> "<span class=\"reserved-word-3\">#{token}</span>"
      state == :True -> "<span class=\"reserved-word-2\">#{token}</span>"
      state == :False -> "<span class=\"reserved-word-2\">#{token}</span>"
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
      #palabra clave false
      state == :F and char == "a" -> {:Fa, false}
      state == :F and is_variable?(char) -> {:variable, false}
      state == :Fa and char == "l" -> {:Fal, false}
      state == :Fa and is_variable?(char) -> {:variable, false}
      state == :Fal and char == "s" -> {:Fals, false}
      state == :Fal and is_variable?(char) -> {:variable, false}
      state == :Fals and char == "e" -> {:False, false}
      state == :False and is_variable?(char) -> {:variable, false}
      state == :False and char == " " -> {:espacio, true}
      state == :False and char == "#" -> {:comentario, true}
      state == :False and is_recibers?(char) -> {:recibers, true}
      #palabra clave true
      state == :T and char == "r" -> {:Tr, false}
      state == :T and is_variable?(char) -> {:variable, false}
      state == :Tr and char == "u" -> {:Tru, false}
      state == :Tr and is_variable?(char) -> {:variable, false}
      state == :Tru and char == "e" -> {:True, false}
      state == :True and is_variable?(char) -> {:variable, false}
      state == :True and char == " " -> {:espacio, true}
      state == :True and char == "#" -> {:comentario, true}
      state == :True and is_recibers?(char) -> {:recibers, true}
      #Palabra clave from
      state == :f and char == "r" -> {:fr, false}
      state == :fr and char == "o" -> {:fro, false}
      state == :fr and is_variable?(char) -> {:variable, false}
      state == :fro and char == "m" -> {:from, false}
      state == :fro and is_variable?(char) -> {:variable, false}
      state == :from and is_variable?(char) -> {:variable_lib, true}
      state == :from and char == " " -> {:espacio_lib, true}
      state == :from and char == "#" -> {:comentario, true}
      #Palabra clave import
      state == :i and char == "m" -> {:im, false}
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
      state == :c and is_variable?(char) -> {:variable, false}
      state == :cl and char == "a" -> {:cla, false}
      state == :cl and is_variable?(char) -> {:variable, false}
      state == :cla and char == "s" -> {:clas, false}
      state == :cla and is_variable?(char) -> {:variable, false}
      state == :clas and char == "s" -> {:class, false}
      state == :class and is_variable?(char) -> {:variable, true}
      state == :class and char == " " -> {:espacio_class, true}
      state == :class and char == "#" -> {:comentario, true}
      #Palabra clave def
      state == :d and char == "e" -> {:de, false}
      state == :d and is_variable?(char) -> {:variable, false}
      state == :de and char == "f" -> {:def, false}
      state == :de and is_variable?(char) -> {:variable, false}
      state == :def and char == " " -> {:espacio_func_name, true}
      state == :def and is_variable?(char) -> {:func_name, true}
      #palabra clave if
      state == :i and char == "f" -> {:if, false}
      state == :if and char == " " -> {:espacio, true}
      state == :i and char == " " -> {:espacio, false}
      state == :if and is_variable?(char) -> {:variable, false}
      #palabra clave else
      state == :e and char == "l" -> {:el, false}
      state == :e and is_variable?(char) -> {:variable, false}
      state == :el and char == "s" -> {:els, false}
      state == :els and char == "e" -> {:else, false}
      state == :else and is_variable?(char) -> {:variable, false}
      state == :else and char == " " -> {:espacio, true}
      state == :else and char == ":" -> {:double_dots, true}
      #palabra clave elif
      state == :e and char == "l" -> {:el, false}
      state == :e and is_variable?(char) -> {:variable, false}
      state == :el and char == "i" -> {:eli, false}
      state == :el and is_variable?(char) -> {:variable, false}
      state == :eli and char == "f" -> {:elif, false}
      state == :elif and char == " " -> {:espacio, true}
      state == :elif and is_variable?(char) -> {:variable, false}
      #palabra clave for
      state == :f and char == "o" -> {:fo, false}
      state == :f and is_variable?(char) -> {:variable, false}
      state == :fo and char == "r" -> {:for, false}
      state == :fo and is_variable?(char) -> {:variable, false}
      state == :for and is_variable?(char) -> {:variable, false}
      state == :for and char == " " -> {:espacio, true}
      #palabra clave in
      state == :i and char == "n" -> {:in, false}
      state == :i and is_variable?(char) -> {:variable, false}
      state == :in and is_variable?(char) -> {:variable, false}
      state == :in and char == " " -> {:espacio, true}
      #palabra clave return
      state == :r and char == "e" -> {:re, false}
      state == :r and is_variable?(char) -> {:variable, false}
      state == :re and char == "t" -> {:ret, false}
      state == :re and is_variable?(char) -> {:variable, false}
      state == :ret and char == "u" -> {:retu, false}
      state == :ret and is_variable?(char) -> {:variable, false}
      state == :retu and char == "r" -> {:retur, false}
      state == :retu and is_variable?(char) -> {:variable, false}
      state == :retur and char == "n" -> {:return, false}
      state == :return and is_variable?(char) -> {:variable, false}
      state == :return and char == " " -> {:espacio, true}
      #start
      state == :start and char == "f" -> {:f, false}
      state == :start and char == "F" -> {:F, false}
      state == :start and char == "T" -> {:T, false}
      state == :start and char == "d" -> {:d, false}
      state == :start and char == "i" -> {:i, false}
      state == :start and char == "a" -> {:a, false}
      state == :start and char == "c" -> {:c, false}
      state == :start and char == "w" -> {:w, false}
      state == :start and char == "e" -> {:e, false}
      state == :start and char == "r" -> {:r, false}
      state == :start and char == "f" -> {:f, false}
      state == :start and is_number?(char) -> {:number, false}
      state == :start and char == "\n" -> {:salto, false}
      state == :start and char == " " -> {:espacio, false}
      state == :start and char == "#" -> {:comentario, false}
      state == :start and char ==  "\"" -> {:comillas, false}
      state == :start and char == "\'" -> {:comillas, false}
      state == :start and is_variable?(char) -> {:variable, false}
      state == :start and is_operador?(char) -> {:operador, false}
      state == :start and is_recibers?(char) -> {:recibers, false}
      #comentario
      state == :comentario and char == "\n" -> {:salto, true}
      state == :comentario and
        (char == " " or char == "#" or is_variable?(char)
        or is_operador?(char) or is_number?(char)
        or is_recibers?(char) or is_string?(char)) -> {:comentario, false}
      #espacio general
      state == :espacio and char == " " -> {:espacio, false}
      state == :espacio and char == "w" -> {:w, false}
      state == :espacio and char == "d" -> {:d, false}
      state == :espacio and char == "c" -> {:c, false}
      state == :espacio and char == "i" -> {:i, false}
      state == :espacio and char == "f" -> {:f, false}
      state == :espacio and char == "e" -> {:e, false}
      state == :espacio and char == "r" -> {:r, false}
      state == :espacio and char == "F" -> {:F, false}
      state == :espacio and char == "T" -> {:T, false}
      state == :espacio and char == "\n" -> {:salto, false}
      state == :espacio and char == "#" -> {:comentario, false}
      state == :espacio and is_variable?(char) -> {:variable, false}
      state == :espacio and is_operador?(char) -> {:operador, false}
      state == :espacio and is_number?(char) -> {:number, false}
      state == :espacio and is_recibers?(char) -> {:recibers, true}
      state == :espacio and char == "," -> {:coma, true}
      state == :espacio and (char == "\'" or char == "\"") -> {:comillas, true}
      #espacio resp
      state == :espacio_resp and char == " " -> {:espacio_resp, true}
      state == :espacio_resp and char == "F" -> {:F, false}
      state == :espacio_resp and char == "T" -> {:T, false}
      state == :espacio_resp and char == "\n" -> {:salto, false}
      state == :espacio_resp and char == "#" -> {:comentario, false}
      state == :espacio_resp and char == "'" -> {:string, false}
      state == :espacio_resp and is_variable?(char) -> {:variable, false}
      state == :espacio_resp and is_operador?(char) -> {:operador, true}
      state == :espacio_resp and is_number?(char) -> {:number, false}
      state == :espacio_resp and is_recibers?(char) -> {:recibers, false}
      state == :espacio_resp and char == "," -> {:coma, true}
      state == :espacio and (char == "\'" or char == "\"") -> {:comillas, true}
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
      #espacio function input
      state == :espacio_function_input and char == " " -> {:espacio_function_input, false}
      state == :espacio_function_input and is_variable?(char) -> {:function_input, true}
      state == :espacio_function_input and is_recibers?(char) -> {:recibers_input, true}
      state == :espacio_function_input and char == "#" -> {:comentario, true}
      #espacio func name
      state == :espacio_func_name and char == " " -> {:espacio_func_name, false}
      state == :espacio_func_name and is_variable?(char) -> {:func_name, true}
      state == :espacio_func_name and is_recibers?(char) -> {:recibers, true}
      #func name
      state == :func_name and is_variable?(char) -> {:func_name, false}
      state == :func_name and is_recibers?(char) -> {:recibers_function_input, true}
      state == :func_name and char == " " -> {:espacio_func_name, true}
      #recibers
      state == :recibers and is_recibers?(char) -> {:recibers, false}
      state == :recibers and char == " " -> {:espacio, true}
      state == :recibers and char == "\n" -> {:salto, true}
      state == :recibers and char == "#" -> {:comentario, true}
      state == :recibers and is_number?(char) -> {:number, true}
      state == :recibers and (char == "\'" or char == "\"") -> {:comillas, true}
      state == :recibers and is_variable?(char) -> {:variable, true}
      state == :recibers and ":" -> {:double_dots, true}
      #recibers class
      state == :recibers_class and is_recibers?(char) -> {:recibers_class, true}
      state == :recibers_class and is_variable?(char) -> {:class_input, false}
      state == :recibers_class and char == ":" -> {:double_dots, false}
      #recibers function input
      state == :recibers_function_input and is_recibers?(char) -> {:recibers_function_input, true}
      state == :recibers_function_input and is_variable?(char) -> {:function_input, false}
      state == :recibers_function_input and char == ":" -> {:double_dots, false}
      #coma
      state == :coma and char == "," -> {:coma, true}
      state == :coma and char == " " -> {:espacio, false}
      state == :coma and is_variable?(char) -> {:variable, true}
      state == :coma and is_number?(char) -> {:number, false}
      state == :coma and char == "\n" -> {:salto, true}
      #coma func input
      state == :coma_function_input and char == "," -> {:coma_function_input, true}
      state == :coma_function_input and char == " " -> {:espacio_function_input, false}
      state == :coma_function_input and is_variable?(char) -> {:variable_function_input, true}
      state == :coma_function_input and is_number?(char) -> {:number_function_input, false}
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
      #class name
      state == :class_name and is_variable?(char) -> {:class_name, false}
      state == :class_name and char == " " -> {:espacio_class, true}
      state == :class_name and is_recibers?(char) -> {:recibers_class, true}
      state == :class_name and char == ":" -> {:double_dots, true}
      #class input
      state == :class_input and is_variable?(char) -> {:class_input, false}
      state == :class_input and char == " " -> {:espacio_class, true}
      state == :class_input and is_recibers?(char) -> {:recibers_class, true}
      state == :class_input and char == "," -> {:coma_class, true}
      #func input
      state == :function_input and is_variable?(char) -> {:function_input, false}
      state == :function_input and char == " " -> {:espacio_function_input, true}
      state == :function_input and is_recibers?(char) -> {:recibers_function_input, true}
      state == :function_input and char == "," -> {:coma_function_input, true}
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
      state == :variable and is_recibers?(char) -> {:recibers, true}
      state == :variable and is_operador?(char) -> {:operador, true}
      state == :variable and is_number?(char) -> {:number, true}
      state == :variable and char == ":" -> {:double_dots, true}
      state == :variable and char == "," -> {:coma, true}
      state == :variable and (char == "\'" or char == "\"") -> {:comillas, true}
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
      state == :operador and is_number?(char) -> {:number, false}
      state == :operador and char == "\n" -> {:salto, true}
      state == :operador and (char == "\'" or char == "\"") -> {:comillas, true}
      #number
      state == :number and is_number?(char) -> {:number, false}
      state == :number and char == " " -> {:espacio, true}
      state == :number and is_recibers?(char) -> {:recibers, true}
      state == :number and char == "," -> {:coma, true}
      state == :number and char == "\n" -> {:salto, true}
      state == :number and char == ":" -> {:double_dots, true}
      state == :number and char == "#" -> {:comentario, true}
      state == :number and char == "." -> {:dot, true}
      state == :number and is_operador?(char) -> {:operador, true}
      state == :number and is_variable?(char ) -> {:variable, true}
      #comillas
      state == :comillas and char == " " -> {:espacio, true}
      state == :comillas and char == "," -> {:coma, true}
      state == :comillas and char == ":" -> {:double_dots, true}
      state == :comillas and char == "." -> {:dot, true}
      state == :comillas and is_string?(char) -> {:string, true}
      state == :comillas and (char == "\'" or char == "\"") -> {:comillas, false}
      state == :comillas and is_recibers?(char) -> {:recibers, true}
      state == :comillas and char == "\n" -> {:salto, true}
      #string
      state == :string and is_string?(char) -> {:string, false}
      state == :string and (char == "\'" or char == "\"") -> {:comillas, true}
      state == :string and char == "\n" -> {:salto, true}
      state == :string and char == " " -> {:espacio, true}
      state == :string and is_recibers?(char) -> {:recibers, true}
      #dot
      state == :dot and is_variable?(char) -> {:variable, false}
      state == :dot and char == "." -> {:dot, true}
      #double dots
      state == :double_dots and char == "#" -> {:comentario, true}
      state == :double_dots and char == "'" -> {:string, true}
      state == :double_dots and char == " " -> {:espacio, true}
      state == :double_dots and char == "\n" -> {:salto, true}
      state == :double_dots and char == ":" -> {:double_dots, true}
      state == :double_dots and is_variable?(char) -> {:variable, true}
      state == :double_dots and "," -> {:coma, true}
      #salto
      state == :salto and char == "#" -> {:comentario, true}
      state == :salto and char == "\n" -> {:salto, true}
    end
  end

  def is_variable?(char) do
    Regex.match?(~r/[a-zA-Z_&áéíóúÁÉÍÓÚ$@&~ñÑ-]/u, char)
  end
  def is_string?(char) do
  Regex.match?(~r/[a-zA-Z_+&áéíóúÁÉÍÓÚ$%@&*~ñÑ¡!:,.{}\/=^0-9 -]/u, char)
end

  def is_recibers?(char) do
    Regex.match?(~r/[(){}[\]]/u, char)
  end
  def is_number?(char) do
    Regex.match?(~r/^[0-9]/, char)
  end
  def is_operador?(char) do
    char in ["=", ">", "<", "/", "*", "+", "%", "!"]
  end
end

start_time_static = :os.system_time(:millisecond)

Py.writter("../Python/Files/base-file.py", "highlighted-sintaxis1.html")
Py.writter("../Python/Files/base-file2.py", "highlighted-sintaxis2.html")
Py.writter("../Python/Files/base-file3.py", "highlighted-sintaxis3.html")

end_time_static = :os.system_time(:millisecond)
execution_time_static = end_time_static - start_time_static

IO.puts("Tiempo de ejecucion estatica: #{execution_time_static} milisegundos")


start_time_parallel = :os.system_time(:millisecond)

{:ok, files} = File.ls("../Python/Files")
files
  |> Enum.map(&Task.async(fn -> Py.writter("../Python/Files/#{&1}", "#{&1}.html") end))
  |> Enum.map(&Task.await(&1))

end_time_parallel = :os.system_time(:millisecond)
execution_time_parallel = end_time_parallel - start_time_parallel

IO.puts("Tiempo de ejecucion paralelo: #{execution_time_parallel} milisegundos")

IO.puts("Speedup: #{execution_time_static / execution_time_parallel}")
