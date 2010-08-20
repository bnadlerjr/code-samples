require "test/unit"
require "parser"

class TestParser < Test::Unit::TestCase
  def setup
    @parser = Parser.new('test/samples/comma.txt')
  end
  
  def test_can_initialize
    assert_not_nil @parser.records
  end
  
  def test_should_parse_pipe_delimiter
    expected = [
      { :last_name => 'Steve', :first_name => 'Smith', :initial => 'D', 
        :gender    => 'Male',  :color      => 'Red',   
        :born_on   => Date.strptime('3-3-1985', "%m-%d-%Y") },
        
      { :last_name => 'Bonk', :first_name => 'Radek', :initial => 'S', 
        :gender    => 'Male', :color      => 'Green', 
        :born_on   => Date.strptime('6-3-1975', "%m-%d-%Y") },
        
      { :last_name => 'Bouillon', :first_name => 'Francis', :initial => 'G', 
        :gender    => 'Male',     :color      => 'Blue',    
        :born_on   => Date.strptime('6-3-1975', "%m-%d-%Y") }
    ]
    
    parser = Parser.new('test/samples/pipe.txt')
    assert_equal expected, parser.records
  end
  
  def test_should_parse_space_delimiter
    expected = [
      { :last_name => 'Kournikova', :first_name => 'Anna', :initial => 'F', 
        :gender    => 'Female',     :color      => 'Red',  
        :born_on   => Date.strptime('6-3-1975', "%m-%d-%Y") },
        
      { :last_name => 'Hingis', :first_name => 'Martina', :initial => 'M', 
        :gender    => 'Female', :color      => 'Green',   
        :born_on   => Date.strptime('4-2-1979', "%m-%d-%Y") },
        
      { :last_name => 'Seles',  :first_name => 'Monica', :initial => 'H', 
        :gender    => 'Female', :color      => 'Black',  
        :born_on   => Date.strptime('12-2-1973', "%m-%d-%Y") }
    ]
    
    parser = Parser.new('test/samples/space.txt')
    assert_equal expected, parser.records
  end
  
  def test_should_parse_comma_delimiter
    expected = [
      { :last_name => 'Abercrombie', :first_name => 'Neil', 
        :gender    => 'Male',        :color      => 'Tan', 
        :born_on   => Date.new(1943, 2, 13) },
        
      { :last_name => 'Bishop', :first_name => 'Timothy', 
        :gender    => 'Male',   :color      => 'Yellow', 
        :born_on   => Date.new(1967, 4, 23) },
        
      { :last_name => 'Kelly',  :first_name => 'Sue', 
        :gender    => 'Female', :color      => 'Pink', 
        :born_on   => Date.new(1959, 7, 12) }
    ]
    
    parser = Parser.new('test/samples/comma.txt')
    assert_equal expected, parser.records
  end
  
  def test_should_parse_multiple_files
    parser = Parser.new(['test/samples/pipe.txt', 'test/samples/comma.txt'])
    assert_equal 6, parser.records.length
  end

  # Tests for private methods  
  def test_should_normalize_female_gender
    assert_equal 'Female', @parser.instance_eval { normalize_gender('F') }
  end
  
  def test_should_normalize_male_gender
    assert_equal 'Male', @parser.instance_eval { normalize_gender('M') }
  end
  
  def test_should_not_normalize_valid_gender
    assert_equal 'Male', @parser.instance_eval { normalize_gender('Male') }
    assert_equal 'Female', @parser.instance_eval { normalize_gender('Female') }
  end
end
