require 'test_helper'

class GameTest < ActiveSupport::TestCase
  

  test 'new game' do
    game = Game.new(name: "Spirit Island")
    assert game.valid?
  end 

  
end
