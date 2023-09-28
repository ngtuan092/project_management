class LessonLearnsController < ApplicationController
  before_action :logged_in_user

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
end
