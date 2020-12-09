class V1::BoardsController < ApplicationController
  
  # 掲示板一覧
  def index
    @boards = Board.all
    render json: @boards
  end

  # 掲示板詳細
  def show
    @board = Board.includes({user: {avatar_attachment: :blob}}, :tags, :board_comments).find(params[:id])
    render json: @board.as_json(include: [{user: {methods: :avatar_url}},
                                            :tags,
                                            {board_comments: {include: {user: {methods: :avatar_url}}}}],
                                methods: :images_url)
  end

  # 掲示板新規作成
  def create
    @board = Board.new(board_content_params)
    sent_tags = board_tags_params[:tags] === nil ? [] : board_tags_params[:tags]
    if @board.save
      @board.save_tag(sent_tags)
      render json: @board, status: :created
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  # 掲示板削除
  def destroy
    @board = Board.find(params[:id])
    @board.destroy
  end

  # 掲示板検索
  def search

  end

  private

    def board_content_params
      params.require(:board).permit(:description, :user_id, images: [])
    end

    def board_tags_params
      params.require(:board).permit(tags: [])
    end

end
