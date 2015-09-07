class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, :presence => true
  validate :not_own_listing
  validate :available
  validate :checkin_before_checkout
  validate :not_same_day

  def not_own_listing
    errors.add(:reservation, "can't reserve own listing") if listing.host == guest
  end

  def available
    if checkin && checkout
      listing.reservations.each do |reservation|
        this_trip = checkin..checkout
        other_trip = reservation.checkin..reservation.checkout
        if ([*this_trip] & [*other_trip]).any?
          errors.add(:reservation, "listing not available")
        end
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      errors.add(:reservation, "can't checkout before checkin") if checkin > checkout
    end
  end

  def not_same_day
    if checkin && checkout
      errors.add(:reservation, "can't checkout on same day as checkin") if checkin == checkout
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price.to_f * duration
  end
end
