class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, :presence => true

  before_create do
    host.host = true
    host.save
  end

  after_destroy do
    host.host = false if self.host.listings.empty?
    host.save
  end

  def average_review_rating
    arr = []
    self.reviews.each do |review|
      arr << review.rating
    end
    arr.inject { |sum, rating| sum + rating }.to_f / arr.size
  end
end
