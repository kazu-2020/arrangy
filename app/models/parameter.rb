# table information
# table name parameters
#
# id                        bigint               not null, primary key
# arrangement_id            bigint               foreign key
# taste                     integer              not null, default 3
# spiciness                 integer              not null, default 3
# sweetness                 integer              not null, default 3
# satisfaction              integer              not null, default 3
# created_at                datetime             not null
# updated_at                datetime             not null

class Parameter < ApplicationRecord
  belongs_to :arrangement

  with_options presence: true,
               numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 } do
    validates :taste
    validates :spiciness
    validates :sweetness
    validates :satisfaction
  end
end
