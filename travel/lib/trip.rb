# Stores information about a trip.
class Trip
  # Custom error that is raised when a given location is not recognized by the
  # routing service.
  class LocationError < StandardError; end
  
  # An array of locations that the trip will stop at.
  attr_reader :stops
  
  # Initializes a new trip instance.
  #
  # routing_service:: A handle to a routing web service.
  def initialize(routing_service)
    @routing_service = routing_service
    @stops, @legs = [], []
  end

  # Adds a stop to the trip. Raises +LocationError+ if the routing service
  # cannot determine the location.
  #
  # location:: The location to stop at.
  def add_stop(location)
    raise ArgumentError if location.nil? || 0 == location.length
    if @routing_service.get('/validate', :location => location)
      @stops << location
    else
      raise LocationError, "Invalid location (#{location})"
    end
  end
  
  # The number of legs on the trip.
  def number_of_legs
    @stops.length / 2 + @stops.length % 2
  end
  
  # The legs of the trip. Returns an array of location hashes.
  def legs
    i = 0
    while i < @stops.length - 1
      distance = calculate_distance(@stops[i], @stops[i+1])
      @legs << { :origin      => @stops[i], 
                 :destination => @stops[i+1], 
                 :distance    => distance }
      i += 1
    end
    @legs
  end
  
  private
  
  def calculate_distance(origin, destination)
    @routing_service.get('/distance', 
                         :origin => origin, 
                         :destination => destination)    
  end
end
