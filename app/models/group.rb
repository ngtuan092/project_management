class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :projects, through: :users
  belongs_to :parent, class_name: Group.name, optional: true
  has_many :sub_groups, class_name: Group.name, foreign_key: :parent_id,
           dependent: :destroy

  # find all ids of nested sub class
  def nested_sub_group_ids
    nested_sub_group_ids = sub_group_ids
    nested_layer_sub_group = nested_sub_group_ids
    loop do
      nested_layer_sub_group = Group.where(parent_id: nested_layer_sub_group)
                                    .pluck(:id)
      break if nested_layer_sub_group.empty?

      nested_sub_group_ids.concat nested_layer_sub_group
    end
    nested_sub_group_ids
  end
end
