class Board
  def initialize(args, size=60)
    @args = args
    @turn = 0
    @moved = false
    @move_from = 0
    @move_to = 0
    @size = size
    @p1_stock = 7
    @p1_score = 0
    @p2_stock = 7
    @p2_score = 0
    @roll = 0
    @board = [[2, 1, 2],[1, 1, 1],[1, 1, 1],[1, 2, 1],[0, 1, 0],[0, 1, 0],[1, 1, 1], [2, 1, 2]]
    @pieces = [[1, 2, 2],[1, 1, 2],[1, 2, 2],[0, 0, 0],[0, 0, 0],[0, 0, 0],[1, 2, 2], [1, 1, 2]]

  end

  def render_player_stats
    board_left = 1280/2 - (1.5 * @size)
    board_right = 1280/2 + (1.5 * @size)
    board_top = 720/2 + (8 * @size / 2)

    if @turn > 0
      @args.outputs.primitives << [board_left - @size * 8, board_top - @size * 6, "Use arrow keys to select piece to move"].labels
      @args.outputs.primitives << [board_left - @size * 8, board_top - @size * 6 - 20, "Press space to accept move"].labels
    end

    if @turn == 1
      @args.outputs.primitives << [board_left - @size * 5, board_top - @size*2, "#{@roll}", @size].labels
    elsif @turn == 2
      @args.outputs.primitives << [board_right + @size * 4, board_top - @size*2, "#{@roll}", @size].labels
    end

    if @p1_stock > 0
      @args.outputs.primitives << [board_left - @size - 5, board_top - @size * 5, @size, @size, 'sprites/circle/green.png'].sprites
    end
    @args.outputs.primitives << [board_left - 95, board_top, "Player 1"].labels
    @args.outputs.primitives << [board_left - 95, board_top - 30, "Pieces: #{@p1_stock}"].labels
    @args.outputs.primitives << [board_left - 95, board_top - 60, "Score: #{@p1_score}"].labels

    if @p2_stock > 0
      @args.outputs.primitives << [board_right + 5, board_top - @size * 5, @size, @size, 'sprites/circle/gray.png', 180].sprites
    end
    @args.outputs.primitives << [board_right + 5, board_top, "Player 2"].labels
    @args.outputs.primitives << [board_right + 5, board_top - 30, "Pieces: #{@p2_stock}"].labels
    @args.outputs.primitives << [board_right + 5, board_top - 60, "Score: #{@p2_score}"].labels
  end

  def render_plays
    center_x = 1280/2 - (3 * @size / 2)
    center_y = 720/2 - (8 * @size / 2)
    sprites = ['', 'sprites/circle/green.png', 'sprites/circle/gray.png']
    @pieces.each_with_index do |line, y|
      line.each_with_index do |cell, x|
        pos_x = center_x + x * @size
        pos_y = center_y + y * @size
        rotation = 0
        case x
          when 0
            if y == 0
              rotation = 0
            elsif
              rotation = -90
            end
          when 1
            rotation = 90
            if y == 7
              if cell == 1
                rotation = 180
              elsif cell == 2
                rotation = 0
              end
            end
          when 2
            if y == 0
              rotation = 180
            elsif
              rotation = -90
            end
        end
        if @pieces[y][x] > 0
          @args.outputs.primitives << [pos_x, pos_y, @size, @size, sprites[@pieces[y][x]], rotation].sprites
        end
      end
    end
  end

  def render_board()
    if @turn > 0
      w, h = @args.gtk.calcstringbox("The Royal Game of UR", 0, "font.ttf")
      @args.outputs.primitives << [1280/2 , 720 - h, "The Royal Game of UR", 15, 1].labels
    end
    center_x = 1280/2 - (3 * @size / 2)
    center_y = 720/2 - (8 * @size / 2)
    color = [[0,0,0],[255,255,255],[0,255,255]]
    @board.each_with_index do |line, y|
      line.each_with_index do |cell, x|
        pos_x = center_x + x * @size
        pos_y = center_y + y * @size
        @args.outputs.primitives << [pos_x, pos_y, @size, @size, *color[cell]].solids
        @args.outputs.primitives << [pos_x, pos_y, @size, @size].borders
      end
    end
  end

  def render_start()
    w, h = @args.gtk.calcstringbox("Press Space to Stary", 0, "font.ttf")
    @args.outputs.primitives << [1280/2 , 720 - h - h, "Press Space to Start", 10, 1].labels
    if @args.inputs.keyboard.key_down.space
      @turn = 1
      @p1_stock = 7
      @p1_score = 0
      @p2_stock = 7
      @p2_score = 0
      @pieces = [[0, 0, 0],[0, 0, 0],[0, 0, 0],[0, 0, 0],[0, 0, 0],[0, 0, 0],[0, 0, 0], [0, 0, 0]]
      @roll = rand(4) + 1
    end

  end

  def player1_turn()
    if @args.inputs.keyboard.key_down.up
      @move_from = max(@move_from - 1, 0)
    elsif @args.inputs.keyboard.key_down.down
    elsif @args.inputs.keyboard.key_down.space
      @turn = 2
      @roll = rand(4) + 1
    end
  end

  def player2_turn()
    if @args.inputs.keyboard.key_down.up
    elsif @args.inputs.keyboard.key_down.down
    elsif @args.inputs.keyboard.key_down.space
      @turn = 1
      @roll = rand(4) + 1
    end
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
