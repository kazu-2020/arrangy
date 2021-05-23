# table information
# table name photos
#
# id                               bigint       not null, primary key
# arrangement_id                   bigint       foreign key
# url                              string       not null
# created_at                       datetime     not null
# updated_at"                      datetime     not null
#
# Index
#   index_photos_on_arrangement_id

class Photo < ApplicationRecord
  belongs_to :arrangement

  validates :url, presence: true
end
