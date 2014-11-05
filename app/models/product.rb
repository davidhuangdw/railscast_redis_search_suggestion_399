class Product < ActiveRecord::Base
  def self.search(term)
    where("name like :term or category like :term", term: "%#{term}%")
  end
end
