class LessonLearnsController < ApplicationController
  before_action :logged_in_user
  before_action :find_lesson_learn, only: %i(show destroy edit update)
  before_action :check_role, only: :destroy

  add_breadcrumb I18n.t("layouts.sidebar.lesson_learn"), :lesson_learns_path

  def index
    @lesson_learns = LessonLearn
                     .filter_lesson_category(params[:lesson_category_id])
                     .filter_start_date(params[:start_date])
                     .filter_end_date(params[:end_date])
                     .filter_creator(params[:creator_id])
                     .by_recently_created
    @pagy, @lesson_learns = pagy @lesson_learns,
                                 items: Settings.pagy.number_items_10
  end

  def new
    @lesson_learn = LessonLearn.new
    @projects = current_user.valid_projects_by_role
    add_breadcrumb t("breadcrumbs.new"), new_lesson_learn_path
  end

  def create
    @lesson_learn = current_user.created_lesson_learns.build lesson_learn_params

    if @lesson_learn.save
      flash[:success] = t ".create_success"
      redirect_to lesson_learns_path
    else
      @projects = current_user.valid_projects_by_role
      flash[:danger] = t ".create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @projects = current_user.valid_projects_by_role.by_recently_created
  end

  def update
    if @lesson_learn.update lesson_learn_params
      flash.now[:success] = t ".update_success"
    else
      flash.now[:danger] = t ".update_fail"
    end
    respond_to do |format|
      format.html{redirect_to lesson_learns_path}
      format.turbo_stream
    end
  end

  def show; end

  def destroy
    if @lesson_learn.destroy
      flash[:success] = t ".delete_success"
      redirect_to lesson_learns_path
    else
      flash[:danger] = t ".fail_delete"
      redirect_to lesson_learns_path, status: :unprocessable_entity
    end
  end

  private

  def check_role
    return if current_user.can_edit_delete_lesson_learn? @lesson_learn

    flash[:warning] = t ".cannot_delete"
    redirect_to lesson_learns_path
  end

  def lesson_learn_params
    params.require(:lesson_learn).permit LessonLearn::UPDATE_ATTRS
  end
end
