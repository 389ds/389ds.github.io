---
title: "CLI Tool and Lib389 Design Guide"
---

## History

Historically, LDAP has always been considered extremely difficult to use, arcane, and complex.
This has meant that it's usage has always been confined to large businesses that are well resourced
and have requirements such as centralised IDM systems. Our tools also reflected this time, where
very little consideration was made to human interaction.

This seems like a really broad statement, but it doesn't take long looking at our own experiences
of 389 to see this. The very origin of my involvement in the project was writing python based
cli tools for a University (that now form part of lib389) to avoid the complexities. A great
example was "default indexes" vs "indexes". No where documented what the difference was, only that
default indexes apply to all backends. They don't! They are templates to new backends!

It's traps like this that have caught us all out. It's time to make this easier. To do this we need
to rethink our approach to design and programming.

## User experience and human interaction

Human interaction is a field rooted in psychology, with one of the most famous and notable
advocates being Don Norman. Norman's text "The Design of Everyday Things" is one of his most
famous works and has been well referenced and reviewed.

Let's take a thought experiment about the importance of human centred design. Aviation has a long
track record as an industry that examines all possible causes and influences on accidents.

Imagine we are in the cockpit of an aircraft. We are preparing for take off, and there is a false
alarm that always goes off. We begin the habbit of disabling the alarm (and we think this is okay!).
We prepare for a take off, and as we do, we lose engine power and crash. The alarm we disabled
that was a false alarm, in this case, would have warned us to the lack of power and averted the
disaster.

So what's the human centred design here? In this case, it's that false alarms are just as dangerous
as real alerts. That we must account for humans who will ignore suprious error messages, and the
time they become important, they will continue to be ignored. This is an inconsistent behaviour.

One would easily blame the pilot, but infact it's not their fault - the design of the cockpit
gave them misleading signals, that cause a series of futher interactions that led to the incident.

An interesting example of this was the Three Mile Island nuclear plant disaster. Many causes were
provided, and people blamed the operators - however, a psychologist named Don Norman realised that
the disaster would always have occured as the control system *was misleading operators*, and it was
not possible for the human to interact with it correctly.

Don Norman has since written many texts and works discussing design principles and human interaction.

His principles are:

* Consistency
* Visibility
* Affordance (Discovery)
* Mapping (Relationships)
* Feedback
* Constraints

Each of these points is critically important in the design of a system.

### Consistency

Consistency is the property that behaviours should remain consistent between invocations or
uses of the tool, and between tools themself. Things that look similar *should* act similarly.

A simple example is cutlery. They consistently have a handle, that fits your hand, despite
the changes between the implement at the end (spoon, fork, knife). Regardless of the cutlery,
there is a consistency in the behaviour.

### Visibility

By inspecting the interface, the controls that can be used should be obvious If a task requires a series
of steps, then they should flow in the interface so that each step visibly leads to the next.
Controls should be easy to find and inspect.

Consider a ring-pull can. There is one possible action - to use the ring pull.

A good anti-pattern is keyboard shortcuts. They are hard to find because they lack visibility
despite the fact they "speed up" operation for those who know. They are a control that is
hard to find. Contrast to an onscreen button that can be "clicked". This is easy to find. It
doesn't mean everything should have an onscreen button however.

### Affordance (Discovery)

Affordance is a term that defines that when looking at an object or control, the behaviour
of the control and what ways it can be validly operated are immediately obvious.

For example, a keyboard, the only possible interaction of the control is to press the key.

An anti-pattern here is doors. A door with a vertical bar handle indicates "pull" as an affordance
- however the door may be hinged to "push". This isn't you being silly - the door afforded
you the wrong action! This is where doors-with-documentation (signs that say pull/push) came to
be.

Critically, this is why documentation does not solve design problems. You should have a design
that offers reasonable affordances, and documentation should be an extenstion describing
higher level concepts - not apologising for your design mistakes. (If you hear me saying
documentation is where bad design goes to die, this is why).

