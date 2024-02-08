import java.util.Scanner;

public class HelloWorld{
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        int nextInt = sc.nextInt();
        sc.nextLine();

        for(int i = 0; i < nextInt; i++){
            String s = sc.nextLine();
            System.out.println("Hello, " + s + "!");
        }
        sc.close();
    }
}
