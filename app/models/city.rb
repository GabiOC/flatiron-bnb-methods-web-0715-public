class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    Listing.all
  end

  def self.highest_ratio_res_to_listings
    ratio_hash = {}
    all.each do |city|
      ratio = city.reservations.count / city.listings.count unless city.listings.count == 0
      ratio_hash[city] = ratio
    end
    ratio_hash.max_by { |k, v| v }[0]
  end

  def self.most_res
    res_hash = {}
    all.each do |city|
      res_hash[city] = city.reservations.count
    end
    res_hash.max_by { |k, v| v }[0]
  end
end
