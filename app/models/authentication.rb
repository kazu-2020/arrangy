# table information
# table name authentications
#
# id                               bigint       not null, primary key
# user_id                          bigint       not null
# provider                         string       not null
# uid                              string       not null
# created_at                       datetime     not null
# updated_at"                      datetime     not null
#
# Index
#   index_authentications_on_provider_and_uid"

class Authentication < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :uid
    validates :provider
  end
end
