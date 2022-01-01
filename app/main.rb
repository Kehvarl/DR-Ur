class Board
  def initialize(args, size=45)
    @args = args
    @turn = 0
    @move_from = 0
    @move_to = 0
    @size = size
    @p1_stock = 7
    @p1_score = 0
    @p2_stock = 7
    @p2_score = 0
    @board = [[2, 1, 2],[1, 1, 1],[1, 1, 1],[1, 2, 1],[0, 1, 0],[0, 1, 0],[1, 1, 1], [2, 1, 2]]
    @pieces = [[0, 0, 0],[0, 0, 2],[0, 0, 0],[1, 0, 2],[0, 0, 0],[0, 0, 0],[0, 0, 0], [0, 0, 0]]

  end

  def render_player_stats
    board_left = 1280/2 - (3 * @size)
    board_right = 1280/2 + (3 * @size)
    board_top = 720/2 + (8 * @size / 2)

    @args.outputs.primitives << [board_left - 45, board_top, "Player 1"].labels
    @args.outputs.primitives << [board_left - 45, board_top - 30, "Pieces: #{@p1_stock}"].labels
    @args.outputs.primitives << [board_left - 45, board_top - 60, "Score: #{@p1_score}"].labels
    
    @args.outputs.primitives << [board_right - 45, board_top, "Player 2"].labels
    @args.outputs.primitives << [board_right - 45, board_top - 30, "Pieces: #{@p2_stock}"].labels
    @args.outputs.primitives << [board_right - 45, board_top - 60, "Score: #{@p2_score}"].labels
  end

  def render_plays
    center_x = 1280/2 - (3 * @size / 2)
    center_y = 720/2 - (8 * @size / 2)
    sprites = ['', 'sprites/hexagon/green.png', 'sprites/hexagon/gray.png']
    (0..7).each do |y|
      (0..2).each do |x|
        pos_x = center_x + x * @size
        pos_y = center_y + y * @size
        if @pieces[y][x] > 0
          @args.outputs.primitives << [pos_x, pos_y, @size, @size, sprites[@pieces[y][x]], -90].sprites
        end
      end
    end
  end

  def render_board()
    center_x = 1280/2 - (3 * @size / 2)
    center_y = 720/2 - (8 * @size / 2)
    color = [[0,0,0],[255,255,255],[0,255,255]]
    (0..7).each do |y|
      (0..2).each do |x|
        pos_x = center_x + x * @size
        pos_y = center_y + y * @size
        @args.outputs.primitives << [pos_x, pos_y, @size, @size, *color[@board[y][x]]].solids
        @args.outputs.primitives << [pos_x, pos_y, @size, @size].borders
      end
    end
  end

  def render_start()
    w, h = @args.gtk.calcstringbox("Press Space to Stary", 0, "font.ttf")
    @args.outputs.primitives << [1280/2 , 720 - h - h, "Press Space to Start", 10, 1].labels
    if @args.inputs.keyboard.space
      @turn = 1
    end

  end

  def player1_turn()

  end

  def player2_turn()

  end

  def tick()
    render_board()
    render_plays()
    render_player_stats()
    case @turn
    when 0
      render_start
    when 1
      player1_turn
    when 2
      player2_turn
    end
  end
end

def tick args
  args.state.board ||= Board.new args
  args.state.board.tick
end
