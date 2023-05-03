# The TasksController handles the CRUD operations for tasks within a board
class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def index
    @tasks = Task.all
    @board = Board.find(params[:board_id])
  end

  def show
    @task = Task.find(params[:id])
    @board = @task.board
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
    @task.user_id = current_user.id
    if @task.save
      redirect_to board_task_path(board_id: @board.id, id: @task.id), notice: 'タスクを追加'
    else
      flash.now[:error] = '更新できませんでした'
      render :new
    end
  end

  def edit
    @board = current_user.boards.find(params[:board_id])
    @task = @board.tasks.find(params[:id])
  end

  def update
    @board = Board.find(params[:board_id])
    @task = current_user.boards.find(params[:board_id]).tasks.find(params[:id])
    @task.user_id = current_user.id
    if @task.update(task_params)
      redirect_to board_task_path(board_id: @board.id, id: @task.id), notice: '更新できました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @board = current_user.boards.find(params[:board_id])
    @task = @board.tasks.find(params[:id])
    @task.destroy!
    redirect_to root_path, notice: '削除に成功しました'
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :eyecatch)
  end
end
