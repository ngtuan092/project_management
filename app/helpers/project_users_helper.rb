module ProjectUsersHelper
  def list_roles
    Role.pluck :name, :id
  end

  def list_users
    User.pluck :name, :id
  end
end
