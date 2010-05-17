require 'rubygems'
require "test/unit"
require "mocha"
require "trip"

class TestTrip < Test::Unit::TestCase

  # Mock routing service.
  class RoutingService; end
  
  def setup
    @svc = RoutingService.new
    @trip = Trip.new(@svc)
  end
  
  def test_can_create
    assert @trip
  end
  
  def test_should_have_stops
    assert @trip.stops
  end
  
  def test_can_add_valid_stop
    @svc.stubs(:get).returns(true)
    @trip.add_stop('New York, NY')
    assert @trip.stops.include?('New York, NY')
  end
  
  def test_null_location_raises_client_side_error
    @svc.stubs(:get).returns(false)
    assert_raise ArgumentError do
      @trip.add_stop('')
    end    
  end
  
  def test_cannot_add_invalid_stop
    @svc.stubs(:get).returns(false)
    assert_raise Trip::LocationError do
      @trip.add_stop('Foobar, NY')
    end
  end
  
  def test_can_get_single_leg_count
    @svc.stubs(:get).returns(true)
    @trip.add_stop('New York, NY')
    @trip.add_stop('Washington, DC')
    assert_equal 1, @trip.number_of_legs
  end
  
  def test_can_get_multiple_leg_count
    @svc.stubs(:get).returns(true)
    @trip.add_stop('New York, NY')
    @trip.add_stop('Washington, DC')
    @trip.add_stop('Orlando, FL')
    assert_equal 2, @trip.number_of_legs
  end
  
  def test_can_get_single_leg_detail
    @svc.expects(:get).with('/validate', 
                            :location => 'New York, NY').returns(true)

    @svc.expects(:get).with('/validate', 
                            :location => 'Washington, DC').returns(true)

    @svc.expects(:get).with('/distance', 
                            :origin => 'New York, NY', 
                            :destination => 'Washington, DC').returns(100.0)

    @trip.add_stop('New York, NY')
    @trip.add_stop('Washington, DC')
    expected = [{ :origin => 'New York, NY', 
                  :destination => 'Washington, DC', :distance => 100.0 }]

    assert_equal expected, @trip.legs
  end
  
  def test_can_get_multiple_leg_detail
    @svc.expects(:get).with('/validate', 
                            :location => 'New York, NY').returns(true)

    @svc.expects(:get).with('/validate', 
                            :location => 'Washington, DC').returns(true)

    @svc.expects(:get).with('/validate', 
                            :location => 'Orlando, FL').returns(true)

    @svc.expects(:get).with('/distance', 
                            :origin => 'New York, NY', 
                            :destination => 'Washington, DC').returns(100.0)

    @svc.expects(:get).with('/distance', 
                            :origin => 'Washington, DC', 
                            :destination => 'Orlando, FL').returns(200.0)

    @trip.add_stop('New York, NY')
    @trip.add_stop('Washington, DC')
    @trip.add_stop('Orlando, FL')
    expected = [
      { :origin => 'New York, NY', 
        :destination => 'Washington, DC', 
        :distance => 100.0 },
      { :origin => 'Washington, DC', 
        :destination => 'Orlando, FL', 
        :distance => 200.0 }]

    assert_equal expected, @trip.legs    
  end
end
