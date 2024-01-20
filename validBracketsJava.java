import java.util.ArrayList;
import java.util.List;

public class validBracketsJava {
    public static void main(String[] args){
        validBracketsJava classCaller = new validBracketsJava();
        System.out.println("Validity of Curl Brackets is " + classCaller.parseJavaStrings(classCaller.getJavaFile()));
    }

    public boolean parseJavaStrings(String[] lines){
        BracePairs mainBrace = new BracePairs();
        int initBraceOffset = -1, slashCount = 0;
        boolean comment = false, string = false;
        // Because we initialised a bracePair, which by default has an open left bracket,
        // we need to offset the first left bracket
        for (String line : lines){
            for (char symbol : line.toCharArray()){
                switch (symbol){
                    case ('\n'): {comment = false; slashCount = 0;} break;
                    case ('/' ): {if (!comment && !string) {slashCount+=1;}} break;
                    case ('"'): {string = !string;} break;
                    case ('{'): {
                        if (!comment && !string) {
                            if (initBraceOffset < 0){
                                initBraceOffset += 1;
                            }
                            else{
                                mainBrace.left_bracket();
                            }
                        }
                    } break;
                    case ('}'): {
                        if (!comment && !string) {
                            if (!mainBrace.right_bracket()){
                                return false;
                            }
                        }
                    } break;
                }
                if (slashCount >= 2){
                    slashCount = 0;
                    comment = true;
                }
            }
            slashCount = 0;
            comment = false;
        }
        System.out.println("The number of braces total is: " + mainBrace.generateReport().get("braces"));
        return mainBrace.closed(); // This should only be closed if mainBrace is closed
    }
    public String[] getJavaFile(){
        Input in = new Input(System.in);
        System.out.println("Please enter the java file to validate");
        try {
            FileInput fileIn = new FileInput(in.nextLine());
            List<String> lines = new ArrayList<>();
            while (fileIn.hasNextLine()){
                lines.add(fileIn.nextLine());
            }
            return lines.toArray(new String[0]);
        }
        catch (Exception exception) {
            System.out.println("That wasn't a valid file, try again...");
            return getJavaFile();
        }
    }

}
