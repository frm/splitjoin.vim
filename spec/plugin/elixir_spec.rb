require 'spec_helper'

describe "elixir" do
  let(:filename) { 'test.ex' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
    # necessary otherwise elixir files are opened as euphoria
    vim.command('au BufRead,BufNewFile *.ex set filetype=elixir')
  end

  specify "if-clauses" do
    set_file_contents <<~EOF
      if 6 * 9 == 42, do: "the answer"
    EOF

    vim.command('setlocal indentkeys+==after,=catch,=do,=else,=end,=rescue,')
    vim.command('setlocal indentkeys+=*<Return>,=->,=\|>,=<>,0},0],0)')

    require 'pry'; binding.pry
    split

    assert_file_contents <<~EOF
      if 6 * 9 == 42 do
        "the answer"
      end
    EOF

    vim.search 'if'
    join

    assert_file_contents <<~EOF
      if 6 * 9 == 42, do: "the answer"
    EOF
  end

  specify "function definitions" do
    set_file_contents <<~EOF
      def the_answer?(n, y), do: n * y == 42
    EOF

    split

    assert_file_contents <<~EOF
      def the_answer?(n, y) do
        n * y == 42
      end
    EOF

    vim.search 'def'
    join

    assert_file_contents <<~EOF
      def the_answer?(n, y), do: n * y == 42
    EOF
  end
end
