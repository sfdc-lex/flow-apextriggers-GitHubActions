@isTest
public class CalculatorServiceTest {

    @isTest
    static void testAdd() {
        Integer result = CalculatorService.add(10, 5);
        System.assertEquals(15, result);
    }

    @isTest
    static void testSubtract() {
        Integer result = CalculatorService.subtract(10, 5);
        System.assertEquals(5, result);
    }

    @isTest
    static void testMultiply() {
        Integer result = CalculatorService.multiply(10, 5);
        System.assertEquals(50, result);
    }

    @isTest
    static void testDivide() {
        Decimal result = CalculatorService.divide(10, 2);
        System.assertEquals(5, result);
    }

    @isTest
    static void testDivideByZero() {
        try {
            CalculatorService.divide(10, 0);
            System.assert(false, 'Expected exception not thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Cannot divide by zero'));
        }
    }
}
