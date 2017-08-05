class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_group_and_check_pemission, only: [:edit, :update, :destroy]
  def index
    @groups = Group.all
  end
  def new
    @group = Group.new
  end
  def edit

  end
  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end
  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end
  def update

    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end
  def destroy

    @group.destroy
    redirect_to groups_path
  end
  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
    end
    redirect_to group_path(@group)
  end
  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
    end
    redirect_to group_path(@group)
  end
  private
  def find_group_and_check_pemission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to groups_path
    end
  end
  def group_params
    params.require(:group).permit(:title, :description)
  end
end
