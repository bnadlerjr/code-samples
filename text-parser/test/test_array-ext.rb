require "test/unit"
require "core-ext/array"

class TestParserArrayExt < Test::Unit::TestCase
  def setup
    @example = [1, 2, 3].extend(ArrayExtensions)
  end

  def test_should_convert_array_to_hash
    expected = { :foo => 1, :bar => 2, :baz => 3 }
    assert_equal(expected, @example.to_hash(%w[foo bar baz]))
  end
  
  def test_should_raise_exception_on_different_lengths
    assert_raises ArgumentError do
      @example.to_hash(%[foo bar])
    end
  end
end
