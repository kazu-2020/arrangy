class AfterArrangementPhoto < ApplicationRecord
  belongs_to :arrangement

  validates :url, presence: true
end
