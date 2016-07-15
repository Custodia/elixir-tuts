defmodule Todo.List.CsvImporterTest do
  use ExUnit.Case

  test "Importing a todo list from a file works" do
    file = "test/fixtures/csv/todos.csv"

    todo_list = Todo.List.CsvImporter.import! file

    should_be = Todo.List.new([
        %{ date: {"2013", "12", "19"}, title: "Dentist"},
        %{ date: {"2013", "12", "20"}, title: "Shopping"},
        %{ date: {"2013", "12", "19"}, title: "Movies"},
      ])

    assert todo_list == should_be

  end

  test "Importing should throw a error if the file is not found" do
    catch_error Todo.List.CsvImporter.import! "nonexistant"
  end

  test "Importing should throw a error if the file is not in correct format" do
    invalid_file = "test/fixtures/csv/invalid.csv"

    catch_error Todo.List.CsvImporter.import! invalid_file
  end
end
