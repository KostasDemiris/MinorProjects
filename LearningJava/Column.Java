import java.util.ArrayList;

//record Column(String name, ArrayList<?> data) {}

public class Column<T>{
    // This allows us to have a defined generic type T to use in the rest of the class
    private String name;
    private ArrayList<T> data;

    public Column(String name, ArrayList<T> data) {
        this.name = name;
        this.data = data;
    }
    public Column(String name){
        this.name = name;
        this.data = new ArrayList<>();
    }
    public int get_size() {return this.data.size();}
    public String get_name() {return this.name;}
    public T get_row_value(int index) {return this.data.get(index);}
    public void set_row_value(int index, T value) {this.data.set(index, value);}
    public void add_row_value(T value) {this.data.add(value);}
    public ArrayList<T> get_all_values() {return this.data;}
}
