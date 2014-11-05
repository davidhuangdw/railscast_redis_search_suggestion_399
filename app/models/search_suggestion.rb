class SearchSuggestion  #< ActiveRecord::Base

  def self.term_for(prefix)
    $redis.zrevrange "search-suggestions:#{prefix.downcase}",  0, 9
    # Rails.cache.fetch(["search-terms", prefix]) do
    #   suggestions = where("term like ?", "#{prefix}_%")
    #   suggestions.order("popularity desc").limit(10).pluck(:term)
    # end
  end

  def self.index_products
    Product.find_each do |product|
      index_term(product.name)
      index_term(product.category)
      product.name.split.each {|t| index_term(t)}
    end
  end
  def self.index_term(term)
    1.upto(term.length-1) do |n|
      prefix = term[0,n]
      $redis.zincrby "search-suggestions:#{prefix.downcase}", 1, term
    end
    # where(term: term.downcase).first_or_initialize.tap do |suggestion|
    #   suggestion.increment! :popularity
    # end
  end
end
