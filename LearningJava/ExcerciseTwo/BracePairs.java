import java.sql.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

public class BracePairs {
    List<BracePairs> subBraces = new ArrayList<>();
    private final boolean left = true;
    private boolean right = false;
    public boolean balanced = false;
    public BracePairs(){} // creation method, doesn't need any parameters

    public void close_bracket(){
        this.right = true;
    }
    public boolean closed(){
        return (this.right == this.left);
    }
    public Integer get_depth(){
        if (this.subBraces.isEmpty()){
            return 1;
        }
        else{
            return subBraces.stream().map(BracePairs::get_depth).max(Integer::compare).get() + (Integer) 1;
        }
    }
    public int getSubBraces(){
        return this.subBraces.size();
    }
    public int getTotalBraces(){
        if (this.subBraces.isEmpty()){
            return 1;
        }
        return subBraces.stream().map(BracePairs::getTotalBraces).reduce(1, Integer::sum);
    }

    public HashMap<String, String> generateReport(){ // generates a hashmap that describes the current state of the obj.
        HashMap<String, String> report = new HashMap<>();
        report.put("depth", this.get_depth().toString());

        int deepest_depths = -1; int deepest = (-1);
        for (int index = 0; index < subBraces.size(); index++){
            int depth = subBraces.get(index).get_depth();
            if (depth > deepest_depths) {deepest_depths = depth; deepest = index;}
        }
        report.put("deepest", Integer.toString(deepest));
        report.put("braces", ((Integer) this.getTotalBraces()).toString());

        return report;
    }

    public boolean left_bracket(){
        if (subBraces.isEmpty()){
            if (left && right){
                return false;
            }
            subBraces.add(new BracePairs());
            return true;
        }
        if (left && right){
            this.right = false;
            this.subBraces.add(new BracePairs());
            return this.subBraces.getLast().right_bracket();
        }
        for (BracePairs pair : subBraces){
            if (!pair.closed()){
                return pair.left_bracket();
            }
        }
        subBraces.add(new BracePairs());
        return true;

    }
    public boolean right_bracket(){
        if (subBraces.isEmpty()){
            if (left && right){
                return false;
            }
            right = true;
            return true;
        }
        for (BracePairs pair : subBraces){
            if (!pair.closed()) {return pair.right_bracket();}
        }
        if (!right){
            this.close_bracket();
            return true;
        }
        System.out.println("There was an issue here...");
        return false;
    }
}
