class LessonLearnsController < ApplicationController
  before_action :logged_in_user
  before_action :find_lesson_learn, only: %i(show destroy)
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
end
