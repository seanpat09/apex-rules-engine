public with sharing class LogicParser {
    private Integer index = 0;
    public Expression parseLogicalExpression(String logicalExpression) {
        List<String> tokens = normalizeLogicalExpression(logicalExpression).split(' ');
        Expression exp = buildExpression(tokens);
        return exp;
    }

    private String normalizeLogicalExpression(String exp){
        System.debug(exp);
        exp = exp.replace(' ', '');
        System.debug(exp);

        //Find the following tokens: number, open parens, close parens, &&, ||, !
        Pattern p = Pattern.compile('(\\d+|\\(|\\)|&{2}|\\|{2}|\\!)');
        Matcher pm = p.matcher( exp );

        String formattedExpression = '';
        while(pm.find()) {
            formattedExpression += pm.group() + ' ';
        }

        System.debug(formattedExpression);
        return formattedExpression.trim();
    }

    private Expression buildExpression(List<String> tokens) {
        Composite baseComposite;
        Expression stagedVariable;
        NotComposite stagedNotComposite;

        while(this.index < tokens.size()) {
            String token = tokens[this.index];

            System.debug('>>>> Current token: ' + token);
            if (token == '!') {
                stagedNotComposite = new NotComposite();

            } else if (token == '(') {
                this.index++;
                Expression childExpression = buildExpression(tokens);
                if(stagedNotComposite != null) {
                    childExpression = stagedNotComposite.add(childExpression);
                }
                if (baseComposite == null) {
                    stagedVariable = childExpression;

                } else {
                    baseComposite.add(childExpression);
                }

            } else if (token == ')') {
                return baseComposite;

            } else if (token == '&&') {
                if (baseComposite == null) {
                    baseComposite = new AndComposite();
                    baseComposite.add(stagedVariable);
                    stagedVariable = null;
                }

            } else if (token == '||') {
                if (baseComposite == null) {
                    baseComposite = new OrComposite();
                    baseComposite.add(stagedVariable);
                    stagedVariable = null;
                }

            } else {
                Expression newVariable;

                if(stagedNotComposite != null) {
                    newVariable = stagedNotComposite.add(new Variable(token));
                } else {
                    newVariable = new Variable(token);
                }

                if(baseComposite == null) {
                    stagedVariable = newVariable;
                } else {
                    baseComposite.add(newVariable);
                }
            }
            this.index++;
        }

        return baseComposite == null ? stagedVariable : baseComposite;
    }

    public interface Expression {
        Expression add(Expression expr);
        Expression set(String name, Boolean value);
        Boolean evaluate();
    }

    public abstract class Composite implements Expression{
        public List<Expression> children {get; private set;}
        public Composite(){ this.children = new List<Expression>(); }
        public Expression add(Expression expr){
            children.add(expr); return this;
        }
        public Expression set(String name, Boolean value){
            for(Expression expr : children) expr.set(name,value);
            return this;
        }
        public abstract Boolean evaluate();
        public Boolean hasChildren{get{ return !children.isEmpty(); }}
    }

    public class AndComposite extends Composite{
        public override Boolean evaluate(){
            for(Expression expr : children) {
                if(!expr.evaluate()) {
                  return false;
                }
            }

            return true;
        }
    }

    public class OrComposite extends Composite{
        public override Boolean evaluate(){
            for(Expression expr : children) {
                if(expr.evaluate()) {
                    return true;
                }
            }
            return false;
        }
    }

    public class NotComposite extends Composite {
        public override Boolean evaluate(){
            return !children[0].evaluate();
        }
    }

    public class Variable implements Expression{
        public String  name  {get;private set;}
        public Boolean value {get;private set;}

        public Variable(String name){ this.name = name; }

        public Expression add(Expression expr){ return this; }

        public Expression set(String name, Boolean value){
            if(this.name != null && this.name.equalsIgnoreCase(name)) {
                this.value = value;
            }
            return this;
        }
        public Boolean evaluate(){ return value; }
    }
}
