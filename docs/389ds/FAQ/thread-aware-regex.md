---
title: "Thread Aware Regex"
---

# Thread Aware Regex
--------------------

Directory Server used to use the regular expression pattern matching and replacing library which was not thread safe. Thus, the regular expression operation should have been protected by the mutex lock. Regular expressions could be used by the search filters (syntax plugin), acl, schema file load, and SASL Mapping. If one of them took a long time, the rest should have been blocked. Replacing the library with the thread aware library solves the problem and improves the throughput.

[PCRE - Perl Compatible Regular Expressions](http://www.pcre.org/) library is installed on RHELs/Fedoras, by default. The pattern compiled by the library is thread safe:

`The compiled form of a regular expression is not altered during matching, `
`so the same compiled pattern can safely be used by several threads at once.`

We are taking advantage of it and replacing the old functions with PCRE.

PCRE is a rich library. We need just a subset of the APIs. We provide simplified slapi APIs wrapping the PCRE APIs.

<b>`NAME`</b>
`slapi_re_comp -- compiles a regular expression pattern. A thin wrapper of pcre_compile.`
<b>`SYNOPSIS`</b>
`Slapi_Regex *slapi_re_comp( char *pat, char **error );`
<b>`PARAMS`</b>
`pat: Pattern to be compiled.`
`error: The error string is set if the compile fails.`
<b>`RETURN VALUE`</b>
`a pointer to the regex handler which stores the compiled pattern.`
`NULL if the compile fails.`
<b>`WARNING`</b>
`The regex handler should be released by slapi_re_free().`

<b>`NAME`</b>
`slapi_re_exec -- matches a compiled regular expression pattern against a given string. A thin wrapper of pcre_exec.`
<b>`SYNOPSIS`</b>
`int slapi_re_exec( Slapi_Regex *re_handle, char *subject, time_t time_up );`
<b>`PARAMS`</b>
`re_handle: The regex handler returned from slapi_re_comp.`
`subject: A string to be checked against the compiled pattern.`
`time_up: If the current time is larger than the value, this function returns immediately.  (-1) means no time limit.`
<b>`RETURN VALUE`</b>
`0 if the string did not match.`
`1 if the string matched.`
`other values if any error occurred.`

<b>`NAME`</b>
`slapi_re_subs -- substitutes '&' or '\#' in the param src with the matched string.`
<b>`SYNOPSIS`</b>
`int slapi_re_subs( Slapi_Regex *re_handle, char *subject, char *src, char **dst, unsigned long dstlen );`
<b>`PARAMS`</b>
`re_handle: The regex handler returned from slapi_re_comp.`
`subject: A string checked against the compiled pattern.`
`src: A given string which could contain the substitution symbols.`
`dst: A pointer pointing to the memory which stores the output string.`
`dstlen: Size of the memory dst.`
<b>`RETURN VALUE`</b>
`1 if the substitution was successful.`
`0 if the substitution failed.`

<b>`NAME`</b>
`slapi_re_free -- releases the regex handler which was returned from slapi_re_comp.`
<b>`SYNOPSIS`</b>
`void slapi_re_free(Slapi_Regex *re_handle);`
<b>`PARAMS`</b>
`re_handle: The regex handler to be released.`
<b>`RETURN VALUE`</b>
`none`
