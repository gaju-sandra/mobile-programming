import java.util.Scanner;

public class Main{
    public static void main(String[] args){
        Scanner scanner=new Scanner(System.in);



        System.out.println("Principal: ");
        int principal=scanner.nextInt();
        System.out.println("Annual Interest Rate: ");
        float interest=scanner.nextFloat();
        interest= interest/100;
        System.out.println("Period (Years): " );
        int year= scanner.nextInt();
        double mortgage = principal *
                (interest * Math.pow(1 + interest, year))
                / (Math.pow(1 + interest, year) - 1);
        System.out.println("Mortagage: "+mortgage);
    }

}