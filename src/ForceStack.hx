package ;

import haxe.CallStack;



/**
 * Call stack collector
 *
 */
class ForceStack
{
    /** Call stack */
    static private var root : ForceStackEntry = new RootForceStackEntry();


    /**
     * Add entry to call stack
     */
    static public inline function enterFunction (type:String, field:String, file:String) : Void
    {
        if (root.previous.next == null) {
            root.previous.next = new ForceStackEntry();
            root.previous.next.previous = root.previous;
        }
        root.previous = root.previous.next;

        root.previous.type  = type;
        root.previous.field = field;
        root.previous.file  = file;
    }


    /**
     * Change line of last entry
     */
    static public inline function line (l:Int) : Void
    {
        root.previous.line  = l;
    }


    /**
     * Remove last stack entry
     */
    static public inline function exitFunction () : Void
    {
        root.previous = root.previous.previous;
    }


    /**
     * Generate list of call stack entries
     */
    static public function callStack () : Array<StackItem>
    {
        var stack : Array<StackItem> = [];

        var current = root.previous;
        while (current != root) {
            stack.push(FilePos(Method(current.type, current.field), current.file, current.line));
            current = current.previous;
        }

        return stack;
    }


    /**
     * Get string representation of current call stack
     */
    static public inline function stringStack () : String
    {
        return CallStack.toString(callStack());
    }

}//class ForceStack




/**
 * Call stack entries
 *
 */
@:allow(ForceStack)
private class ForceStackEntry
{
    /** Type name */
    public var type (default,null) : String;
    /** Field name */
    public var field (default,null) : String;
    /** File name */
    public var file (default,null) : String;
    /** Line in `file` where `field` is declared */
    public var line (default,null) : Int = 0;

    /** Previous entry in stack */
    private var previous : ForceStackEntry;
    /** Next entry in stack */
    private var next : ForceStackEntry;


    /**
     * Cosntructor
     */
    public function new () : Void
    {

    }

}//class ForceStackEntry



private class RootForceStackEntry extends ForceStackEntry
{
    public function new ()
    {
        super();
        previous = this;
    }
}