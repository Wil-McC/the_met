class Museum
  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name     = name
    @exhibits = []
    @patrons  = []
  end

  def add_exhibit(exhibit)
    @exhibits.push(exhibit)
  end

  def recommend_exhibits(patron)
    @exhibits.select do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def admit(patron)
    @patrons.push(patron)
  end

  def patrons_by_exhibit_interest
    patrons_by_interest = Hash.new
    @exhibits.each do |exhibit|
      patrons_by_interest[exhibit] = []
      @patrons.each do |patron|
        if recommend_exhibits(patron).include?(exhibit)
          patrons_by_interest[exhibit] << patron
        end
      end
    end
    patrons_by_interest
  end
end
