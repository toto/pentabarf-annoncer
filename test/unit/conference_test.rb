# == Schema Information
#
# Table name: conferences
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  venue      :string(255)
#  city       :string(255)
#  day_change :time
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
