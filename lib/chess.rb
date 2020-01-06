class Chess

    attr_accessor :board, :game_status, :input, :last_casualty, :player_turn 

    def initialize
        @board = Array.new(8) { |r| Array.new(8) { |c| "#{r},#{c}" } }
        #@board[0] ***************************************
        @board[1].collect! { |c| c = ["player_1","pawn"] }
        @board[6].collect! { |c| c = ["player_2","pawn"] }
        #@board[7] ***************************************
        @player_turn = rand(2) == 1 ? "player_2" : "player_1"
        @game_status = true
        @last_casualty = nil
        @input = nil 
    end

    def play 
        while @game_status
        end
    end

    def move_piece(sel,des)
        selected_piece = @board[sel[0]][sel[1]]
        destination = @board[des[0]][des[1]]
    end

    def reset
        @board = Array.new(8) { |r| Array.new(8) { |c| "#{r},#{c}" } }
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