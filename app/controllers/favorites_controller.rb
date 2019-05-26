class FavoritesController < ApplicationController
  #お気に入り登録
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(micropost)
    flash[:success] = 'お気に入り登録をしました'
    redirect_to likes_user_path(current_user)
  end

  #お気に入り解除
  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micropost)
    flash[:success] = 'お気に入り登録を解除しました'
    redirect_to likes_user_path(current_user)
  end
end
