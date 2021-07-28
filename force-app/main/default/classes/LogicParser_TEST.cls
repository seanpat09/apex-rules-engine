@isTest
private with sharing class LogicParser_TEST {

    //1 && 2
    @isTest
    private static void shouldParse_UseCase1() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('1 && 2');

        exp.set('1', true);
        exp.set('2', true);

        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        System.assertEquals(false, exp.evaluate());

        exp.set('1', false);
        exp.set('2', true);
        System.assertEquals(false, exp.evaluate());

        exp.set('1', false);
        exp.set('2', false);
        System.assertEquals(false, exp.evaluate());
    }

    //1 || 2
    @isTest
    private static void shouldParse_UseCase2() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('1 || 2');

        exp.set('1', true);
        exp.set('2', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', false);
        exp.set('2', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', false);
        exp.set('2', false);
        System.assertEquals(false, exp.evaluate());
    }

    //1 && 2 && 3
    @isTest
    private static void shouldParse_UseCase3() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('1 && 2 && 3');

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', false);
        System.assertEquals(false, exp.evaluate());
    }

    //(1 && 2) || 3
    @isTest
    private static void shouldParse_UseCase4() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('( 1 && 2 ) || 3');

        exp.set('1', false);
        exp.set('2', false);
        exp.set('3', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        exp.set('3', false);
        System.assertEquals(false, exp.evaluate());
    }

    //(1 && 2) || (3 && 4)
    @isTest
    private static void shouldParse_UseCase5() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('( 1 && 2 ) || ( 3 && 4 )');

        exp.set('1', false);
        exp.set('2', false);
        exp.set('3', true);
        exp.set('4', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', false);
        exp.set('4', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        exp.set('3', true);
        exp.set('4', false);
        System.assertEquals(false, exp.evaluate());
    }

    //!( 1 && 2 )
    @isTest
    private static void shouldParse_UseCase6() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('!( 1 && 2 )');

        exp.set('1', false);
        exp.set('2', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        System.assertEquals(false, exp.evaluate());
    }

    //!1
    @isTest
    private static void shouldParse_UseCase7() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('!1');

        exp.set('1', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        System.assertEquals(false, exp.evaluate());
    }

    //!1
    @isTest
    private static void shouldParse_UseCase8() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('( 1&&2) ||( 3&&4   )');

        exp.set('1', false);
        exp.set('2', false);
        exp.set('3', true);
        exp.set('4', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', false);
        exp.set('4', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        exp.set('3', true);
        exp.set('4', false);
        System.assertEquals(false, exp.evaluate());
    }
}
