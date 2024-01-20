import java.util.Calendar;

public class QuestionTwo {
    public static void main(String[] args){
        print_date();
    }
    public Calendar get_date(){
        return Calendar.getInstance();
    }
    public String input_date(){
        Input in = new Input(System.in);
        System.out.println("Please enter the day number, month and year, each seperated by a new line (and as a number):  ");
        String date = in.nextLine() + " " + in.nextLine() + " " + in.nextLine();
        return date;
    }
    public String month_to_number(String month){
        return switch (month){
            case "Jan" -> "1";
            case "Feb" -> "2";
            case "Mar" -> "3";
            case "Apr" -> "4";
            case "May" -> "5";
            case "Jun" -> "6";
            case "Jul" -> "7";
            case "Aug" -> "8";
            case "Sep" -> "9";
            case "Oct" -> "10";
            case "Nov" -> "11";
            case "Dec" -> "12";
            default -> month;
        };
    }
    public int month_to_int_number(String month){
        return switch (month){
            case "Jan" -> 1;
            case "Feb" -> 2;
            case "Mar" -> 3;
            case "Apr" -> 4;
            case "May" -> 5;
            case "Jun" -> 6;
            case "Jul" -> 7;
            case "Aug" -> 8;
            case "Sep" -> 9;
            case "Oct" -> 10;
            case "Nov" -> 11;
            case "Dec" -> 12;
            default -> {
                System.out.println(month);
                yield 999;
            }
        };
    }
    public Calendar set_dated(Calendar calendar){
        Input in = new Input(System.in);
        QuestionTwo classCaller = new QuestionTwo();
        System.out.println("Please enter the month");
        calendar.set(Calendar.DAY_OF_MONTH, classCaller.month_to_int_number(in.nextLine()));
        System.out.println("Please enter the ");
        return calendar;
    }
    public static void print_date(){
        QuestionTwo classCaller = new QuestionTwo();
        int cur_word = 0;
        String month = "";
        String day_num = "";
        String year = "";
        String time = String.valueOf((Calendar.getInstance().getTime()));

        for (int index = 0; index < time.length(); index++){
            if (time.charAt(index) == ' '){
                cur_word += 1;
            }
            if (cur_word == 1){
                month += time.charAt(index);
            }
            if (cur_word == 2){
                day_num += time.charAt(index);
            }
            if (cur_word == 5){
                year += time.charAt(index);
            }
        }

        System.out.println(year + " " + month + " " + day_num);
    }
}
