class Chess

    attr_accessor :board, :game_status, :input, :last_casualty, :player_turn 

    #pawn promotion*************************************
    def initialize
        if Dir.empty?("savegames")
            puts "Couldn't found any saved game."
            reset
        else
            puts "Would you like to start a new game or load saved game? (N/L)"
            decision = ""
            while decision != "N" && decision != "L"
                decision = gets.chomp.upcase
                puts "Error: Input 'N' for new game or 'L' load game." if decision != "N" && decision != "L"
            end
            if decision == "N"
                reset
            elsif decision == "L"
                puts "Saved games listed below."
                list_num = 1
                Dir.each_child("savegames") do |file| 
                    puts "#{list_num}. #{file}"
                end 
                file_num = 0
                while file_num < 1 || file_num > list_num
                    puts "Input number next to file name for load game."
                    file_num = gets.chomp
                    file_num = file_num.match(/\D/) ? -1 : file_num.to_i
                end
                file_to_load = Dir.childeren("savegames")[file_num-1] #**************test this**************
                puts "Loading #{file_num}. #{file_to_load}..."
                @game_status = true
                @last_casualty = nil
                @input = nil
                row_i=0
                col_i=0
                load_num = 0
                File.readlines(file_to_load) do |line|
                    if load_num == 0
                        @player_turn = line
                    elsif load_num == 1
                        @castling_available_for_player_1 = line
                    elsif load_num == 2
                        @castling_available_for_player_2 = line
                    else
                        if line == ""
                            @board[row_i][col_i] = ""
                        else
                            loaded_piece = line.split(",")
                            @board[row_i][col_i] = loaded_piece
                        end
                        col_i += 1
                            if col_i > 7
                                col_i = 0
                                row_i += 1
                                if row_i > 7
                                    row_i = 0
                                end
                            end
                    end
                    load_num += 1
                end
            end
        end
    end

    def print_board
        puts "  0   1   2   3   4   5   6   7"
        row_num = 0
        @board.each do |r|
            puts "---------------------------------"
            print "|"
            r.each do |c|
                if c == ""
                    print "   "
                elsif c[0] == "player_1"
                    if c[1] == "pawn"
                        print " ♙ "
                    elsif c[1] == "bishop"
                        print " ♗ "
                    elsif c[1] == "knight"
                        print " ♘ "
                    elsif c[1] == "rook"
                        print " ♖ "
                    elsif c[1] == "queen"
                        print " ♕ "
                    elsif c[1] == "king"
                        print " ♔ "
                    end
                elsif c [0] == "player_2"
                    if c[1] == "pawn"
                        print " ♟ "
                    elsif c[1] == "bishop"
                        print " ♝ "
                    elsif c[1] == "knight"
                        print " ♞ "
                    elsif c[1] == "rook"
                        print " ♜ "
                    elsif c[1] == "queen"
                        print " ♛ "
                    elsif c[1] == "king"
                        print " ♚ "
                    end
                end
                print "|"
            end
            print " #{row_num}"
            puts ""
            row_num += 1
        end
        puts "---------------------------------"
    end

    def play 
        while @game_status
            @last_casualty = nil
            print_board
            
                puts "Please enter the cordinations of the chess piece you would like to select."
                selected = select_piece_menu("select")
                if @input == castling
                    pass_turn
                    next
                end
                target = select_piece_menu("target")
                if @input == castling
                    pass_turn
                    next
                end
                while move_piece(selected,target) == "invalid move"
                    puts "Invalid move. Please try again."
                    selected = select_piece_menu("select")
                    if @input == "exit"
                        @game_status = false
                        puts "Exiting game..."
                        return
                    elsif @input == "save"
                        puts "Saving and exiting game..."
                        save_game
                        @game_status = false
                        return
                    elsif @input == "reset"
                        reset
                    elsif @input == "save and reset"
                        puts "Saving and starting new game..."
                        save_and_reset
                    end
                    target = select_piece_menu("target")
                    if @input == "exit"
                        @game_status = false
                        puts "Exiting game..."
                        return
                    elsif @input == "save"
                        puts "Saving and exiting game..."
                        save_game
                        @game_status = false
                        return
                    elsif @input == "reset"
                        reset
                    elsif @input == "save and reset"
                        puts "Saving and starting new game..."
                        save_and_reset
                    end
                end
                if @player_turn == "player_1"
                    if @board[7].any? { |p| p == ["player_1","pawn"] }
                        promote_pawn(7,@board[7].index(["player_1","pawn"]))
                    end
                else
                    if @board[0].any? { |p| p == ["player_2","pawn"] }
                        promote_pawn(0,@board[0].index(["player_2","pawn"]))
                    end
                end
                @game_status = false if won? == true
                pass_turn
            
        end
    end
    
    def pass_turn
        @player_turn = @player_turn == "player_1" ? "player_2" : "player_1"
    end

    def save_game
        file_name = Date.new
        line_num = 0
        File.open(file_name,"w") do |line|
            if line_num == 0
                line = @player_turn
            elsif line_num == 1
                line = @castling_available_for_player_1
            elsif line_num == 2
                line = @castling_available_for_player_2
            else
                @board.each do |r|
                    r.each do |c|
                        if c == ""
                            line = ""
                        else
                            line = "#{c[0]},#{c[1]}"
                        end
                    end
                end
            end
            line_num += 1
        end 
    end

    def save_and_reset
        save_game
        reset
    end

    def select_piece_menu(opt)
        row = nil
        col = nil
        while row == nil || row < 0 || row > 7
            puts "Row:"
            @input = gets.chomp
            return if @input == "exit" || @input == "save" || @input == "reset" || @input == "save and reset"
            if @input == "castling"
                if @player_turn == "player_1" && @castling_available_for_player_1
                    castling
                    return
                elsif @player_turn == "player_2" && @castling_available_for_player_2
                    castling
                    return
                else
                    puts "You can't make castling move. Try another move:"
                    @input = -1
                end
            end
            row = @input.match(/\D/) ? -1 : @input.to_i
            puts "Invalid input. Please try again." if row == nil || row < 0 || row > 7
        end
        while col == nil || col < 0 || col > 7
            puts "Column:"
            @input = gets.chomp
            return if @input == "exit" || @input == "save" || @input == "reset" || @input == "save and reset"
            if @input == "castling"
                if @player_turn == "player_1" && @castling_available_for_player_1
                    castling
                    return
                elsif @player_turn == "player_2" && @castling_available_for_player_2
                    castling
                    return
                else
                    puts "You can't make castling move. Try another move:"
                    @input = -1
                end
            end
            col = @input.match(/\D/) ? -1 : @input.to_i
            puts "Invalid input. Please try again." if col == nil || col < 0 || col > 7
        end
        if opt == "select"
            if @board[row][col] == ""
                puts "You've selected empty square. Please select one of your chess piece."
                select_piece_menu("select") 
            elsif @board[row][col][0] != @player_turn
                puts "#{@board[row][col]} is your opponent's chess piece. Please select one of your chess piece."
                select_piece_menu("select") 
            end
            puts "You've selected #{@board[row][col]}"
        elsif opt == "target"
            if @board[row][col][0] == @player_turn
                puts "Target destination already occupied by one of your chess piece. Please try Again."
                select_piece_menu("target")
            end
        end
        return [row,col]
    end

    def move_piece(sel,des)
        selected_piece = @board[sel[0]][sel[1]]
        moves = available_moves(selected_piece[1],sel)
        return "invalid move" if @board[sel[0]][sel[1]] == ""
        return "invalid move" if @board[sel[0]][sel[1]][0] != @player_turn
        return "invalid move" if moves.nil?
        return "invalid move" if moves.include?(des) == false
        @last_casualty = @board[des[0]][des[1]][1] if @board[des[0]][des[1]][1] != nil
        @board[sel[0]][sel[1]] = ""
        @board[des[0]][des[1]] = selected_piece
        return @board[des[0]][des[1]] 
    end

    def reset
        puts "Starting new game..."
        @board = Array.new(8) { |r| Array.new(8) { |c| "" } }
        @board[0][0] = ["player_1","rook"]
        @board[0][1] = ["player_1","knight"]
        @board[0][2] = ["player_1","bishop"]
        @board[0][3] = ["player_1","queen"]
        @board[0][4] = ["player_1","king"]
        @board[0][5] = ["player_1","bishop"]
        @board[0][6] = ["player_1","knight"]
        @board[0][7] = ["player_1","rook"]
        @board[1].collect! { |c| c = ["player_1","pawn"] }
        @board[6].collect! { |c| c = ["player_2","pawn"] }
        @board[7][0] = ["player_2","rook"]
        @board[7][1] = ["player_2","knight"]
        @board[7][2] = ["player_2","bishop"]
        @board[7][3] = ["player_2","queen"]
        @board[7][4] = ["player_2","king"]
        @board[7][5] = ["player_2","bishop"]
        @board[7][6] = ["player_2","knight"]
        @board[7][7] = ["player_2","rook"]
        @player_turn = rand(2) == 1 ? "player_2" : "player_1"
        @game_status = true
        @last_casualty = nil
        @input = nil 
        @castling_available_for_player_1 = true
        @castling_available_for_player_2 = true
    end

    def won?
        if @last_casualty == "king"
            p "#{player_turn} has won!"
            return true
        end
        return false
    end

    def castling
        if @player_turn == "player_1" && @castling_available_for_player_1
            if @board[0][5] == "" && @board[0][6] == ""
                @board[0][4] = ""
                @board[0][7] = ""
                @board[0][6] = ["player_1","king"]
                @board[0][5] = ["player_1","rook"]
                @castling_available_for_player_1 = false
            else
                return "invalid move"
            end
        elsif @player_turn == "player_2" && @castling_available_for_player_2
            if @board[7][5] == "" && @board[7][6] == ""
                @board[7][4] = ""
                @board[7][7] = ""
                @board[7][6] = ["player_2","king"]
                @board[7][5] = ["player_2","rook"]
                @castling_available_for_player_2 = false
            else
                return "invalid move"
            end
        else
            return "invalid move"
        end
    end

    def promote_pawn(row,col)
        puts "Congratulations! Your pawn deserved a promotion!"
        choice = 0
        while choice < 1 || choice > 4
            puts "Promote your pawn by entering number next to positions listed below:"
            puts "1. Queen"
            puts "2. Knight"
            puts "3. Rook"
            puts "4. Bishop"
            choice = gets.chomp
            choice = choice.match(/\D/) ? -1 : choice.to_i
            puts "Invalid input. Please try again." if choice < 1 || choice > 4
        end
        if choice == 1
            @board[row][col] = [@player_turn,"queen"]
        elsif choice == 2
            @board[row][col] = [@player_turn,"knight"]
        elsif choice == 3
            @board[row][col] = [@player_turn,"rook"]
        elsif choice == 4
            @board[row][col] = [@player_turn,"bishop"]
        end
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
        elsif piece == "bishop" 
            nx = x+1
            ny = y+1
            while @board[nx][ny] == "" && nx < 8 && ny < 8
                store_moves << [nx,ny]
                nx += 1
                ny += 1
            end
            if nx < 8 && ny < 8
                store_moves << [nx,ny] if @board[nx][ny][0] != @player_turn 
            end
            nx = x-1
            ny = y+1
            while @board[nx][ny] == "" && nx >= 0 && ny < 8
                store_moves << [nx,ny]
                nx -= 1
                ny += 1
            end
            if ny < 8
                store_moves << [nx,ny] if @board[nx][ny][0] != @player_turn && nx >= 0
            end
            nx = x+1
            ny = y-1
            while @board[nx][ny] == "" && nx < 8 && ny >= 0
                store_moves << [nx,ny]
                nx += 1
                ny -= 1
            end
            if nx < 8
                store_moves << [nx,ny] if @board[nx][ny][0] != @player_turn && ny >= 0
            end
            nx = x-1
            ny = y-1
            while @board[nx][ny] == "" && nx >= 0 && ny >= 0
                store_moves << [nx,ny]
                nx -= 1
                ny -= 1
            end
            store_moves << [nx,ny] if @board[nx][ny][0] != @player_turn && nx >= 0 && ny >= 0
        elsif piece == "knight"
            store_moves << [x+2,y+1] if x+2 < 8 && y+1 < 8 && @board[x+2][y+1][0] != @player_turn
            store_moves << [x-2,y+1] if x-2 >= 0 && y+1 < 8 && @board[x-2][y+1][0] != @player_turn
            store_moves << [x+2,y-1] if x+2 < 8 && y-1 >= 0 && @board[x+2][y-1][0] != @player_turn
            store_moves << [x-2,y-1] if x-2 >= 0 && y-1 >= 0 && @board[x-2][y-1][0] != @player_turn
            store_moves << [x+1,y+2] if x+1 < 8 && y+2 < 8 && @board[x+1][y+2][0] != @player_turn
            store_moves << [x-1,y+2] if x-1 >= 0 && y+2 < 8 && @board[x-1][y+2][0] != @player_turn
            store_moves << [x+1,y-2] if x+1 < 8 && y-2 >= 0 && @board[x+1][y-2][0] != @player_turn
            store_moves << [x-1,y-2] if x-1 >= 0 && y-2 >= 0 && @board[x-1][y-2][0] != @player_turn
        elsif piece == "rook"
            if @player_turn == "player_1"
                @castling_available_for_player_1 = false
            else
                @castling_available_for_player_2 = false
            end
            
            nx = x+1
            while @board[nx][y] == "" && nx < 8
                store_moves << [nx,y]
                nx += 1
            end
            if nx < 8
                store_moves << [nx,y] if @board[nx][y][0] != @player_turn 
            end
            nx = x-1
            while @board[nx][y] == "" && nx >= 0
                store_moves << [nx,y]
                nx -= 1
            end
            store_moves << [nx,y] if @board[nx][y][0] != @player_turn && nx >= 0
            ny = y+1
            while @board[x][ny] == "" && ny < 8
                store_moves << [x,ny]
                ny += 1
            end
            if ny < 8
                store_moves << [x,ny] if @board[x][ny][0] != @player_turn 
            end
            ny = y-1
            while @board[x][ny] == "" && ny >= 0
                store_moves << [x,ny]
                ny -= 1
            end
            store_moves << [x,ny] if @board[x][ny][0] != @player_turn && ny >= 0
        elsif piece == "queen" 
            nx = x+1
            while @board[nx][y] == "" && nx < 8
                store_moves << [nx,y]
                nx += 1
            end
            if nx < 8
                store_moves << [nx,y] if @board[nx][y][0] != @player_turn 
            end
            nx = x-1
            while @board[nx][y] == "" && nx >= 0
                store_moves << [nx,y]
                nx -= 1
            end
            store_moves << [nx,y] if @board[nx][y][0] != @player_turn && nx >= 0
            ny = y+1
            while @board[x][ny] == "" && ny < 8
                store_moves << [x,ny]
                ny += 1
            end
            if ny < 8
                store_moves << [x,ny] if @board[x][ny][0] != @player_turn 
            end
            ny = y-1
            while @board[x][ny] == "" && ny >= 0
                store_moves << [x,ny]
                ny -= 1
            end
            store_moves << [x,ny] if @board[x][ny][0] != @player_turn && ny >= 0
            nx = x+1
            ny = y+1
            while @board[nx][ny] == "" && nx < 8 && ny < 8
                store_moves << [nx,ny]
                nx += 1
                ny += 1
            end
            if nx < 8 && ny < 8
                store_moves << [nx,ny] if @board[nx][ny][0] != @player_turn
            end
            nx = x-1
            ny = y+1
            while @board[nx][ny] == "" && nx >= 0 && ny < 8
                store_moves << [nx,ny]
                nx -= 1
                ny += 1
            end
            if ny < 8
                store_moves << [nx,ny] if @board[nx][ny][0] != @player_turn && nx >= 0
            end
            nx = x+1
            ny = y-1
            while @board[nx][ny] == "" && nx < 8 && ny >= 0
                store_moves << [nx,ny]
                nx += 1
                ny -= 1
            end
            if nx < 8
                store_moves << [nx,ny] if @board[nx][ny][0] != @player_turn && ny >= 0
            end
            nx = x-1
            ny = y-1
            while @board[nx][ny] == "" && nx >= 0 && ny >= 0
                store_moves << [nx,ny]
                nx -= 1
                ny -= 1
            end
            store_moves << [nx,ny] if @board[nx][ny][0] != @player_turn && nx >= 0 && ny >= 0
        elsif piece == "king"
            if @player_turn == "player_1"
                @castling_available_for_player_1 = false
            else
                @castling_available_for_player_2 = false
            end
            
            store_moves << [x+1,y] if x+1 < 8 && @board[x+1][y] == "" && @board[x+1][y][0] != @player_turn
            store_moves << [x+1,y+1] if x+1 < 8 && y+1 < 8 && @board[x+1][y+1] == "" && @board[x+1][y+1][0] != @player_turn
            store_moves << [x+1,y-1] if x+1 < 8 && y-1 >= 0 && @board[x+1][y-1] == "" && @board[x+1][y-1][0] != @player_turn
            store_moves << [x,y+1] if y+1 < 8 && @board[x][y+1] == "" && @board[x][y+1][0] != @player_turn
            store_moves << [x,y-1] if y-1 >= 0 && @board[x][y-1] == "" && @board[x][y-1][0] != @player_turn
            store_moves << [x-1,y] if x-1 >= 0 && @board[x-1][y] == "" && @board[x-1][y][0] != @player_turn
            store_moves << [x-1,y+1] if x-1 >= 0 && y+1 < 8 && @board[x-1][y+1] == "" && @board[x-1][y+1][0] != @player_turn
            store_moves << [x-1,y-1] if x-1 >= 0 && y-1 >= 0 && @board[x-1][y-1] == "" && @board[x-1][y-1][0] != @player_turn
        else
            store_moves = nil
        end

        return store_moves
    end
end

chess = Chess.new 
chess.print_board
