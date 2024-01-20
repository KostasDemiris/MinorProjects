import java.math.BigDecimal;
import java.math.MathContext;

public class QuestionThree {
    public static void main(String[] args){
        QuestionThree classCaller = new QuestionThree();
        System.out.println(classCaller.isPrime(new BigDecimal("74915840254473497299")));
        System.out.println(new BigDecimal("74915840254473497299"));
    }
    public static BigDecimal factorial(int number){
        if (number <= 1){
            return (new BigDecimal(1));
        }
        else return (new BigDecimal(number).multiply(factorial(number-1)));
    }
    public Boolean isPrime(BigDecimal potential_prime){
        BigDecimal bound = potential_prime.sqrt(new MathContext(10));
        System.out.println(bound);
        for (BigDecimal index = new BigDecimal(2); index.compareTo(bound) < 0; index = index.add(new BigDecimal(2))){
            if (potential_prime.remainder(index).compareTo(new BigDecimal(0)) == 0){
                return false;
            }
            System.out.println(index);
        }
        return true;
    }

}
