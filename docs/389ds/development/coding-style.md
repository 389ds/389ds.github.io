---
title: "Coding Style"
---

# Coding Style Guidelines
-------------------------

This manual contains coding standards and guidelines for 389 Directory Server contributors.

This project has evolved over a very long time (see [History](../FAQ/history.html)). As a result not all of the existing code conforms to these standards. All new code should adhere to these standards but please do not go back and make wholesale formatting changes to the old code. It just confuses things and is generally a waste of time.

{% include toc.md %}

Why Have A Coding Style?
------------------------

### For easier maintenance

If you're merging changes from a patch it's much easier if everyone is using the same coding style. This isn't the reality for a lot of our code, but we're trying to get to the point where most of it uses the same style.

### Improved readability

Remember, code isn't just for compilers, it's for people, too. If it wasn't for people, we would all be programming in assembly. Coding style and consistency mean that if you go from one part of the code to another you don't spend time having to re-adjust from one style to another. Blocks are consistent and readable and the flow of the code is apparent. Coding style adds value for people who have to read your code after you've been hit by a bus. Remember that.

General Rules
-------------

-   All source and header files should include a copy of the license.
-   Stick to a K&R coding style.
    -   Space after keywords
    -   Curly braces on same line as if/while.
-   Prefer NSPR functions for file, string, memory allocation, etc. if at all possible.
-   All code should be peer reviewed before being checked in.

Statements
----------

-   if-else statements should have the following form.

        if (<condition>) {     
            /* do some work */     
        }     

        if (<condition>) {     
            /* do some work */     
        } else {     
            /* do some other work */     
        }

-   Balance the braces in the if and else in an if-else statement if either has only one line:

        if (condition) {     
            /*     
             * stuff that takes up more than one     
             * line     
             */     
        } else {     
            /* stuff that only uses one line */     
        }     

-   The corollary is also true; don't use braces if there's only one line for both:

        if (foo)     
            bar();     
        else     
            baz();     

-   Avoid last-return-in-else problem. Code should look like this:

        int foo(int bar) {     
            if (something) {     
                /* stuff done here */     
                return 1;            
            }     
        
            return 0;     
        }     

    **NOT** like this:

        int foo(int bar) {     
            if (something) {     
                /* stuff done here */     
                return 1;                 
            } else {     
                return 0;     
            }     
        }     

-   for, while and until statements should take a similar form:

        for (<initialization>; <condition>; <update>) {     
            /* iterate here */     
        }     

        while (<condition>) {     
            /* do some work */     
        }     

-   switch statements:

        switch (<condition>) {     
        case A:     
            /* do work */     
            break;     
        case B:     
            /* do work */     
            break;     
        default:     
            /* do work */     
            break;     
        }     

Comments
--------

-   C-style comments are preferred (/\* \*/ instead of //)
    -   Each function should be preceded with a block comment describing what the function is supposed to do.
    -   Block comments should be preceded by a blank line to set it apart. Line up the \* characters in the block comment.

        /*     
         * A block comment.     
         */     

Indentation
-----------

-   Try to keep lines 80 characters or less.
-   Indentation is 4 spaces.
-   No tabs, use spaces. Your editor should take care of most of this but in patches tabs stick out like sore thumbs.
-   When wrapping lines, try to break it:
    -   after a comma
    -   before an operator
    -   align the new line with the beginning of the expression at the same level in the previous line
    -   if all else fails, just indent 8 spaces.

        Function(longArgument1, longArgument2, longArgument3,      
                 longArgument4, longArgument5);     

Variable Declarations
---------------------

-   One declaration per line is preferred.

        int foo;     
        int bar;     

    instead of

        int foo, bar;     

-   Initialize at declaration time when possible.
-   Declare variables at the beginning of a block to maintain C99 compatibility.

-   No tabs, use spaces. Your editor should take care of most of this but in patches tabs stick out like sore thumbs.

