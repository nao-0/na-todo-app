class TasksController < ApplicationController
before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @tasks = Task.all
    @board = Board.find(params[:board_id])
  end

  def new
    @board = Board.find(params[:board_id])
    if current_user
      @task = current_user.boards.find(params[:board_id]).tasks.build
    else
      redirect_to new_user_session_path, notice: 'ログインしてください'
    end
  end

  def create
    @board = Board.find(params[:board_id])
    @task = current_user.boards.find(params[:board_id]).tasks.build(task_params)
    if @task.save
      redirect_to board_task_path(board_id: @board.id), notice: 'タスクを追加'
    else
      flash.now[:error] = '更新できませんでした'
      render :new
    end
  end

  def edit
    board = board.find(params[:board_id])
    @task = current_user.boards.find(params[:id])
  end

  def update
    board = board.find(params[:board_id])
    @task = current_user.boards.find(params[:id])
    if @board.update(board_params)
      redirect_to board_path(@board), notice: '更新できました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    board = board.find(params[:board_id])
    board = current_user.boards.find(params[:id])
    board.destroy!
    redirect_to root_path, notice: '削除に成功しました'
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :eyecatch)
  end
end