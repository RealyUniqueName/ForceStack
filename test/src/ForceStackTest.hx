package;

import haxe.CallStack;
import hunit.TestCase;



/**
 * Test ForceStack
 *
 */
class ForceStackTest extends TestCase
{
    static private var file  = 'ForceStackTest.hx';
    static private var type  = 'ForceStackTest';


    static private inline function secondLevel () : Array<StackItem>
    {
        ForceStack.enterFunction(type, 'secondLevel', file);
        ForceStack.line(201);
        var stack = ForceStack.callStack();
        ForceStack.exitFunction();

        return stack;
    }


    @test
    public function callStack_singleLevel () : Void
    {
        var field = 'callStack_singleLevel';

        ForceStack.enterFunction(type, field, file);

        ForceStack.line(1);
        assert.similar(
            [FilePos(Method(type, field), file, 1)],
            ForceStack.callStack()
        );

        ForceStack.line(2);
        assert.similar(
            [FilePos(Method(type, field), file, 2)],
            ForceStack.callStack()
        );

        ForceStack.exitFunction();
        assert.similar([], ForceStack.callStack());
    }


    @test
    public function callStack_twoLevelsDeep () : Void
    {
        var field = 'callStack_twoLevelsDeep';

        ForceStack.enterFunction(type, field, file);

        ForceStack.line(1);
        var stack = secondLevel();
        assert.similar(
            [
                FilePos(Method(type, 'secondLevel'), file, 201),
                FilePos(Method(type, field), file, 1)
            ],
            stack
        );

        ForceStack.line(2);
        assert.similar(
            [FilePos(Method(type, field), file, 2)],
            ForceStack.callStack()
        );

        ForceStack.exitFunction();
        assert.similar([], ForceStack.callStack());
    }

}//class ForceStackTest