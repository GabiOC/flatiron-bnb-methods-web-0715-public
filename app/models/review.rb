class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :presence => true
  validate :exists

  def exists
     errors.add(:review, "reservation does not exist") unless reservation &&
     reservation.status == "accepted" &&
     reservation.checkout < Date.today
  end
end
