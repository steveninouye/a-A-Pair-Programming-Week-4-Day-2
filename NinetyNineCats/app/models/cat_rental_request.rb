# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :bigint(8)        not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ApplicationRecord
  STATUS = %w(PENDING APPROVED DENIED)

  validates_presence_of :cat_id, :start_date, :end_date, :status
  validates :status, inclusion: { in: STATUS, message: "Not a valid status"}

  belongs_to :cat,
    foreign_key: :cat_id,
    class_name: :Cat,
    dependent: :destroy

  def overlapping_requests
    Cat.include(:cat_rental_requests).where()
  end
end
