package;

import haxe.CallStack;
import hunit.TestCase;



/**
 * Test ForceStack
 *
 */
class ForceStackTest extends TestCase
{

    @test
    public function callStack_singleLevel () : Void
    {
        var file  = 'ForceStackTest.hx';
        var type  = 'ForceStackTest';
        var field = 'callStack_singleLevel';

        ForceStack.enterFunction(type, field, file, 1);
        assert.similar(
            [FilePos(Method(type, field), file, 0), FilePos(Method(type, field), file, 1)],
            ForceStack.callStack()
        );

        ForceStack.line(2);
        assert.similar(
            [FilePos(Method(type, field), file, 2), FilePos(Method(type, field), file, 1)],
            ForceStack.callStack()
        );

        ForceStack.line(3);
        assert.similar(
            [FilePos(Method(type, field), file, 3), FilePos(Method(type, field), file, 1)],
            ForceStack.callStack()
        );

        ForceStack.exitFunction();
        assert.similar([], ForceStack.callStack());
    }

}//class ForceStackTest