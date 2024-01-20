public class QuestionFour {
    public static void main(String[] args){
        QuestionFour classCaller = new QuestionFour();
        int[][] board = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
        classCaller.display_board(board);

        // Implement the solving algorithm

    }
    public int[][] move_piece(int[][] board, int subject, int target){
        if (board[target/3][target%3] != 9){
            return board;  // The piece can only be moved to an empty square
        }
        board[target/3][target%3] = board[subject/3][subject%3];
        board[subject/3][subject%3] = 9;
        return board;
    }
    public boolean correctPosition(int[][] board, int place){
        return (board[place/3][place%3] == place);
    }
    public void display_board(int[][] board){
        for (int[] row : board){
            for (int column : row){
                System.out.print(column + " ");
            }
            System.out.print('\n');
        }
    }





}
