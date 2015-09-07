class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  # ex. ('2014-05-01', '2014-05-30')
  # select listings that have a:
  # checkin date after start date
  # checkout date before start date
  def neighborhood_openings(start_date, end_date)
    listings.select do |listing|
      listing.reservations do |reservation|
        reservation.checkin > Date.parse(start_date) ||
        reservation.checkout < Date.parse(end_date)
      end
    end
  end

  def self.highest_ratio_res_to_listings
    ratio_hash = {}
    all.each do |neighborhood|
      ratio = neighborhood.reservations.count / neighborhood.listings.count unless neighborhood.listings.count == 0
      ratio_hash[neighborhood] = ratio
    end
    ratio_hash.key(ratio_hash.values.compact.max)
  end

  def self.most_res
    res_hash = {}
    all.each do |neighborhood|
      res_hash[neighborhood] = neighborhood.reservations.count
    end
    res_hash.max_by { |k, v| v }[0]
  end
end
