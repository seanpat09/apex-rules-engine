# Apex Rules Engine

Engine to parse a logical statement (.e.g `1 && 2 && (3 || 4)`), set the values of each token in the statement, and evaluate to a boolean.

## Usage

Pass a string to the logical parser, set the values of the tokens in the expression, and then set the expression.

**Evaluate '1 && 2'**
```
LogicParser.Expression exp = 
    new LogicParser().parseLogicalExpression('1 && 2');

exp.set('1', true)
exp.set('2', true);
System.assertEquals(true, exp.evaluate());

exp.set('1', true)
exp.set('2', false);
System.assertEquals(false, exp.evaluate());
```

**Evaluate '( 1 && 2 ) || ( 3 && 4 )'**
```
LogicParser.Expression exp = 
    new LogicParser().parseLogicalExpression('( 1 && 2 ) || ( 3 && 4 )');

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
```

**Evaluate !( 1 && 2 )**
```
LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('!( 1 && 2 )');

exp.set('1', false);
exp.set('2', false);
System.assertEquals(true, exp.evaluate());

exp.set('1', true);
exp.set('2', true);
System.assertEquals(false, exp.evaluate());
```