### Mapping

This is the relation ship between a control, and it's effects. For example, given four lights
arranged left to right, and below this, four buttons left to right it should be obvious
which button corresponds to which light. There is a mapping relationship between the buttons
to the lights. This is a good mapping, it requires no indications of function, and you know
what the control relates too.

Kitchen stoves are generally a good example of bad mapping - you have multiple knobs arranged
left to right, but the burners are in a grid. Once again, the knobs are "documented" to account
for their bad design.

### Feedback

When something is done, a user should know that the action was recieved and took place. In Australia
a great example of bad feedback is pedestrian crossings. Pressing the button gives no feedback
as to if your intent to cross was recieved - instead people stand there pressing the button multiple
times, to "hope" the system received their input. It is only once the light (eventually, up to 120
seconds later) goes green that you know your input was recieved.

Good feedback should be immediate and clear. Consider inserting coins to a vending machine. It
immediately shows you the new balance of the machine, or it returns the coin. This is good feedback.

### Constraints

Every interface should have limits to prevent invalid states being possible. They prevent invalid
data and other unknown effects.

An example of a bad-lack-of constraint was the classic 'rm -rf' command. Even in invalid (no permission)
states, it would continue and "remove as much as possible". Today this command has some better
constaints, but is still wildly dangerous.

A good example of constraints is a microwave. When the door is open, the magnetron is disabled.
This constraint exists as a safety tool to prevent injury to a human.

If you haven't now is a great time to research and study Finite State Machine. They are an excellent
way to model constraints.


### Using these in computers.

Here is some home work now: Using your computer, think about these principles and what is good and
bad. Some great examples to try:

* the C api calloc()
* the bash shell prompt
* the firewall-cmd command
* webbrowser tab operations
* ldapsearch command
* your phones camera
* Gnomes top-bar and interactions

Which design principles do these adhere to? Which do they violate? If you forget all your knowledge
about these tools today, could you still use them? Could you learn to re-use them? Think about
your experience to learn these tools in the first place. What was that experience like? Were you
learning new concepts, or were you learning "the tool"?

## Lib389 Data Model

Lib389 is a semi-structured ORM system for LDAP.

At one end of the spectrum, you have ldap itself, which is a protocol and system for issuing
arbitrary queries to semi-structured key-value objects.

At the other end, ORMs like in Django or SQL Alchemy are strict models of concepts to table
structured data.

It's pretty clear here that ORMs can't apply to LDAP - If you had an ORM for users, but one userAccount
also was extended by eduPerson, your ORM wouldn't know how to cope with this.

But at the same time, raw LDAP operations are really hard to use, and requires lots of inside knowledge
(LDAP servers largely violate visibility and affordance rules).

Lib389 is "in the middle". We have a thin ORM like component that allows selection of and query
of data, but we also are not so strict that data can not exceed the bounds of the object. For example
it should be very reasonable to have userAccount's with many different classes, and still interact
with all the various parts.

Lib389 helps by:

* Consistency - all datatypes are consistent of the same root classes, so a core set of actions is always true.
* Visibility - calling help() on any type will reveal the set of "helper" methods that can be performed on the ldap object.
* Affordance - Each api of lib389 gives clues to it's use. For example "get_attr_val_utf8" means "get an attribute value as utf8".
* Mapping - the relationship of each object is clear to what data will be changed in the LDAP server
* Feedback - Exceptions are raised quickly on failure, and results are returned determining the success of the action.
* Constraints - Lib389 limits your actions to a set of known abilities. For example, we don't make you create a person, with out checking that it has enough valid attributes.

Lib389's origin was in a testing API for the server, but testing and configuration both share
similarities. A goal of lib389 is to be the sole-administration point for the server.

One of the secret, hidden goals of lib389 has been personal - to eliminate the usage of ldifs and
ldapmodify. ldifs and ldapmodify violate about every design principle there is, and I never want to
see one ever again. I want there to be an easy to use API that helps me administer the server. lib389
is the LDAP admin toolkit I wish I had 5 years ago.

