require 'minitest/autorun'
require 'minitest/pride'

require './lib/museum'
require './lib/patron'
require './lib/exhibit'

class MuseumTest < Minitest::Test
  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")

    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})

    @patron_1 = Patron.new("Bob", 20)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")

    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("IMAX")

    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @patron_4 = Patron.new("Jimbo", 0)
    @patron_4.add_interest("Dead Sea Scrolls")

    @grouped_interest_hash = {
                              @gems_and_minerals => [@patron_1],
                              @dead_sea_scrolls  => [@patron_1, @patron_3],
                              @imax              => [@patron_2]
                             }
  end

  def test_it_exists_with_attributes
    assert_instance_of Museum, @dmns
    assert_equal "Denver Museum of Nature and Science", @dmns.name
    assert_equal [], @dmns.exhibits
  end

  def test_it_can_add_exhibits
    assert_equal [], @dmns.exhibits

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits
  end

  def test_it_recommends_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@patron_1)
    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)
  end

  def test_it_admits_patrons
    assert_equal [], @dmns.patrons

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons
  end

  def test_it_groups_patrons_by_exhibit_interest
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal @grouped_interest_hash, @dmns.patrons_by_exhibit_interest
  end

  def test_it_returns_lottery_contestants
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @dmns.admit(@patron_4)

    assert_equal [@patron_3, @patron_4], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)
  end

  def test_it_draws_lottery_winner_name
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @dmns.admit(@patron_4)

    expected_options = ["Johnny", "Jimbo"]

    assert_equal true, expected_options.include?(@dmns.draw_lottery_winner(@dead_sea_scrolls))
    assert_equal nil, @dmns.draw_lottery_winner(@gems_and_minerals)
  end
end
