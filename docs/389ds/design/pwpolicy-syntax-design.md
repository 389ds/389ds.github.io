---
title: "Password Syntax Checking Design"
---

# New Password Syntax Checks
----------------

Overview
--------

The server's password syntax checking was lacking some common industry password syntax standards.  The server can how handle many new kinds of password syntax checking, but it is limited to evaluating only the new password as it does not do any kind of comparison between the current(old) password verses the new one.

Design
------

Here is a list of the new password syntax checks that ave been added to *389-ds-base.1.4.0*, and how they work

- Dictionary Checks.  The server uses the CrackLib dictionary for this check
- Monotonic Sequence Checks - You can define the maximum number of monotonic sequence characters that are allowed to be in a password.  A monotonic sequence is a series of characters (numbers or letters) that are in order (forwards or backwards):   **abcd, dcba, 1234, 4321**
- Monotonic Sequence Set Checks - You can define the maximum number monotonic sequence characters that are allowed to appear more than once:  **abc9284abc**
- Consecutive Character Classes - Maximum number of consecutive characters from the same class of characters (digits, alphas, specials, etc).  If this is set to 4 then the following password would be rejected because it has 5 consecutive numbers (the digits class):   **ajd83955_#**
- Palindrome Check - Checks if the password is a palindrome:  **mattam, 1234321**
- Bad word list - A custom case-insensitive list of words separated by a space that can not appear in a password.  
- User Attribute List - List of entry attributes of the user to compare to the new password. This works the same the trivial password check, but you can specify what attributes to compare in the entry.  Previously it only checked "**uid, sn, cn, givenname, mail, ou**", and now in addition to these attributes you can specify other attributes to check as well.  For more information on setting the token length of these attribute values see: <https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/configuration_command_and_file_reference/core_server_configuration_reference#cnconfig-passwordMinTokenLength_Password_Syntax>

Implementation
--------------

Here are the following attributes that were added the password policy configuration.  By default all of these features are disabled.

    passwordDictCheck: on|off
    passwordDictPath:  <PATH TO CUSTOM CRACKLIB DICTIONARY FILES>
    passwordMaxSequence: <number of characters - 0 disables feature>
    passwordMaxSeqSets: <number of characters - 0 disables feature>
    passwordMaxClassChars: <number of characters - 0 disables feature>
    passwordPalindrome: on|off
    passwordBadWords: WORD WORD WORD
    passwordUserAttributes: ATTR ATTR ATTR


Dependencies
------------

cracklib-devel.


Origin
-------------

https://pagure.io/389-ds-base/pull-request/49836

Author
------

<mreynolds@redhat.com>

