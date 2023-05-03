class CommentsController < ApplicationController

  def new
    @board = Board.find(params[:board_id])
    @task = current_user.tasks.find(params[:task_id])    

    if current_user
      @comment = current_user.boards.find(params[:board_id]).tasks.find(params[:task_id]).comments.build
    else
      redirect_to new_user_session_path, notice: 'ログインしてください'
    end
  end

  def create
    @board = Board.find(params[:board_id])
    @task = @board.tasks.find(params[:task_id])
    @comment = current_user.boards.find(params[:board_id]).tasks.find(params[:task_id]).comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to board_task_path(board_id: @board.id, id: @task.id), notice: 'コメントを追加'
    else
      flash.now[:error] = '更新できませんでした'
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
