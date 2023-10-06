class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  delegate :name, to: :group, prefix: true
end
