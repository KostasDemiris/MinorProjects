import uk.ac.ucl.Exceptions.NotFoundException;

import java.util.ArrayList;
import java.util.IllegalFormatException;
import java.util.Objects;

public class DataFrame {
    ArrayList<Column> Columns;
    public void addColumn(Column new_Column) {this.Columns.add(new_Column);}
    public ArrayList<String> getColumnNames(){
        ArrayList<String> names = new ArrayList<>();
        for (Column column: this.Columns){
            names.add(column.get_name());
        }
        return names;
    }
    public int getColumnCount() {return this.Columns.size();}
    public int getRowCount() {return this.Columns.getFirst().get_size();}
    public String getValue(String columnName, int row)
            throws ArrayIndexOutOfBoundsException{
        for (Column column: this.Columns){
            if (Objects.equals(column.get_name(), columnName)){
                try {
                    return column.get_row_value(row);
                }
                catch (ArrayIndexOutOfBoundsException e){
                    return "Out Of Bounds";
                }
            }
        }
        return "No Column With That Name";
    }
    public void putValue(String columnName, int row, String value)
            throws NotFoundException, ArrayIndexOutOfBoundsException {
        for (Column column: this.Columns){
            if (Objects.equals(column.get_name(), columnName)){
                column.set_row_value(row, value);
                // This can return an OutOfBounds exception, which I won't catch here but should be dealt with by the
                // Caller for any assignment functions
            }
        }
        throw new NotFoundException("Column Name Not Found");
    }
    public void addValue(String columnName, String value) throws NotFoundException{
        for (Column column: this.Columns){
            if (Objects.equals(column.get_name(), columnName)){
                column.add_row_value(value);
            }
        }
        throw new NotFoundException("Column Name Not Found");
    }
    public void addRow(ArrayList<String> newRow) throws IllegalArgumentException {
        if (newRow.size() == this.getColumnCount()){
            for (int index = 0; index < this.getColumnCount(); index++){
                this.Columns.get(index).add_row_value(newRow.get(index));
            }
        }
        else{
            throw new IllegalArgumentException("Incorrect Number of Column Data");
        }
    }


}