## Lib389 API design guide

We can now take these principles to how we design API's and objects in lib389.

### Consistency

All new features should be subclasses of DSLdapObject(s). If you are writing something and it feels
like it's hard to make it work with DSLdapObject(s), there are two causes:

* You are making a mistake in how your are using the interface.
* The server is implemented incorrectly. (This happens more than you think ...)

A good interface with DSLdapObject(s) is the memberOf plugin tooling.

A bad interface is the UidUniqueness plugin (the cn=config syntax does not map well to lib389, but
this is the fault of the plugin, not DSLdapObjects).

This means, with DSLdapObjects in mind, new features should think about how their configurations
will map to the object model and it's interaction. Additionally, when we are implementing
new features in lib389, they should all use this model for a consistent API.

### Visibility

Every attribute of the class should have a get/set for those attributes, with associated help text.
This allows them to be found easily (For batching, see constraints below). This helps relieve
burden on documentation, since every possible action and configuration already exists as functions
in the lib389 api, and subsequent, means that we can easily remember and access these.

### Affordance

The interface should be clear how it works in it's naming, variable naming, and argument
mandatory status. Which of these is better?:

    def import(be=None, suffix=None, l=None, *args):

    def import_backend_ldif(be, ldif_name, replication_metadata=True):
    def import_suffix_ldif(suffix, ldif_name, replication_metadata=True):

Which of these is easier to see how to use? Which requires more or less validation?

### Mapping

Everything should be related clearly to the concepts of the server. This is mainly a case
for clear, consistent naming of functions, classes and variables. It also is important that
actions are clearly related to this plural or singular object types. Violations of this is
singulars referring to the plural, or the plural acting on many singulars.

### Feedback

Do not catch exceptions. Let it fail fast so that error feedback is immediately provided. In
the sucess case, use log messages to indicate operation success. Be clear about what succeeded
or failed, why, and what do to about it. Writing a good error message is just as important as
reporting the error itself.

If you see an error message but don't know what to do to fix it, that's bad feedback - clear
up the error message to indicate the correct course of action (or remove the possibility of error
at all).

### Constraints

If you need to have constraints, such as two attributes must always be set together, then
make your interface at the api level enforce and show this. For example:

    get_attr_x()
    get_attr_y()
    set_attr_x_and_y(x, y)

If you want to have someone use a backend *or* a suffix, write two functions, one for each! This
affords the correct usage *and* means that the constraints exist at a python level forcing those
values to be set.

## CLI design guide

The cli and it's interactions are also driven by these principles, and also by lots of anti-patterns
in cli tools.

* Consistency - All our CLI tools should have consistent schemes and behaviours in all subcommands
* Visibility - All our CLI tools should expose their attributes in the --help and tab completion
* Affordance - All our CLI tools should use clear language that describes the intent of the tool
* Mapping - All our CLI tools should be named by the concept and related parts of the server
* Feedback - All our CLI tools should declare success or any faults they recieve.
* Constraints - Our CLI tools should be limited to a set of known, good working actions.

### Consistency

All of our tools take concepts that flow from "largest to smallest". This means at each level we
become more and more specific. An example would be:

    dsctl <instance> <config concept> <concept actions> <action> <options> [--<optional options>]

This is important because it means all our tools always flow in this way, which provides a really nice
mental construction pattern. It makes typing easy, and all commands feel similar.

### Visibility

At each level, the visibility of what controls are available can be found by --help at each layer
or tab completion. Every level's --help should have a proper description of the level, and the naming
should be clear. Tab completion can help, but we should not rely on it solely for true visibility.

### Affordance

In a command line tool, this mainly relates to the "options" once we select the actual command at whatever depth
we are at. This is where required arguments should be positional and without '--', and optional
arguments are given by '--'.

