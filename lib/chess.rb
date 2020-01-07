class Chess

    attr_accessor :board, :game_status, :input, :last_casualty, :player_turn 

    def initialize
        @board = Array.new(8) { |r| Array.new(8) { |c| "" } }
        #@board[0] ***************************************
        @board[1].collect! { |c| c = ["player_1","pawn"] }
        @board[6].collect! { |c| c = ["player_2","pawn"] }
        #@board[7] ***************************************
        @player_turn = rand(2) == 1 ? "player_2" : "player_1"
        @game_status = true
        @last_casualty = nil
        @input = nil 
    end

    def print_board
    end

    def play 
        while @game_status
            @last_casualty = nil
            if @player_turn == "player_1"
                p "Please enter the cordinations of the chess piece you would like to select."
                selected = select_piece_menu("select")
                target = select_piece_menu("target")
            else
            end
            @game_status = false if won? == true
        end
    end

    def select_piece_menu(opt)
        row = nil
        col = nil
        while row == nil || row < 0 || row > 7
            p "Row:"
            row = Integer(gets.chomp)
            p "Invalid input. Please try again." if row == nil || row < 0 || row > 7
        end
        while col == nil || col < 0 || col > 7
            p "Column:"
            col = Integer(gets.chomp)
            p "Invalid input. Please try again." if col == nil || col < 0 || col > 7
        end
        if opt == "select"
            if @board[row][col] == ""
                p "You've selected empty square. Please select one of your chess piece."
                select_piece_menu("select") 
            elsif @board[row][col][0] != @player_turn
                p "#{@board[row][col]} is your opponent's chess piece. Please select one of your chess piece."
                select_piece_menu("select") 
            end
            p "You've selected #{@board[row][col]}"
        elsif opt == "target"
            if @board[row][col][0] == @player_turn
                p "Target destination already occupied by one of your chess piece. Please try Again."
                select_piece_menu("target")
            end
        end
        return [row,col]
    end

    def move_piece(sel,des)
        selected_piece = @board[sel[0]][sel[1]]
        moves = available_moves(selected_piece,sel)
        return "invalid move" if moves.include?(des) == false
        destination = @board[des[0]][des[1]]
        @last_casualty = @board[des[0]][des[1]][0] if @board[des[0]][des[1]][0] != nil
        @board[sel[0]][sel[1]] = ""
        @board[des[0]][des[1]] = selected_piece
    end

    def reset
        @board = Array.new(8) { |r| Array.new(8) { |c| "" } }
        #@board[0] ***************************************
        @board[1].collect! { |c| c = ["player_1","pawn"] }
        @board[6].collect! { |c| c = ["player_2","pawn"] }
        #@board[7] ***************************************
        @player_turn = rand(2) == 1 ? "player_2" : "player_1"
        @game_status = true
        @casualty = nil
        @input = nil 
    end

    def won?
        if @last_casualty == "king"
            p "#{player_turn} has won!"
            return true
        end
        return false
    end

    def available_moves(piece,pos)
        store_moves = []
        x = pos[0]
        y = pos[1]

        if piece == "pawn" && @player_turn == "player_1"
            store_moves << [x+1,y] if x+1 < 8 && @board[x+1][y] == ""
            store_moves << [x+2,y] if x == 1 && @board[x+2][y] == ""
            store_moves << [x+1,y+1] if @board[x+1][y+1][0] == "player_2"
            store_moves << [x+1,y-1] if @board[x+1][y-1][0] == "player_2"  
        elsif piece == "pawn" && @player_turn == "player_2"
            store_moves << [x-1,y] if x-1 >= 0 && @board[x-1][y] == ""
            store_moves << [x-2,y] if x == 6 && @board[x-2][y] == ""
            store_moves << [x-1,y+1] if @board[x-1][y+1][0] == "player_1"
            store_moves << [x-1,y-1] if @board[x-1][y-1][0] == "player_1" 
        elsif piece == "bishop" && @player_turn == "player_1"
            nx = x+1
            ny = y+1
            while @board[nx][ny] == "" && nx < 8 && ny < 8
                store_moves << [nx,ny]
                nx += 1
                ny += 1
            end
            store_moves << [nx+1,ny+1] if @board[nx+1][ny+1][0] == "player_2"
            nx = x-1
            ny = y+1
            while @board[nx][ny] == "" && nx >= 0 && ny < 8
                store_moves << [nx,ny]
                nx -= 1
                ny += 1
            end
            store_moves << [nx-1,ny+1] if @board[nx-1][ny+1][0] == "player_2" && nx-1 >= 0
            nx = x+1
            ny = y-1
            while @board[nx][ny] == "" && nx < 8 && ny >= 0
                store_moves << [nx,ny]
                nx += 1
                ny -= 1
            end
            store_moves << [nx+1,ny-1] if @board[nx+1][ny-1][0] == "player_2" && ny-1 >= 0
            nx = x-1
            ny = y-1
            while @board[nx][ny] == "" && nx >= 0 && ny >= 0
                store_moves << [nx,ny]
                nx -= 1
                ny -= 1
            end
            store_moves << [nx-1,ny-1] if @board[nx-1][ny-1][0] == "player_2" && nx-1 >= 0 && ny-1 >= 0
        elsif piece == "bishop" && @player_turn == "player_2"
            nx = x+1
            ny = y+1
            while @board[nx][ny] == "" && nx < 8 && ny < 8
                store_moves << [nx,ny]
                nx += 1
                ny += 1
            end
            store_moves << [nx+1,ny+1] if @board[nx+1][ny+1][0] == "player_1"
            nx = x-1
            ny = y+1
            while @board[nx][ny] == "" && nx >= 0 && ny < 8
                store_moves << [nx,ny]
                nx -= 1
                ny += 1
            end
            store_moves << [nx-1,ny+1] if @board[nx-1][ny+1][0] == "player_1" && nx-1 >= 0
            nx = x+1
            ny = y-1
            while @board[nx][ny] == "" && nx < 8 && ny >= 0
                store_moves << [nx,ny]
                nx += 1
                ny -= 1
            end
            store_moves << [nx+1,ny-1] if @board[nx+1][ny-1][0] == "player_1" && ny-1 >= 0
            nx = x-1
            ny = y-1
            while @board[nx][ny] == "" && nx >= 0 && ny >= 0
                store_moves << [nx,ny]
                nx -= 1
                ny -= 1
            end
            store_moves << [nx-1,ny-1] if @board[nx-1][ny-1][0] == "player_1" && nx-1 >= 0 && ny-1 >= 0
        elsif piece == "knight" && @player_turn == "player_1"
            store_moves << [x+2,y+1] if x+2 < 8 && y+1 < 8 && @board[x+2][y+1][0] != "player_1"
            store_moves << [x-2,y+1] if x-2 >= 0 && y+1 < 8 && @board[x-2][y+1][0] != "player_1"
            store_moves << [x+2,y-1] if x+2 < 8 && y-1 >= 0 && @board[x+2][y-1][0] != "player_1"
            store_moves << [x-2,y-1] if x-2 >= 0 && y-1 >= 0 && @board[x-2][y-1][0] != "player_1"
            store_moves << [x+1,y+2] if x+1 < 8 && y+2 < 8 && @board[x+1][y+2][0] != "player_1"
            store_moves << [x-1,y+2] if x-1 >= 0 && y+2 < 8 && @board[x-1][y+2][0] != "player_1"
            store_moves << [x+1,y-2] if x+1 < 8 && y-2 >= 0 && @board[x+1][y-2][0] != "player_1"
            store_moves << [x-1,y-2] if x-1 >= 0 && y-2 >= 0 && @board[x-1][y-2][0] != "player_1"
        elsif piece == "knight" && @player_turn == "player_2"
            store_moves << [x+2,y+1] if x+2 < 8 && y+1 < 8 && @board[x+2][y+1][0] != "player_2"
            store_moves << [x-2,y+1] if x-2 >= 0 && y+1 < 8 && @board[x-2][y+1][0] != "player_2"
            store_moves << [x+2,y-1] if x+2 < 8 && y-1 >= 0 && @board[x+2][y-1][0] != "player_2"
            store_moves << [x-2,y-1] if x-2 >= 0 && y-1 >= 0 && @board[x-2][y-1][0] != "player_2"
            store_moves << [x+1,y+2] if x+1 < 8 && y+2 < 8 && @board[x+1][y+2][0] != "player_2"
            store_moves << [x-1,y+2] if x-1 >= 0 && y+2 < 8 && @board[x-1][y+2][0] != "player_2"
            store_moves << [x+1,y-2] if x+1 < 8 && y-2 >= 0 && @board[x+1][y-2][0] != "player_2"
            store_moves << [x-1,y-2] if x-1 >= 0 && y-2 >= 0 && @board[x-1][y-2][0] != "player_2"
        elsif piece == "root" && @player_turn == "player_1"
            nx = x+1
            while @board[nx][y] && nx < 8
                store_moves << [nx,y]
                nx += 1
            end
            store_moves << [nx+1,y] if @board[nx+1,y][0] == "player_2" 
            nx = x-1
            while @board[nx][y] && nx >= 0
                store_moves << [nx,y]
                nx -= 1
            end
            store_moves << [nx-1,y] if @board[nx-1,y][0] == "player_2" && nx-1 >= 0
            ny = y+1
            while @board[x][ny] && ny < 8
                store_moves << [x,ny]
                ny += 1
            end
            store_moves << [x,ny+1] if @board[x,ny+1][0] == "player_2" 
            ny = y-1
            while @board[x][ny] && ny >= 0
                store_moves << [x,ny]
                ny -= 1
            end
            store_moves << [x,ny-1] if @board[x,ny-1][0] == "player_2" && ny-1 >= 0
        elsif piece == "root" && @player_turn == "player_1"
            nx = x+1
            while @board[nx][y] && nx < 8
                store_moves << [nx,y]
                nx += 1
            end
            store_moves << [nx+1,y] if @board[nx+1,y][0] == "player_1" 
            nx = x-1
            while @board[nx][y] && nx >= 0
                store_moves << [nx,y]
                nx -= 1
            end
            store_moves << [nx-1,y] if @board[nx-1,y][0] == "player_1" && nx-1 >= 0
            ny = y+1
            while @board[x][ny] && ny < 8
                store_moves << [x,ny]
                ny += 1
            end
            store_moves << [x,ny+1] if @board[x,ny+1][0] == "player_1" 
            ny = y-1
            while @board[x][ny] && ny >= 0
                store_moves << [x,ny]
                ny -= 1
            end
            store_moves << [x,ny-1] if @board[x,ny-1][0] == "player_1" && ny-1 >= 0
        elsif piece == "queen" && @player_turn == "player_1"
            nx = x+1
            while @board[nx][y] && nx < 8
                store_moves << [nx,y]
                nx += 1
            end
            store_moves << [nx+1,y] if @board[nx+1,y][0] == "player_2" 
            nx = x-1
            while @board[nx][y] && nx >= 0
                store_moves << [nx,y]
                nx -= 1
            end
            store_moves << [nx-1,y] if @board[nx-1,y][0] == "player_2" && nx-1 >= 0
            ny = y+1
            while @board[x][ny] && ny < 8
                store_moves << [x,ny]
                ny += 1
            end
            store_moves << [x,ny+1] if @board[x,ny+1][0] == "player_2" 
            ny = y-1
            while @board[x][ny] && ny >= 0
                store_moves << [x,ny]
                ny -= 1
            end
            store_moves << [x,ny-1] if @board[x,ny-1][0] == "player_2" && ny-1 >= 0
            nx = x+1
            ny = y+1
            while @board[nx][ny] == "" && nx < 8 && ny < 8
                store_moves << [nx,ny]
                nx += 1
                ny += 1
            end
            store_moves << [nx+1,ny+1] if @board[nx+1][ny+1][0] == "player_2"
            nx = x-1
            ny = y+1
            while @board[nx][ny] == "" && nx >= 0 && ny < 8
                store_moves << [nx,ny]
                nx -= 1
                ny += 1
            end
            store_moves << [nx-1,ny+1] if @board[nx-1][ny+1][0] == "player_2" && nx-1 >= 0
            nx = x+1
            ny = y-1
            while @board[nx][ny] == "" && nx < 8 && ny >= 0
                store_moves << [nx,ny]
                nx += 1
                ny -= 1
            end
            store_moves << [nx+1,ny-1] if @board[nx+1][ny-1][0] == "player_2" && ny-1 >= 0
            nx = x-1
            ny = y-1
            while @board[nx][ny] == "" && nx >= 0 && ny >= 0
                store_moves << [nx,ny]
                nx -= 1
                ny -= 1
            end
            store_moves << [nx-1,ny-1] if @board[nx-1][ny-1][0] == "player_2" && nx-1 >= 0 && ny-1 >= 0
        elsif piece == "queen" && @player_turn == "player_2"
            nx = x+1
            while @board[nx][y] && nx < 8
                store_moves << [nx,y]
                nx += 1
            end
            store_moves << [nx+1,y] if @board[nx+1,y][0] == "player_1" 
            nx = x-1
            while @board[nx][y] && nx >= 0
                store_moves << [nx,y]
                nx -= 1
            end
            store_moves << [nx-1,y] if @board[nx-1,y][0] == "player_1" && nx-1 >= 0
            ny = y+1
            while @board[x][ny] && ny < 8
                store_moves << [x,ny]
                ny += 1
            end
            store_moves << [x,ny+1] if @board[x,ny+1][0] == "player_1" 
            ny = y-1
            while @board[x][ny] && ny >= 0
                store_moves << [x,ny]
                ny -= 1
            end
            store_moves << [x,ny-1] if @board[x,ny-1][0] == "player_1" && ny-1 >= 0
            nx = x+1
            ny = y+1
            while @board[nx][ny] == "" && nx < 8 && ny < 8
                store_moves << [nx,ny]
                nx += 1
                ny += 1
            end
            store_moves << [nx+1,ny+1] if @board[nx+1][ny+1][0] == "player_1"
            nx = x-1
            ny = y+1
            while @board[nx][ny] == "" && nx >= 0 && ny < 8
                store_moves << [nx,ny]
                nx -= 1
                ny += 1
            end
            store_moves << [nx-1,ny+1] if @board[nx-1][ny+1][0] == "player_1" && nx-1 >= 0
            nx = x+1
            ny = y-1
            while @board[nx][ny] == "" && nx < 8 && ny >= 0
                store_moves << [nx,ny]
                nx += 1
                ny -= 1
            end
            store_moves << [nx+1,ny-1] if @board[nx+1][ny-1][0] == "player_1" && ny-1 >= 0
            nx = x-1
            ny = y-1
            while @board[nx][ny] == "" && nx >= 0 && ny >= 0
                store_moves << [nx,ny]
                nx -= 1
                ny -= 1
            end
            store_moves << [nx-1,ny-1] if @board[nx-1][ny-1][0] == "player_1" && nx-1 >= 0 && ny-1 >= 0
        elsif piece == "king" && @player_turn == "player_1"
            store_moves << [x+1,y] if x+1 < 8 && @board[x+1][y] == "" && @board[x+1][y][0] == "player_2"
            store_moves << [x+1,y+1] if x+1 < 8 && y+1 < 8 && @board[x+1][y+1] == "" && @board[x+1][y+1][0] == "player_2"
            store_moves << [x+1,y-1] if x+1 < 8 && y-1 >= 0 && @board[x+1][y-1] == "" && @board[x+1][y-1][0] == "player_2"
            store_moves << [x,y+1] if y+1 < 8 && @board[x][y+1] == "" && @board[x][y+1][0] == "player_2"
            store_moves << [x,y-1] if y-1 >= 0 && @board[x][y-1] == "" && @board[x][y-1][0] == "player_2"
            store_moves << [x-1,y] if x-1 >= 0 && @board[x-1][y] == "" && @board[x-1][y][0] == "player_2"
            store_moves << [x-1,y+1] if x-1 >= 0 && y+1 < 8 && @board[x-1][y+1] == "" && @board[x-1][y+1][0] == "player_2"
            store_moves << [x-1,y-1] if x-1 >= 0 && y-1 >= 0 && @board[x-1][y-1] == "" && @board[x-1][y-1][0] == "player_2"
        elsif piece == "king" && @player_turn == "player_2"
            store_moves << [x+1,y] if x+1 < 8 && @board[x+1][y] == "" && @board[x+1][y][0] == "player_1"
            store_moves << [x+1,y+1] if x+1 < 8 && y+1 < 8 && @board[x+1][y+1] == "" && @board[x+1][y+1][0] == "player_1"
            store_moves << [x+1,y-1] if x+1 < 8 && y-1 >= 0 && @board[x+1][y-1] == "" && @board[x+1][y-1][0] == "player_1"
            store_moves << [x,y+1] if y+1 < 8 && @board[x][y+1] == "" && @board[x][y+1][0] == "player_1"
            store_moves << [x,y-1] if y-1 >= 0 && @board[x][y-1] == "" && @board[x][y-1][0] == "player_1"
            store_moves << [x-1,y] if x-1 >= 0 && @board[x-1][y] == "" && @board[x-1][y][0] == "player_1"
            store_moves << [x-1,y+1] if x-1 >= 0 && y+1 < 8 && @board[x-1][y+1] == "" && @board[x-1][y+1][0] == "player_1"
            store_moves << [x-1,y-1] if x-1 >= 0 && y-1 >= 0 && @board[x-1][y-1] == "" && @board[x-1][y-1][0] == "player_1"
        else
            store_moves = nil
        end

        return store_moves
    end
end