---
title: "Annotated GPL Exception License"
---

# Annotated GPL Exception License

This is an Annotated version of the [GPL + Exception](../development/gpl-exception-license-text.html) license used in the core of the Directory Server code. As always, do not take this as legal advice. See a lawyer.

### Preamble

`
This Program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 2 of the License.
`

This is the preamble of the License. It indicates that this code is available under version 2 of the GPL license. Note that this license is not upgradable to later versions. Many projects use an upgradable version of the GPL; we have decided not to do so.

### Disclaimer of Warranty

`
This Program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
`

We're not responsible if this software eats your children. Or backs over your cat. Or causes a nuclear meltdown.

### Full License Text

`
You should have received a copy of the GNU General Public License along with this Program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
`

This is where to get a copy of the full text of the GNU GPL if it wasn't included with this software. It usually is, but you should able to get it if for some reason it's missing.

### Special Exception

A note about this special exception. The goal of this exception was to make it possible to build, use and distribute plugins for the Directory Server under the license of your choice but to make sure that the core of the Directory Server is maintained as a whole under an open source license, and to require that other users of it to also do the same. For example, if you wanted to replace some core piece of functionality in the directory server you would be required to give that piece back and everyone would benefit from that work. If you want to expose some proprietary functionality through the Directory Server and distribute a work that includes the two, that's OK, but you're limited to the interfaces specified in this exception. Please note that the plugin api is relatively rich and it should satisfy most users of the Directory Server.

`
In addition, as a special exception, Red Hat, Inc. gives You the additional right to link the code of this Program with code not covered under the GNU General Public License ("Non-GPL Code") and to distribute linked combinations including the two, subject to the limitations in this paragraph.
`

This says that you have the additional right to distribute code that's not covered by the GPL with this code. But that right only extends to the limitations that are outlined in the rest of this paragraph.

`
Non-GPL Code permitted under this exception must only link to the code of this Program through those well defined interfaces identified in the file named EXCEPTION found in the source code files (the "Approved Interfaces").
`

The interfaces that you can use to link to the GPLed code are defined in another file. Also note the use of the words 'well defined' here. This means that if the interface description is 'vague' or 'not well defined' that you do not have the right to use them. The use of a separate file means that if we change the list of Approved Interfaces that we won't have to update every file with that piece of minutia.

`
The files of Non-GPL Code may instantiate templates or use macros or inline functions from the Approved Interfaces without causing the resulting work to be covered by the GNU General Public License.
`

This clause is here to indicate that if you happen to use header files from the Approved Interfaces and those header files contain code that is then linked into your work then your work is not covered by the GNU GPL. Note that this doesn't talk about header files since including header files isn't the problem. It's the code that's generated as a result of using those header files that might, in some interpretations, cause your work to be covered under the GNU GPL.

`
Only Red Hat, Inc. may make changes or additions to the list of Approved Interfaces.
`

This means that only Red Hat, Inc. gets to make changes to the list of Approved Interfaces. Since the file that contains the list of Approved Interfaces is also distributed under the GNU GPL, it's perfectly fine to make changes to that file. We just wanted to make sure that if you do make changes to that file that the additional rights granted through this exception do not apply.

`
You must obey the GNU General Public License in all respects for all of the Program code and other code used in conjunction with the Program except the Non-GPL Code covered by this exception.
`

This says that you still have to follow the GNU GPL outside of the scope of this exception.

`
If you modify this file, you may extend this exception to your version of the file, but you are not obligated to do so. If you do not wish to provide this exception without modification, you must delete this exception statement from your version and license this file solely under the GPL without exception.
`

This says that if you want, you can remove this exception when you distribute your copy of this code. Also, if you remove this exception you must also make sure that you license it under the GPL.
