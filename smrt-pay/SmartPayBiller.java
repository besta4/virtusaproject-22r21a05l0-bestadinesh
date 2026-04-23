import java.util.Scanner;

interface Billable {
    double calculateTotal();
}

class UtilityBill implements Billable {
    private String customerName;
    private int previousReading;
    private int currentReading;
    private int unitsConsumed;
    private double totalAmount;
    private double taxAmount;

    public UtilityBill(String customerName, int previousReading, int currentReading) {
        this.customerName = customerName;
        this.previousReading = previousReading;
        this.currentReading = currentReading;
        this.unitsConsumed = currentReading - previousReading;
    }

    public double calculateTotal() {
        double rate;

        if (unitsConsumed <= 100) {
            rate = 1.0;
        } else if (unitsConsumed <= 300) {
            rate = 2.0;
        } else {
            rate = 5.0;
        }

        totalAmount = unitsConsumed * rate;

        taxAmount = totalAmount * 0.10;

        return totalAmount + taxAmount;
    }

    public void printReceipt() {
        double finalAmount = calculateTotal();

        System.out.println("DIGITAL RECEIPT:");
        System.out.println("Customer Name   : " + customerName);
        System.out.println("Units Consumed  : " + unitsConsumed);
        System.out.println("Base Amount     : $" + totalAmount);
        System.out.println("Tax (10%)       : $" + taxAmount);
        System.out.println("Final Amount    : $" + finalAmount);
        System.out.println();
    }

    public boolean isValid() {
        return currentReading >= previousReading;
    }
}


public class SmartPayBiller {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        while (true) {
            System.out.print("Enter Customer Name (or type 'Exit' to quit): ");
            String name = sc.nextLine();

            if (name.equalsIgnoreCase("Exit")) {
                System.out.println("Exiting SmartPay System...");
                break;
            }

            System.out.print("Enter Previous Meter Reading: ");
            int prev = sc.nextInt();

            System.out.print("Enter Current Meter Reading: ");
            int curr = sc.nextInt();
            sc.nextLine(); 

            UtilityBill bill = new UtilityBill(name, prev, curr);

            if (!bill.isValid()) {
                System.out.println("❌ Error: Current reading cannot be less than previous reading.\n");
                continue;
            }
            bill.printReceipt();
        }
        sc.close();
    }
}