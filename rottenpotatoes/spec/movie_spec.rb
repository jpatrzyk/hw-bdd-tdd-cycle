require 'spec_helper'
require 'rspec/rails'

describe HangpersonGame do
  # helper function: make several guesses
  def guess_several_letters(game, letters)
    letters.chars do |letter|
      game.guess(letter)
    end
  end

  describe 'new' do
    it "takes a parameter and returns a HangpersonGame object" do      
      @hangpersonGame = HangpersonGame.new('glorp')
      expect(@hangpersonGame).to be_an_instance_of(HangpersonGame)
      expect(@hangpersonGame.word).to eq('glorp')
      expect(@hangpersonGame.guesses).to eq('')
      expect(@hangpersonGame.wrong_guesses).to eq('')
    end
  end
end
  