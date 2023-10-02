class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :projects, through: :users
  belongs_to :parent, class_name: Group.name, optional: true
  has_many :sub_groups, class_name: Group.name, foreign_key: :parent_id,
           dependent: :destroy

  scope :filter_group, lambda {|group_id|
    group = Group.find_by id: group_id
    return all if group.nil?

    valid_group_ids = group.nested_sub_group_ids << group_id
    where id: valid_group_ids
  }

  def user_groups_month_ids month, year
    # list user group created before month year
    date = Date.current.change(month:, year:).at_beginning_of_month
    list_groups_id = nested_sub_group_ids << id
    UserGroup.where(group_id: list_groups_id, joined_at: ..date)
             .pluck(:user_id)
  end

  def total_resource_groups_month month, year
    # list id project user
    group_user_project_ids = ProjectUser
                             .where(user_id: user_groups_month_ids(month,
                                                                   year))
                             .pluck(:id)
    # list {project_id => group_resource}
    ProjectUserResource.joins(:project_user)
                       .where(project_user_id: group_user_project_ids)
                       .filter_month(month).filter_year(year)
                       .group(:project_id).sum(:man_month)
  end

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
    nested_sub_group_ids.uniq
  end
end
