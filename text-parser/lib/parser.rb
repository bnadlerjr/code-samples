require 'date'
require 'core-ext/array'

# = Description
# Handles parsing of text files. Supports '|', ',' and ' ' delimiters.
class Parser
  # An +Array+ of +Hashes+ that contains the data parsed from text files.
  attr_reader :records
  
  # Initializes +Parser+. The specified filename(s) are parsed and stored 
  # in +records+. The type of file delimiter is determined by looking at the 
  # first line of the file. The supported delimiters are '|', ',' and ' '. It 
  # is assumed that the delimiters do not appear in the data values themselves.
  #
  # Any dates in the file(s) are converted to actual +Date+ objects.
  #
  # Abbreviated gender values (ie. 'F', 'M') are converted to their full names.
  #
  # filenames::
  #   Either a single filename or array of filenames to parse.
  def initialize(filenames)
    @records = []
    filenames = [filenames] unless filenames.is_a?(Array)
    
    filenames.each do |f|
      lines = File.open(f).readlines    
      delimiter, headings = file_spec(lines.first)
      @records += lines.map { |line| parse_line(line, delimiter, headings) }      
    end
    
    # Normalize the data
    @records.each do |record|
      record[:gender] = normalize_gender(record[:gender])
      record[:born_on] = normalize_date(record[:born_on])
    end
  end
    
  private

  def parse_line(line, delimiter, headings)
    values = line.split(delimiter).map { |value| value.strip }
    values.extend(ArrayExtensions).to_hash(headings)
  end
  
  def file_spec(line)
    if line.include?('|')
      return ['|', %w[last_name first_name initial gender color born_on]]
    elsif line.include?(',')
      return [',', %w[last_name first_name gender color born_on]]
    else
      return [' ', %w[last_name first_name initial gender born_on color]]
    end    
  end
  
  def normalize_gender(gender)
    if 'M' == gender
      return 'Male'
    elsif 'F' == gender
      return 'Female'
    else
      return gender
    end
  end
  
  def normalize_date(date)
    Date.parse(date.gsub('-', '/'))
  end
end
