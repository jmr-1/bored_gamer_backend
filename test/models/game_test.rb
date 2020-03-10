require 'test_helper'

class GameTest < ActiveSupport::TestCase
  

  test 'new game' do
    game = Game.new(name: "Spirit Island")
    assert game.valid?
  end 

  test 'new game has owner?' do 

    game = Game.new 
    user = User.new 
    user.games << game 

    assert_equal(user.games.length, 1)
    assert_equal(user.games[0], game)
  end 
  
end
