# table information
# table name arrangements
#
# id              bigint               not null, primary key
# user_id         bigint               foreign key
# title           string               not null
# context         text                 not null
# created_at      datetime             not null
# updated_at      datetime             not null
#
# Index
#   index_arrangements_on_user_id

class Arrangement < ApplicationRecord
  belongs_to :user
end
