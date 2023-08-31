class UsersController < ApplicationController
  before_action :find_user, :correct_user, only: %i(edit update)

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t(".flash_update_success").capitalize
      redirect_to @user
    else
      flash[:danger] = t(".flash_update_danger").capitalize
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit :name,
                                 :email,
                                 :password,
                                 :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id] || params[:user_id]
    return if @user

    flash[:warning] = t("not_found_user").capitalize
    redirect_to root_path
  end

  def correct_user
    redirect_to(root_url, status: :see_other) unless current_user? @user
  end
end