In some cases of lib389, there are arguments that if not provided positionally will be interactively
prompted for, allowing the command to run even with a lack of infromation. It's arguable if this is
good or bad :)

### Mapping

This relates to clear, and accessible naming of the commands and what they do. For example

    dsconf <instance> backend create

There is only one possible relationship and action this could be.

### Feedback

Any error is immediately raised as an exception, and success is always indicated after an action.

### Constraints

This is especially important in the CLI. Not only is it important to constrain the options we allow
a user to use, but it is important to constrain what we *do not show*. For example, there are many
dangerous, unclear, and unhelpful options that the server supports, that we plainly should never show.

This one is very important. We have an oppotunity to *limit* what tasks and changes are offered
in our cli. These constraints are valuable because less commands is less confusion to an admin,
offering a more focused and easier experience.

For example, during an ldif export, there shouldn't be 10 options, and you need to provide 3 of them
to get what you want. The *defaults should be correct* and the remaining options should be considered
if they provide value at all.

### CLI Examples (good and bad)

Using our own cli, and made-up examples, let's go through some good and bad examples, and examine
why they are good and bad. I'm going to do everythig in terms of dsconf, because that's easy.

    1: dsconf config set --errorlog-level=4 --instance=instance
    2: dsconf instance config --password-policy --enable
    3: dsconf instance backend create --cn=userRoot
    4: dsconf instance backend import backend1 --no-index --ldif some.ldif
    5: dsconf instance backend delete backend1 backend2 backend3
    6: dsconf instance backend export backend1 backend2 --ldif=ldif1 --ldif=ldif2

Have a think about the principles and let's see what's good and bad here ....

* Example 1

This is a bad command because a constraint (instance requirement) has become an optional
argument, and it's harder to visibily see that the --instance is an option at all. One could validly
try to type 'dsconf config set --errorlog=4' and never find the instance setting.

* Example 2

This command is bad because config suddenly has many more "--" options at it's top level, which means
that it doesn't afford to it's valid usage - people may try "dsconfig instance config --password-policy
--memberof-plugin --enable". It's also likely a constraint violation, because we allowed multple
incorrect ways to use it.

* Example 3

This is the good command - and exists today in the code base. The options are visible, they have
a 1 to 1 mapping of what will happen (backend singular will be created), the --cn parameter is
truly optional (if not given it's prompted for), and constraints exist that make sure the
command works properly. The constraint is actually in lib389, in how it enforces a cn and
suffix, and additionally makes the mapping-tree for you so you don't have to.

* Example 4

This is a bad command. The --no-index flag, doesn't easily convey it's function to the consumer,
and additionally, the ability to create an import where the attributes are not indexed should be
a constraint violation because you leave the system in an invalid state. Finally, --ldif
is "required" for an import, yet it affords that it is optional by having a -- argument style (and
is not automatically prompted for ...)

* Example 5

This is a bad command. The confusion is in poor mapping, that a "singular" term of 'backend delete'
now suddenly applies to many things (Should be backendS delete). We shouldn't do looping in our
commands because that's the shell's job, and it's hard for us to properly represent a looping
structure in a single command line. For example here, what order are the backends deleted in? Is
the operation atomic? Can the system be left in partial states?

* Example 6

This is bad because the mapping relationship of backend export to ldif is not immediately clear.
As well we have inconsistency in the command, where a required argument has no --, but the ldif
requires a --.

It lacks constraint too. What happens if we have three backends and two ldifs? What will happen?


## Other general notes

* Always use positive language. Don't say "without_replication_metadata=False". That's confusing. If your
cli is "without_repldata" invert it to "replication_metadata=False" as soon as possible.

* The CLI tools are a tiny tiny thin wrapper over the top of lib389. If you are writing display
or formatting logic in lib389, you have it at the wrong level. If you're putting an ldap attribute
name in the cli tools, you have it at the wrong layer. Keep those levels and abstractions clean and
where they belong :)

#### Author

William Brown -- william at blackhats.net.au
