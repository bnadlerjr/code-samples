# = Description
# Handles rendering of text data.
class Formatter
  # Initializes new +Formatter+.
  #
  # data:: 
  #   An array of hashes that represents the data to be output.
  # output::
  #   An object that the data will be rendered to. Can be anything that 
  #   responds to +puts+. Defaults to +STDOUT+ if not specified.
  def initialize(data, output=STDOUT)
    @data, @output = data, output
  end
  
  # Renders the data according to the specified options.
  #
  # Options:
  #   :date_format:: 
  #     Format for dates. Defaults to "m/d/yyyy" if not specified.
  #   :by::
  #     Specifies fields to sort by. Can be an array. Defaults to 
  #     +:last_name+ if not specified.
  #   :order::
  #     The sort order. Use 'asc' for ascending; any other value will sort as 
  #     descending. The default is 'asc'.
  #
  # Example:
  #
  # f.render(:by => [:born_on, :last_name]) => Renders data sorted in 
  #                                            ascending order by :born_on 
  #                                            then by :last_name
  def render(options={})
    date_format = options[:date_format] || "%-m/%-d/%Y" 
    sort_criteria = options[:by] ? [options[:by]].flatten : [:last_name]
    order = options.has_key?(:order) ? options[:order] : 'asc'

    sorted_data = sort(sort_criteria, order)
    sorted_data.each do |item|
      @output.puts "#{item[:last_name]} #{item[:first_name]} " +
                   "#{item[:gender]} " +
                   "#{item[:born_on].strftime(date_format)} #{item[:color]}"
    end
  end
  
  private
  
  def sort(criteria, order='asc')
    result = @data.sort_by { |item| criteria.map { |c| item[c] } }
    result.reverse! unless 'asc' == order
    
    result
  end
end
