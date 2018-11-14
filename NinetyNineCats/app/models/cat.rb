# == Schema Information
#
# Table name: cats
#
#  id          :bigint(8)        not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ApplicationRecord
  COLORS = %w(red orange blue white black green)
  SEX = %w(m f M F)

  validates_presence_of :birth_date, :color, :name, :sex, :description
  validates :color, inclusion: { in: COLORS, message: "Not a valid color" }
  validates :sex, inclusion: { in: SEX, message: "Not a valid gender"}
  # validate :check_gender

  has_many :cat_rental_requests,
    foreign_key: :cat_id,
    class_name: :CatRentalRequest,
    dependent: :destroy

  def age
    ((DateTime.now - birth_date) / 365.25).floor
  end

# private
#   def check_gender
#     p sex
#     errors[:sex] << "Gender not valid" unless ["M", "F"].include?(sex.upcase)
#   end

end
