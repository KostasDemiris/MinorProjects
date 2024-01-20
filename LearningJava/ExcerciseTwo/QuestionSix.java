import java.util.ArrayList;
import java.util.List;

public class QuestionSix {
    public static void main(String[] args){
        QuestionSix classCaller = new QuestionSix();
        System.out.println("The parsing returned: " + classCaller.parseJavaBrackets(classCaller.readJavaFile()));

    }
    public String[] readJavaFile(){
        Input in = new Input(System.in);
        System.out.println("Please input the file that will be parsed: ");
        FileInput fileIn = new FileInput(in.nextLine());
        List<String> lines = new ArrayList<>();
        while (fileIn.hasNextLine()) {lines.add(fileIn.nextLine());}
        return lines.toArray(new String[0]);
    }
    public Boolean parseJavaBrackets(String[] lines){
        int startCount = 0, endCount = 0, slashCount = 0;
        boolean comment = false, string = false;
        for (String line : lines){
            for (char symbol : line.toCharArray()){
                switch (symbol){
                    case ('\n'): {comment = false; slashCount = 0;} break;
                    case ('/' ): {if (!comment && !string) {slashCount+=1;}} break;
                    case ('"'): {string = !string;} break;
                    case ('{'): {if (!comment && !string) {startCount+=1;}} break;
                    case ('}'): {if (!comment && !string) {endCount+=1;}} break;
                }
                if (slashCount >= 2){
                    slashCount = 0;
                    comment = true;
                }
            }
            slashCount = 0; string = false; comment = false;

//            System.out.println("State is: " );
//            System.out.println(startCount + " number of start curls");
//            System.out.println(endCount + " number of end curls");
//            System.out.println(comment + " is the value of comment");
//            System.out.println(string + " is the value of string");
//            System.out.println(slashCount + " is the current slash count");
        }
        System.out.println("Start count is " + startCount + " and finish count is " + endCount);
        return (startCount==endCount);
    }
}

