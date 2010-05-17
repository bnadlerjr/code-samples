require "test/unit"
require "formatter"

class TestFormatter < Test::Unit::TestCase
  # Helper class that acts as a test double for STDOUT.
  class Output
    def messages; @messages ||= []; end    
    def puts(message); messages << message; end
  end
  
  def setup
    data = [
      { :last_name => 'Steve', :first_name => 'Smith', :initial => 'D', 
        :gender    => 'Male',  :color      => 'Red',   
        :born_on => Date.parse('3/3/1985') },
        
      { :last_name => 'Bonk', :first_name  => 'Radek', :initial => 'S', 
        :gender    => 'Male', :color       => 'Green', 
        :born_on => Date.parse('6/3/1975') },
        
      { :last_name => 'Bouillon', :first_name => 'Francis', :initial => 'G', 
        :gender    => 'Male',     :color      => 'Blue',    
        :born_on => Date.parse('6/3/1975') },
        
      { :last_name => 'Kournikova', :first_name => 'Anna', :initial => 'F', 
        :gender    => 'Female',     :color      => 'Red',  
        :born_on => Date.parse('6/3/1975') },
        
      { :last_name => 'Hingis', :first_name => 'Martina', :initial => 'M', 
        :gender    => 'Female', :color      => 'Green',   
        :born_on => Date.parse('4/2/1979') },
        
      { :last_name => 'Seles',  :first_name => 'Monica', :initial => 'H', 
        :gender    => 'Female', :color      => 'Black',  
        :born_on => Date.parse('12/2/1973') },
        
      { :last_name => 'Abercrombie', :first_name => 'Neil', 
        :gender    => 'Male',        :color      => 'Tan', 
        :born_on => Date.parse('2/13/1943') },
        
      { :last_name => 'Bishop', :first_name => 'Timothy', 
        :gender    => 'Male',   :color      => 'Yellow',  
        :born_on => Date.parse('4/23/1967') },
        
      { :last_name => 'Kelly',  :first_name => 'Sue', 
        :gender    => 'Female', :color      => 'Pink', 
        :born_on => Date.parse('7/12/1959') }
    ]

    @output = Output.new
    @formatter = Formatter.new(data, @output)
  end
  
  def test_can_initialize_formatter
    assert @formatter
  end
  
  def test_can_render
    @formatter.render
    assert_not_equal 0, @output.messages.length
  end
  
  def test_can_render_by_gender
    expected = [
      'Hingis Martina Female 4/2/1979 Green',
      'Kelly Sue Female 7/12/1959 Pink',
      'Kournikova Anna Female 6/3/1975 Red',
      'Seles Monica Female 12/2/1973 Black',
      'Abercrombie Neil Male 2/13/1943 Tan',
      'Bishop Timothy Male 4/23/1967 Yellow',
      'Bonk Radek Male 6/3/1975 Green',
      'Bouillon Francis Male 6/3/1975 Blue',
      'Steve Smith Male 3/3/1985 Red'
    ]
    @formatter.render(:by => [:gender, :last_name])
    assert_equal expected, @output.messages
  end
  
  def test_can_render_by_birth_date
    expected = [
      'Abercrombie Neil Male 2/13/1943 Tan',
      'Kelly Sue Female 7/12/1959 Pink',
      'Bishop Timothy Male 4/23/1967 Yellow',
      'Seles Monica Female 12/2/1973 Black',
      'Bonk Radek Male 6/3/1975 Green',
      'Bouillon Francis Male 6/3/1975 Blue',
      'Kournikova Anna Female 6/3/1975 Red',
      'Hingis Martina Female 4/2/1979 Green',
      'Steve Smith Male 3/3/1985 Red'
    ]
    
    @formatter.render(:by => [:born_on, :last_name])
    assert_equal expected, @output.messages
  end
  
  def test_can_render_by_last_name
    expected = [
      'Steve Smith Male 3/3/1985 Red',
      'Seles Monica Female 12/2/1973 Black',
      'Kournikova Anna Female 6/3/1975 Red',
      'Kelly Sue Female 7/12/1959 Pink',
      'Hingis Martina Female 4/2/1979 Green',
      'Bouillon Francis Male 6/3/1975 Blue',
      'Bonk Radek Male 6/3/1975 Green',
      'Bishop Timothy Male 4/23/1967 Yellow',
      'Abercrombie Neil Male 2/13/1943 Tan'
    ]
    
    @formatter.render(:by => :last_name, :order => 'desc')
    assert_equal expected, @output.messages
  end  
end
