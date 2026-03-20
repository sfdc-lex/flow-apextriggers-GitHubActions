public with sharing class CalculatorService {

    public static Integer add(Integer a, Integer b) {
        return a + b;
    }

    public static Integer subtract(Integer a, Integer b) {
        return a - b;
    }

    public static Integer multiply(Integer a, Integer b) {
        return a * b;
    }

    public static Decimal divide(Decimal a, Decimal b) {
        if (b == 0) {
            throw new AuraHandledException('Cannot divide by zero');
        }
        return a / b;
    }
}