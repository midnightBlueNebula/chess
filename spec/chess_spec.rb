RSpec.describe Chess do

    chess = Chess.new

    describe "#move_piece" do
        it "should move selected piece without duplicate it." do
            chess.board[1][1] = ["player_1","pawn"]
            chess.board[2][1] = ""
            chess.board[0][2] = ["player_1","knight"]
            chess.board[1][4] = ""
            chess.move_piece([1,1],[2,1])
            chess.move_piece([0,2],[1,4])
            expect(chess.board[1][1]).to eql("")
            expect(chess.board[2][1]).to eql(["player_1","pawn"])
            expect(chess.board[0][2]).to eql("")
            expect(chess.board[1][4]).to eql(["player_1","knight"])
        end

        it "should take out opponent's chess piece if moved to its position." do
            chess.board[1,0] = ["player_1","pawn"]
            if chess.player_turn == "player_2"
                chess.move_piece([7,0],[1,0])
                expect(chess.board[1][0]).to eql(["player_2","root"])
                expect(chess.last_casualty).to eql("pawn")
            end
        end

        it "should not move if player's chess piece already in destination position." do
            chess.board[0][2] = ["player_1","knight"]
            chess.board[1][4] = ["player_1","pawn"]
            if chess.player_turn == "player_1"
                expect(chess.move_piece([0,2],[1,4])).to eql("invalid move")
            end
        end

        it "shouldn't move over chess piece unless moved piece is knight." do
            chess.board[5][0] = ["player_1","pawn"]
            chess.board[0][0] = ["player_1","root"]
            chess.board[1][1] = ["player_1","pawn"]
            chess.board[0][1] = ["player_1","knight"]
            chess.player_turn = "player_1"
            expect(chess.move_piece([0,0],[6,0])).to eql("invalid move")
            expect(chess.move_piece([0,1],[2,2]).to_not eql("invalid move")
        end

        it "should not move opponent's chess piece." do
            chess.board[4][0] = ["player_1","root"]
            chess.board[4][1] = ""
            chess.player_turn == "player_2"
            expect(chess.move_piece([4,0],[4,1])).to eql("invalid move")
        end
    end

    describe "#save_game" do
        it "should save the game's state correctly." do
        end
    end

    describe "#load_game" do
        it "should load the game according to its saved state." do
        end
    end

    describe "#game_status" do
        it "should return boolean value to check if program should be keep running or terminated." do
            if chess.input == "exit" || chess.won? == true
                expect(chess.game_status).to eql(false)
            end
        end
    end

    describe "#reset" do
        it "should reset the board to its beginnig state." do
            chess.board[4][4] = ["player_1","king"]
            chess.reset
            row = 2
            while row < 6 |r|
                col = 0
                while col < 8 |c|
                    expect(chess.board[r][c].all? { |a| a == "" }).to eql(true)
                    col += 1
                end
                row += 1
            end
        end
    end

    describe "#reset_and_save" do
        it "should save the current game before resetting the board." do
        end
    end

    describe "#won?" do
        it "should return true if one of player took out the opponent's king." do
            chess.board[7][4] = ["player_2","king"]
            chess.board[5][3] = ["player_1","knight"]
            chess.player_turn == "player_1"
            chess.move_piece([5,3],[7,4])
            expect(chess.won?).to eql(true)
        end
    end
end