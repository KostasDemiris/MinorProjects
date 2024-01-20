import java.util.ArrayList;

public class QuestionOne {
    public static void main(String[] args){
        Input in = new Input(System.in);
        QuestionOne classCaller = new QuestionOne();
        System.out.println("Please enter the file path name: ");
        classCaller.char_classification(classCaller.readFile(in.nextLine()));

    }

    public Character[] readFile(String pathName){
        FileInput fileIn = new FileInput(pathName);
        ArrayList<Character> chars = new ArrayList<>();
        while (fileIn.hasNextChar()){
            chars.add(fileIn.nextChar());
        }
        return chars.toArray(new Character[0]);
    }

    public void char_classification(Character[] chars){
        int word_count = 0; int char_count = 0; int line_count = 0;
//        for (Character character : chars){
//            if (Character.isAlphabetic(character)){
//                char_count += 1;
//            }
//            else{
//                if (character == '\n'){
//                    line_count += 1;
//                }
//                word_count += 1;
//            }
//        }
        Boolean followingWord = false;
        for (int index = 0; index < chars.length; index++) {
            if (Character.isAlphabetic(chars[index])) {
                char_count += 1;
                followingWord = true;
            } else {
                if (chars[index] == '\n') {
                    line_count += 1;
                } else {
                    if (followingWord) {
                        word_count += 1;
                        followingWord = false;
                    }
                }
            }
        }
        if (followingWord){
            word_count += 1;
        }

        line_count += 1;
        System.out.println("The word count is: " + word_count + " While the character count is: " + char_count);
        System.out.println("The line count is: " + line_count);
    }
}
