---
title: "HTML Editing"
---

# Basic HTML Editing
-------------------

{% include toc.md %}

Introduction
------------

Almost all of the different forms, pages, and sections for the web applications are HTML pages, and their appearance can be modified by editing the HTML pages or by editing the associated cascading style sheet (CSS) files. The default images used in the web apps can also be replaced or edited.

Changing Images
---------------

A number of images are supplied for buttons, illustrations, heading layout, and style. These images are all stored in the corresponding HTML directory for the web application. Any of these images can be edited, substituted, or removed. All of the default images are GIF files; we recommend using GIF files rather than other formats like JPEG, PNG, EPS, or TIFF.

Changing Page and Element Colors
----------------

The web application pages have at least two HTML pages that format the page. The first is the header; this is used on every page for that web application. The other page (or pages) layout the body of the page, such as search forms. Additionally, the Directory Server Gateway, Org Chart, and Directory Express all use a style sheet to control almost all of the design elements in the page.
The appearance of the web applications can be effectively customized by changing the colors used for the different page sections or by substituting default images with your own. It is also possible to rearrange page elements, change page text, and, for the gateway, change search parameters. For more advanced HTML editing information, see <http://htmlprimer.com/> (for HTML techniques) and the specific configuration sections for the web applications (for editing gateway pages).
The colors used for the different page elements in the web apps can be edited in two ways:

-   In a cascading style sheet (CSS) file
-   Inline with the `&lt;body&gt;` tag (for standard elements) or directly on the tag

    TIP!
    HTML colors can be changed either by using the color name or the six-digit hexadecimal value of the color (#RRGGBB;). For example, both inline settings — <body bgcolor="navy"> and <body bgcolor="#000080"> — change the background color to navy blue. See http://htmlprimer.com/htmlprimer/colors-web for a list of named HTML colors. Try http://www.colorcombo.com/bghex.html to convert RGB colors to hexadecimal for HTML.

Editing CSS Files
-----------------

Directory Server Gateway, Org Chart, and Directory Express all have a `style.css` file which is referenced by their HTML pages by default. Editing this file is the simplest way to change the page style. CSS formatting is the same format as inline formatting using the `style` parameter or styles set in the HTML page heading with `<style>` tags. For example, this sets colors for `<body>` and `<td>` (table cell) elements and for the `.bgColor1;` class:


    body {
       background-color: #FFFFFF;
       font-family: Verdana, Arial, Helvetica, san-serif;
       font-size: 11px;
    }

    td {
       font-family: Verdana, Arial, Helvetica, sans-serif;
       font-size: 11px;
       color: #000000; Sets the text color.
       vertical-align : middle;

    .bgColor1 {background-color: #000000;} The period in front of the name means it's a class.

For a CSS tutorial and overview, check out <http://www.html.net/tutorials/css/>.

### Editing Tags

All of the page elements for Admin Express are set inline on the tags; any element in any of the other web applications can also be changed by setting attributes on the tags, by using the `style` attribute, or by using `<font>` or `<span>` tags.
The `<body>` can set attributes for five different page elements:

-   Regular text colors (using the `TEXT` attribute)
-   Background color for the page (using the `BGCOLOR` attribute)
-   Link color (using the `LINK` attribute)
-   Visited link color (using the `VLINK` attribute)
-   Selected link color (using the `ALINK` attribute)

For example:

    <body bgcolor="#A70000" text="#FFFFFF" link="#CCCCCC" vlink="#5C5C4F" alink="#FF8D00">

Other page elements, like table cells, paragraphs, lists, and individual words, can also be edited using inline tags. For example:

    <td bgcolor="#006666" colspan=4>
     <p style="color: white;">
      This example paragraph is white. The <FONT FACE="ARIAL, HELVETICA" color="#A70000">example
      text</FONT> is in dark red.
     </p>
    </td> 

Sometimes, elements in an HTML page inherit properties from their parent element (whatever tags they are inside). For example, since everything is inside the `<body>` tag, the background color in the body is the same for every element on the page, unless an inline tag overrides it. Setting the background color on a table will automatically use hat background for every cell and row in the table:
`<table cellspacing="2" bgcolor="#F2F2F2">`

See Also
========

-   Back to the [overview](webapps-overview.html)
-   How to [install and setup](webapps-install.html) the web apps
-   [ Directory Server Gateway](dsgw.html)
-   [ Directory Express](dsexpress.html)
-   [ Org Chart](orgchart.html)
-   [ Admin Express](adminexpress.html)
-   [DSML gateway](dsml.html)

