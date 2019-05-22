---
title: "Rust"
---

# Rust
------

{% include toc.md %}

Overview
========

Rust is a modern systems programming language, that attempts to provide safety, speed and concurrency in a single language. This is achieved through the use of a strict type system, and unique
concepts of memory management known as lifetimes and ownership. This allows Rust to function
with no runtime - just like C. It is compiled exactly like C, and can be linked to and from
to allow seamless integration.

Resources
=========

It is not my intent here to teach you how to use Rust. The language provides excellent, well written
resources already.

Getting Started:

- [The Rust Book](https://doc.rust-lang.org/stable/book/)
- [Rust By Example](https://doc.rust-lang.org/stable/rust-by-example/)

Learn about Memory Management in Rust:

- [Learning Rust Through Too Many Linked Lists](https://rust-unofficial.github.io/too-many-lists/)

The Dark magic of Rust internals - needed for C-Rust FFI boundaries.

- [Advanced: The Rustonomicon](https://doc.rust-lang.org/nomicon/)

Motivation
==========

Due to the safety guarantees of the language, many classes of bugs that have existed in C are
immediately removed. Usage of safe rust does not allow buffer over/underflows to occur, and
pointers can not be dereferenced incorrectly. This is largely due to the strict type system.

Let's take the following example:

    void *
    new_thing() {
        // Hey, maybe it's a bad day?
        return malloc(...);
    }

    int
    main() {
        void *x = new_thing()

        x->field; // boom!!!!
    }

What went wrong here? We mis-used the value, because we didn't assert it's state was correct. As
you would all know, to defend this:

    int
    main() {
        void *x = new_thing()

        if (x == NULL) {
            return;
        }

        x->field; // all good!
    }

It's important to draw attention to this example - the onus is on YOU the programmer to make
this check correct - this is because C has two concepts together. The value AND the possibility of
no value are the same thing. Rust shifts this check to the compiler by representing the possibility
of abscence as a native type.

    fn new_thing() -> Option<X> {
        Some(X::new())
        // Alternately, None.
    }

    fn main() {
        match new_thing() {
            Some(x) => {
                // We can now use x
            }
            None => {
                // No value is present, we need to handle this ...
            }
        }
    }

It's not possible to access the content of the Option<X> until you have *destructured* it, which
requires you to assert that the value is a Some or None. Even better, because the type signatures
can show possibility of abscence:

    fn use_thing(x: X) {
        // 
    }

This means the following is not valid:

    fn main() {
        use_thing(new_thing())
    }

Because Option<X> != X. As a result, the compiler would never allow this until you have done
the check for None! Great! Contrast to C, we would probably need a NULL pointer check in use_thing
as well ... we have no way to assert where our safety barriers are!

There is one final bonus to this: in Rust the *correct* behaviour is often the *optimal* behaviour.
If we look at the equivalent C that this Rust would compile to:

    struct *X new_thing() {
        return malloc(sizeof(X));
    }

    void use_thing(struct X *x) {
        // Because the called did the null check, we don't have to!
        x->field;
    }

    void main() {
        X *x = new_thing():

        if (x == NULL) {
            // This is the "None" case
        } else {
            use_thing(x);
        }
    }

It compiles to the same NULL pointer check - the difference is whether we have to assert the correctness
or if the compiler does it for us. Great! This is really important as it saves *developer time* and
prevents many bugs entering the codebase contrast to C.

FFI
===

Rust supports FFI with C, and importantly, this has a few things to keep in mind.

* Rust FFI is fundamentally, unsafe (in Rust's idea of unsafe), meaning that pointers CAN be dereferenced, meaning extra safety is required.
* Memory must be allocated and freed on the correct side - if allocated by C, freed by C. If allocated by Rust, freed by Rust.
* Structs can be shared between C and Rust but it's often easier to have them managed by the relevant language side.
* Rust's lifetime rules change when you move things to pointers across FFI boundaries.

Keeping this in mind, we can construct a Rust structure which C can then request operations on:

    use std::os::raw::c_char;
    use std::ffi::CStr;

    #[repr(C)]
    pub enum slapi_result {
        Success = 0,
        NullPointer = 1,
    }

    struct OperationLog {
        msgs: Vec<String>,
    }

    #[no_mangle]
    pub extern fn slapi_oplog_init(oplog: *mut *mut OperationLog) -> slapi_result {
        if oplog.is_null() {
            return slapi_result::NullPointer;
        }

        let o = Box::new(OperationLog);
        unsafe {
            *oplog = Box::into_raw(o);
        }
        return slapi_result::Success;
    }

    #[no_mangle]
    pub extern fn slapi_oplog_append_msg(oplog: *mut OperationLog, msg: *const c_char) -> slapi_result {
        if msg.is_null() {
            return slapi_result::NullPointer;
        }

        let opref = match unsafe { oplog.as_mut() } {
            Some(p) => p,
            None => {
                return slapi_result::NullPointer;
            }
        };

        let c_msg: String = unsafe {
            CStr::from_ptr(msg).to_string_lossy().into_owned()
        };

        // Now we can just append to self! Note that at this point, we have done our assertions, so
        // everything here is safe Rust! Woohoo!
        opref.msgs.push(c_msg);

        return slapi_result::Success;
    }

    #[no_mangle[
    pub extern fn slapi_oplog_free(oplog: *mut OperationLog) {
        if !oplog.is_null() {
            let _o = unsafe { Box::from_raw(oplog) };
        }
    }


Besides a thin layer of checking on the externals of the interface, the internals (such as oplog.msg.push) is all safe rust code. This means that for example, this could be extended to use things like
Rust's [channels](https://doc.rust-lang.org/std/sync/mpsc/index.html) for thread communication with a 100% rust thread running a logging service. It also means the construction and management
of the operationLog structure could be almost completely safe rust.

