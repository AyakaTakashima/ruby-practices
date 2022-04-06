# frozen_string_literal: true

require './bowling'
require 'minitest/autorun'

class BowlingTest < Minitest::Test
  def test_calculate1
    assert_equal 139, calculate_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
  end

  def test_calculate2
    assert_equal 164, calculate_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
  end

  def test_calculate3
    assert_equal 107, calculate_score('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
  end

  def test_calculate_all_zero
    assert_equal 0, calculate_score('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
  end

  def test_calculate_perfect
    assert_equal 300, calculate_score('X,X,X,X,X,X,X,X,X,X,X,X')
  end
end
