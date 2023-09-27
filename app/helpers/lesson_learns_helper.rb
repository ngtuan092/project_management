module LessonLearnsHelper
  def list_lesson_learn_categories
    LessonLearnCategory.pluck :name, :id
  end
end
