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
  validates_presence_of :birth_date, :color, :name, :sex, :description
  validates :sex, length: {maximum: 1}
  validate :check_gender

  def age
    ((DateTime.now - birth_date) / 365.25).floor
  end

private
  def check_gender
    p sex
    errors[:sex] << "Gender not valid" unless ["M", "F"].include?(sex.upcase)
  end

end
