class Museum
  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def admit(patron)
    @patrons << patron
  end

  def recommend_exhibits(patron)
    recommendations = []
    @exhibits.each do |exhibit|
      patron.interests.each do |interest|
        if exhibit.name == interest
          recommendations << exhibit
        end
      end
    end
    recommendations
  end

  def ticket_lottery_contestants(exhibit)
    lottery_contestants = []
    @patrons.each do |patron|
      patron.interests.each do |interest|
        if interest == exhibit.name && patron.spending_money < exhibit.cost
          lottery_contestants << patron
        end
      end
    end
    lottery_contestants
  end

  def draw_lottery_winner(exhibit)
    ticket_lottery_contestants(exhibit).sample
  end

  def announce_lottery_winner(exhibit)
    require "pry"; binding.pry
    "#{draw_lottery_winner(exhibit).name} has won the #{exhibit.name} exhibit lottery"
  end

  # def patrons_by_exhibit_interest
  #   patrons_by_interest = {}
  #   @patrons.each do |patron|
  #     patron.interests.each do |interest|
  #       recommend_exhibits(patron).each do |recommendation|
  #         if recommendation.name == interest
  #           patrons_by_interest[recommendation] = patron
  #         end
  #       end
  #     end
  #   end
  #   patrons_by_interest
  #
  # end





    # patron_interests = @patrons.each do |patron|
    #   patron.interest
    # end
    #
    #
    # sorted_exhibits = @exhibits.group_by do |exhibit|
    #   exhibit.name == patrons.each d
    # end



    # sorted_patrons = {}
    # patrons_with_shared_interests = []
    # @exhibits.each do |exhibit|
    #   @patrons.each do |patron|
    #     patron.interests.each do |interest|
    #       if interest == exhibit.name
    #         patrons_with_shared_interests << patron
    #       end
    #     end
    #     sorted_patrons[exhibit] = patron
    #   end
    # end
    # sorted_patrons

end
