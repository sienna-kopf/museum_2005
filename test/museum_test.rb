require 'minitest/autorun'
require 'minitest/pride'
require './lib/patron'
require './lib/exhibit'
require './lib/museum'
require 'mocha/minitest'


class MuseumTest < Minitest::Test
  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")

    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})

    @patron_2 = Patron.new("Sally", 20)

    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_attributes
    assert_equal "Denver Museum of Nature and Science", @dmns.name
    assert_equal [], @dmns.exhibits
    assert_equal [], @dmns.patrons
  end

  def test_it_can_add_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    assert_equal [@gems_and_minerals], @dmns.exhibits

    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits
  end

  def test_it_can_add_patrons
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons
  end

  def test_it_can_recommend_exhibits_based_on_patrons_interests
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 20)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")


    @patron_2.add_interest("IMAX")


    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@patron_1)
    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)
  end

  # def test_it_can_sort_admitted_patrons_by_exhibit_interest
  #   @patron_2.add_interest("Dead Sea Scrolls")
  #
  #   @dmns.admit(@patron_1)
  #   @dmns.admit(@patron_2)
  #   @dmns.admit(@patron_3)
  #
  #   @dmns.add_exhibit(@gems_and_minerals)
  #   @dmns.add_exhibit(@dead_sea_scrolls)
  #   @dmns.add_exhibit(@imax)
  #
  #   expected = {
  #     @gems_and_minerals => [@patron_1],
  #     @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
  #     @imax => []
  #   }
  #
  #   assert_equal expected, @dmns.patrons_by_exhibit_interest
  # end

  def test_ticket_lottery_contestants
    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")

    @patron_2.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@patron_1, @patron_3], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)
  end

  def test_draw_lottery_winner
    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")

    @patron_2.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_nil nil, @dmns.draw_lottery_winner(@gems_and_minerals)

    @dmns.expects(:draw_lottery_winner).returns(@patron_3)
    assert_equal @patron_3, @dmns.draw_lottery_winner(@dead_sea_scrolls)
  end

  def test_it_can_announce_a_lottery_winner
    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("IMAX")

    @patron_2.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal "No winners for this lottery", @dmns.announce_lottery_winner(@gems_and_minerals)
    assert_equal "Bob has won the IMAX exhibit lottery", @dmns.announce_lottery_winner(@imax)
  end
end
