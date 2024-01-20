import java.util.*;

public class QuestionFive {
    public static void main(String[] args){
        // /Users/kostasdemiris/Downloads/hold/textIn.txt is an example holder file
        // (i will probably overwrite the contents though at some point)
        QuestionFive classCaller = new QuestionFive();
        Input in = new Input(System.in);
        System.out.println("Please write the filepath of the hash dictionary source file: ");
        HashMap<String, String> hashMap = classCaller.readHashFile(in.nextLine());
        // System.out.println(hashMap.entrySet().toString());
        hashMap = classCaller.newWordPair(hashMap, "Banana", "Monke");
        System.out.println("Please input the file storing the hash: ");
        classCaller.updateHashFile(hashMap, in.nextLine());

    }
    public HashMap<String, String> newWordPair(HashMap<String, String> hashMap, String word, String meaning){
        if (hashMap.containsKey(word + " ")){
            // Put already will replace the word, but this way we at least know that it has occurred, and could do
            // something if it was important to not replace words. Here it isn't so we replace anyway and warn the user
            System.out.println("We already have " + word + " in the dictionary, it has been replaced");
            hashMap.replace(word, meaning);
        }
        else{

            hashMap.put(word + " ", meaning);
        }
        return hashMap;
    }
    public String getMeaning(HashMap<String, String> hashMap, String word){
        if (hashMap.containsKey(word + " ")){
            return hashMap.get(word);
        }
        return "No meaning input";
    }
    public Boolean newLineTerminator(String target){
        return (target.charAt(target.length()-1) == '\n');
    }
    public void updateHashFile(HashMap<String, String> hashMap, String filePath){
        FileOutput fileOutput = new FileOutput(filePath);
        QuestionFive classCaller = new QuestionFive();
        for (HashMap.Entry<String, String> entry: hashMap.entrySet()){
            if (classCaller.newLineTerminator(entry.getValue())){
                fileOutput.writeString(entry.getKey() + entry.getValue());
            }
            else{
                fileOutput.writeString(entry.getKey() + entry.getValue() + '\n');
            }
        }
        fileOutput.close();
    }

    public List<String> separate_string(String big_string){
        List<String> strings = new ArrayList<>();
        List<Character> char_accumulator = new ArrayList<>();
        for (char character : big_string.toCharArray()){
            if (character == ' '){
                strings.add(char_accumulator.stream().map(Object::toString).reduce("", String::concat) + " ");
                char_accumulator.clear();
            }
            else{
                char_accumulator.add(character);
            }
        }
        strings.add(char_accumulator.stream().map(Object::toString).reduce("", String::concat));
        // if no space ending, we still get the final word, otherwise this line does nothing so its ok

        return strings;
    }

    public HashMap<String, String> readHashFile(String filePath){
        HashMap<String, String> theHash = new HashMap<>();
        QuestionFive classCaller = new QuestionFive();
        FileInput fileInput = new FileInput(filePath);
        while (fileInput.hasNextLine()){
            List<String> strings = classCaller.separate_string(fileInput.nextLine());
            theHash.put(strings.getFirst(), strings.subList(1, strings.size()).stream().reduce("", (acc, element) -> acc + element));
            System.out.println(strings.getFirst() + ": " + theHash.get(strings.getFirst()));
        }
        return theHash;
    }

}
