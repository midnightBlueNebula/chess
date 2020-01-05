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
            store_moves << [nx-1,ny+1] if @board[nx-1][ny+1][0] == "player_2"
            nx = x+1
            ny = y-1
            while @board[nx][ny] == "" && nx < 8 && ny >= 0
                store_moves << [nx,ny]
                nx += 1
                ny -= 1
            end
            store_moves << [nx+1,ny-1] if @board[nx+1][ny-1][0] == "player_2"
            nx = x-1
            ny = y-1
            while @board[nx][ny] == "" && nx >= 0 && ny >= 0
                store_moves << [nx,ny]
                nx -= 1
                ny -= 1
            end
            store_moves << [nx-1,ny-1] if @board[nx-1][ny-1][0] == "player_2"
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
            store_moves << [nx-1,ny+1] if @board[nx-1][ny+1][0] == "player_1"
            nx = x+1
            ny = y-1
            while @board[nx][ny] == "" && nx < 8 && ny >= 0
                store_moves << [nx,ny]
                nx += 1
                ny -= 1
            end
            store_moves << [nx+1,ny-1] if @board[nx+1][ny-1][0] == "player_1"
            nx = x-1
            ny = y-1
            while @board[nx][ny] == "" && nx >= 0 && ny >= 0
                store_moves << [nx,ny]
                nx -= 1
                ny -= 1
            end
            store_moves << [nx-1,ny-1] if @board[nx-1][ny-1][0] == "player_1"
        end

        return store_moves
    end
end