---
title: Third Party Plugins
---

# Third Party Plugins
---------------------

{% include toc.md %}

List of Known Public Plugins
----------------------------

### Server Side Modification

[SSM Plugin on Github](https://github.com/CESNET/389ds-plugin-ssm)

SSM is a plugin published by Czech Technical University from Prague, which
allows event driven attribute generation and templating into entries through
a DSL that can call into known slapi symbols to generate the content.

This can be considered similar to "COS" (class of service) except that it
allows further templating and logic to be applied, and the values are stored
into the entry rather than in memory generated.

Why should I Publish my Plugin?
-------------------------------

If a plugin is known to the team, we can help advise on it's development
and do code reviews. If more users deploy or use the plugin we might
consider it for inclusion in the main project. It also really helps
us to understand how people are using the plugin api and possible
areas that we should and could extend the server. So please open
source your plugins!

