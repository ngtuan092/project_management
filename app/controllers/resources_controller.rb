class ResourcesController < ApplicationController
  before_action :validate_create_form, only: :create
  before_action :logged_in_user

  def index
    @projects = Project.filter_name(params[:name])
                       .filter_date(params[:date])
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items
  end

  def new
    @project_user = ProjectUser.new
  end

  def create
    date = Date.parse params.dig(:project_user, :joined_at)
    @month = date.month
    @year = date.year
    @project_id = params.dig(:project_user, :project_id)
    @list_params = params.dig(:project_user, :project_user_resources_attributes)

    create_resources

    flash[:success] = t(".create_success")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".create_fail")
  ensure
    redirect_to resources_path
  end

  private

  def validate_create_form
    return if params.dig(:project_user,
                         :project_user_resources_attributes).present?
    return if params.dig(:project_user,
                         :project_id).present?

    flash[:danger] = t ".at_least_1"
    redirect_to new_resource_path
  end

  def create_resources
    ActiveRecord::Base.transaction do
      @list_params.each do |_key, resource_params|
        user_id = resource_params["project_user_id"].to_i
        project_user = ProjectUser.find_by(user_id:,
                                           project_id: @project_id)
        if project_user.nil?
          return raise ActiveRecord::RecordInvalid, project_user
        end

        percentage = resource_params["percentage"].to_i
        man_month = percentage.to_f / 100.0

        new_resource = ProjectUserResource.new(
          project_user_id: project_user.id,
          percentage:,
          month: @month,
          year: @year,
          man_month:
        )

        new_resource.save!
      end
    end
  end
end
