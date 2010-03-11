require File.dirname(__FILE__) + '/test_helper'

class EventsController < ActionController::Base
end
ActionController::Routing::Routes.add_route('/:controller/:action/:id')

class RedirectRoutingTest < TestCase
  tests RedirectRoutingController
  
  def setup
    @controller = RedirectRoutingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_redirect_routes
    with_routing do |set|
      set.draw do |map|
        map.redirect '',                 :controller => 'events'
        map.redirect 'test',             'http://example.com'
        map.redirect 'oldurl', 'newurl', :permanent => true
        map.redirect 'festivals/*path',  'http://example.com/events/festivals', :keep_path => :path
      end
      
      assert_recognizes({ :controller => "redirect_routing", :action => "redirect", :args => [{ 'controller' => "events" }] }, "/")
      assert_recognizes({ :controller => "redirect_routing", :action => "redirect", :args => ["http://example.com"] }, "/test")
      assert_recognizes({ :controller => "redirect_routing", :action => "redirect", :args => ["newurl", {'permanent' => true}] }, "/oldurl")
      assert_recognizes({ :controller => "redirect_routing", :action => "redirect", :args => ["http://example.com/events/festivals", {'keep_path' => :path}], :path => ['music', 'recent'] }, "/festivals/music/recent")
    end
  end
  
  def test_redirect_controller_with_hash
    get :redirect, :args => [{ :controller => "events" }]
    assert_redirected_to :controller => "events"
    assert_response 302
  end
  
  def test_redirect_controller_with_string
    get :redirect, :args => ["http://example.com"]
    assert_redirected_to "http://example.com"
    assert_response 302
  end
  
  def test_permanent_redirect_controller_with_hash
    get :redirect, :args => [{ :controller => "events", :permanent => true }]
    assert_redirected_to :controller => "events"
    assert_response 301
  end
  
  def test_permanent_redirect_controller_with_string
    get :redirect, :args => ["http://example.com", { :permanent => true }]
    assert_redirected_to "http://example.com"
    assert_response 301
  end
  
  def test_redirect_controller_with_hash_and_append_path
    assert_raises(ArgumentError) do
      get :redirect, :args => [{ :controller => "events", :keep_path => :path }], :path => [ "festivals/recent" ]
    end
  end
  
  def test_redirect_controller_with_string_and_append_path
    get :redirect, :args => ["http://example.com", { :keep_path => :path }], :path => [ "festivals/recent" ]
    assert_redirected_to "http://example.com/festivals/recent"
    assert_response 302
  end
  
  def test_redirect_controller_with_string_and_append_path_array
    get :redirect, :args => ["http://example.com", { :keep_path => :path }], :path => [ "festivals", "recent" ]
    assert_redirected_to "http://example.com/festivals/recent"
    assert_response 302
  end
  
  def test_permanent_redirect_controller_with_hash_and_append_path
    assert_raises(ArgumentError) do
      get :redirect, :args => [{ :controller => "events", :permanent => true, :keep_path => :path }], :path => [ "festivals/recent" ]
    end
  end
  
  def test_permanent_redirect_controller_with_string_and_append_path
    get :redirect, :args => ["http://example.com", { :permanent => true, :keep_path => :path }], :path => [ "festivals/recent" ]
    assert_redirected_to "http://example.com/festivals/recent"
    assert_response 301
  end
  
  def test_redirect_normally_when_the_path_to_keep_is_blank
    get :redirect, :args => ["http://example.com", { :keep_path => :unknown }], :path => [ "festivals/recent" ]
    assert_redirected_to "http://example.com"
    assert_response 302
  end
end
