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
-   C99 is the minimum version we target (no c89 mode).
-   Stick to a K&R coding style.
    -   Space after keywords
    -   Curly braces on same line as if/while.
-   Prefer NSPR functions for file, string, memory allocation, etc. if at all possible.
-   All code should be peer reviewed before being checked in.
-   Our code is used internationally, so use simple english in messages.
-   Don't add extra dependencies unless they are needed. Every dependency is a potential "new project" we may need to adopt. If we need a small function, just write that rather than using micro dependencies.
-   Keep messages short, direct, and offer direction. For example, a bad message is:

    An error occured, please check the error log.

A better message is:

    An error occured processing operation=X: Invalid dn.

A great message is:

    ERROR: Processing add operation=X: DN containing "z" is invalid.

Messages should direct a user or admin where to go to solve the problem, not to just make them aware of it.

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

-   Braces are required on all conditionals and for loops. Code like the following will be rejected at review. The reason for this is it can cause accidental logic mistakes that are hard to detect.

        if (foo)     
            bar();     
        else     
            baz();     


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

-   There is no limit on characters per line, but excessive wide text should be avoided. This is a very subjective topic, so if you want a hard number, less than 120 chars.
-   Avoid spliting strings across lines: If a message is long, leave it on one line, or make the message clearer and simpler.
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
-   Avoid the use of memset. You can either use {0} for struct or arrays on the stack, or use calloc. memset has signifigant performance impact on our system.

    Slapi_PBlock pb = {0};
    uint64_t arr[10] = {0};
    struct foo *f = slapi_ch_calloc(sizeof(foo));

-   Avoid variable reuse. Free and allocate a new one, or in a loop, declare inside the loop block. Don't reuse structs as this allow corruption to pass through iterations, and breaks dynamic analysis tools.

Types
-----

- Avoid nested struct definitions. This is inefficent for memory allocation and hard to follow the struct contents. IE:

    struct x {
        struct y {
            member z;
        }
    ...
    }


- Avoid void * in all possible cases. Unless you are writing a low level datastructure (you shouldn't be), you should not need this! Having concrete types lets the compiler find mistakes for us - We are only human after all.
- Avoid the use of variable size types. This includes int, long, long long, double etc. Please use concrete types from inttypes.h or nspr.h. (ie int32_t, PRUint64)


