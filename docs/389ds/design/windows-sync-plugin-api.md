---
title: "Windows Sync Plugin API Design"
---

# Windows Sync Plugin API Design
------------------

{% include toc.md %}

### Introduction

The windows sync feature of 389 provides several plugin points. This allows plugins to

-   control the search parameters (base DN, scope, filter, attributes) used to search for entries
-   change the DN mapping between 389 and AD
-   change entries and modify parameters before mod/add operations, both ways
-   get the results of add/mod operations, and take action depending on the result
-   get called at the beginning and end of updates/initializations

Plugins must provide an init function. This init function may optionally return an opaque cookie to the winsync plugin framework. This cookie will be passed to all winsync plugins.

The include file winsync-plugin.h declares the public API. That file also provides example code including stubs for all plugin functions described below.

### Version 1 API functions
---------------------------

#### **winsync\_plugin\_init\_cb**


    typedef void * (*winsync_plugin_init_cb)(const Slapi_DN *ds_subtree, const Slapi_DN *ad_subtree);    
    #define WINSYNC_PLUGIN_INIT_CB 1    

This callback is called when a winsync agreement is created. The ds\_subtree and ad\_subtree from the agreement are read-only. The callback can allocate some private data to return as the return value of the function. If so, the plug-in must define a **winsync\_plugin\_destroy\_agmt\_cb** so that the private data can be freed. This private data is passed to every other callback function as the void \*cookie argument.

#### **winsync\_search\_params\_cb**

    typedef void (*winsync_search_params_cb)(void *cookie, const char *agmt_dn, char **base,    
                                             int *scope, char **filter, char ***attrs,    
                                             LDAPControl ***serverctrls);    

The four callbacks of this type are

    #define WINSYNC_PLUGIN_DIRSYNC_SEARCH_CB 2    

This allows the plug-in to change the AD DirSync search request parameters. The *serverctrls* will already contain the dirsync control.

    #define WINSYNC_PLUGIN_PRE_AD_SEARCH_CB 3    

This allows the plug-in to change the other AD search request parameters.

    #define WINSYNC_PLUGIN_PRE_DS_SEARCH_ENTRY_CB 4    

This allows the plug-in to change the search params when the winsync code does an internal search to get a local entry.

    #define WINSYNC_PLUGIN_PRE_DS_SEARCH_ALL_CB 5    

This allows the plug-in to change the search params when the winsync code does an internal search to get all of the local entries to be sync'ed.

-   agmt\_dn - const - the original AD base dn from the winsync agreement
-   scope - set directly e.g. \*scope = 42;
-   base, filter - malloced - to set, free first e.g.

    slapi_ch_free_string(filter);    
    *filter = slapi_ch_strdup("(objectclass=foobar)");    

winsync code will use slapi\_ch\_free\_string to free this value, so no static strings

-   attrs - NULL or null terminated array of strings - can use slapi\_ch\_array\_add to add e.g.

    slapi_ch_array_add(attrs, slapi_ch_strdup("myattr"));    

attrs will be freed with slapi\_ch\_array\_free, so caller must own the memory

-   serverctrls - NULL or null terminated array of LDAPControl\* - can use slapi\_add\_control\_ext to add

    slapi_add_control_ext(serverctrls, mynewctrl, 1 / add a copy /);    

serverctrls will be freed with ldap\_controls\_free, so caller must own memory

#### **winsync\_pre\_mod\_cb**

    typedef void (*winsync_pre_mod_cb)(void *cookie, const Slapi_Entry *rawentry, Slapi_Entry *ad_entry,    
                                       Slapi_Entry *ds_entry, Slapi_Mods *smods, int *do_modify);    

These callbacks are the main entry points that allow the plug-in to intercept modifications to local and remote entries. The four callbacks of this type are

    #define WINSYNC_PLUGIN_PRE_AD_MOD_USER_CB 6    

Called before an AD user entry is to be modified.

    #define WINSYNC_PLUGIN_PRE_AD_MOD_GROUP_CB 7    

Called before an AD group entry is to be modified.

    #define WINSYNC_PLUGIN_PRE_DS_MOD_USER_CB 8    

Called before a DS user entry is to be modified.

    #define WINSYNC_PLUGIN_PRE_DS_MOD_GROUP_CB 9    

Called before a DS group entry is to be modified.

-   rawentry - the raw AD entry, read directly from AD - this is read only
-   ad\_entry - the "cooked" AD entry - the DN in this entry should be set when the operation is to modify the AD entry
-   ds\_entry - the entry from the ds - the DN in this entry should be set when the operation is to modify the DS entry
-   smods - the post-processing modifications - these should be modified by the plugin as needed
-   do\_modify - if the code has some modifications that need to be applied, this will be set to true - if the plugin has added some items to smods this should be set to true - if the plugin has removed all of the smods, and no operation should be performed, this should be set to false

#### **winsync\_pre\_add\_cb**

    typedef void (*winsync_pre_add_cb)(void *cookie, const Slapi_Entry *rawentry, Slapi_Entry *ad_entry, Slapi_Entry *ds_entry);    

These callbacks are called when a new entry is being added to the local directory server from AD. The two callbacks of this type are

    #define WINSYNC_PLUGIN_PRE_DS_ADD_USER_CB 10    

Called before an AD user entry is to be added to the DS.

    #define WINSYNC_PLUGIN_PRE_DS_ADD_GROUP_CB 11    

Called before an AD group entry is to be added to the DS.

-   rawentry - the raw AD entry, read directly from AD - this is read only
-   ad\_entry - the "cooked" AD entry
-   ds\_entry - the entry to be added to the DS - all modifications should be made to this entry, including changing the DN if needed, since the DN of this entry will be used as the ADD target DN. This entry will already have had the default schema mapping applied.

#### **winsync\_get\_new\_dn\_cb**

    typedef void (*winsync_get_new_dn_cb)(void *cookie, const Slapi_Entry *rawentry,    
                                          Slapi_Entry *ad_entry, char **new_dn_string,    
                                          const Slapi_DN *ds_suffix, const Slapi_DN *ad_suffix);    

If a new entry has been added to AD, and we're sync'ing it over to the DS, we may need to create a new DN for the entry. The code tries to come up with a reasonable DN, but the plug-in may have different ideas. These callbacks allow the plug-in to specify what the new DN for the new entry should be. This is called from map\_entry\_dn\_inbound which is called from various places where the DN for the new entry is needed. The winsync\_pre\_add\_\* callbacks can also be used to set the DN just before the entry is stored in the DS. The get\_new\_dn\_cb is also used when we are mapping a DN valued attribute e.g. owner or secretary. The two callbacks of this type are

    #define WINSYNC_PLUGIN_GET_NEW_DS_USER_DN_CB 12    

Called to get a new user DN

    #define WINSYNC_PLUGIN_GET_NEW_DS_GROUP_DN_CB 13    

Called to get a new group DN

-   rawentry - the raw AD entry, read directly from AD - this is read only
-   ad\_entry - the "cooked" AD entry
-   new\_dn\_string - the given value will be the default value created by the sync code to change it, slapi\_ch\_free\_string first, then malloc or slapi\_ch\_strdup or slapi\_ch\_smprintf the value to use
-   ds\_suffix - the suffix from the DS side of the sync agreement
-   ad\_suffix - the suffix from the AD side of the sync agreement

#### **winsync\_pre\_ad\_mod\_mods\_cb**

    typedef void (*winsync_pre_ad_mod_mods_cb)(void *cookie, const Slapi_Entry *rawentry,    
                                               const Slapi_DN *local_dn, const Slapi_Entry *ds_entry,    
                                               LDAPMod * const *origmods, Slapi_DN *remote_dn,    
                                               LDAPMod ***modstosend);    

These callbacks are called when a mod operation is going to be replayed to AD. This case is different than the pre add or pre mod callbacks above because in this context, we may only have the list of modifications and the DN to which the mods were applied. The two callbacks of this type are

    #define WINSYNC_PLUGIN_PRE_AD_MOD_USER_MODS_CB 14    

Called before the mod operation is replayed to AD for a user entry.

    #define WINSYNC_PLUGIN_PRE_AD_MOD_GROUP_MODS_CB 15    

Called before the mod operation is replayed to AD for a group entry.

-   rawentry - the raw AD entry, read directly from AD - may be NULL
-   local\_dn - the original local DN used in the modification
-   ds\_entry - the local DS entry
-   origmods - the original mod list
-   remote\_dn - this is the DN which will be used with the remote modify operation to AD - the winsync code may have already attempted to calculate its value
-   modstosend - this is the list of modifications which will be sent - the winsync code will already have done its default mapping to these values

#### **winsync\_can\_add\_to\_ad\_cb**

    typedef int (*winsync_can_add_to_ad_cb)(void *cookie, const Slapi_Entry *local_entry, const Slapi_DN *remote_dn);    

Callbacks used to determine if an entry should be added to the AD side if it does not already exist. Should return *True* to mean this entry should be added, or *False* otherwise. The one callback of this type is

    #define WINSYNC_PLUGIN_CAN_ADD_ENTRY_TO_AD_CB 16    

-   local\_entry - the candidate entry to test
-   remote\_DN - the candidate remote entry to add

#### **winsync\_plugin\_update\_cb**

    typedef void (*winsync_plugin_update_cb)(void *cookie, const Slapi_DN *ds_subtree, const Slapi_DN *ad_subtree, int is_total);    

Callbacks called at begin and end of update. The ds subtree and the ad subtree from the sync agreement are passed in. These are read only. **is\_total** will be true if this is a total update, or false if this is an incremental update. The two callbacks of this type are

    #define WINSYNC_PLUGIN_BEGIN_UPDATE_CB 17    

Called when the update operation is beginning.

    #define WINSYNC_PLUGIN_END_UPDATE_CB 18    

Called when the update operation is finished.

#### **winsync\_plugin\_destroy\_agmt\_cb**

    typedef void (*winsync_plugin_destroy_agmt_cb)(void *cookie, const Slapi_DN *ds_subtree, const Slapi_DN *ad_subtree);    

Callback called when the agreement is destroyed. The ds subtree and the ad subtree from the sync agreement are passed in. These are read only. The plugin must define this function to free the cookie allocated in the init function, if any. The one callback of this type is

    #define WINSYNC_PLUGIN_DESTROY_AGMT_CB 19    

<br>

### Version 2 API functions
---------------------------

Version 2 of the API was added with 389-ds-base 1.2.11. **NOTE** - the post callbacks may change the result code, but doing this will not "rollback" successful operations, nor "retry" failed operations.

Version 2 provides the following additional functions:

#### **winsync\_post\_mod\_cb**

    typedef void (*winsync_post_mod_cb)(void *cookie, const Slapi_Entry *rawentry, Slapi_Entry *ad_entry,    
                                        Slapi_Entry *ds_entry, Slapi_Mods *smods, int *result);    

Callback called after a modify operation. Called upon both success and failure of the modify operation. The plugin is responsible for looking at the result code of the modify to decide what action to take. The plugin may change the result code e.g. to force an error for an otherwise successful operation, or to ignore certain errors.

The four callbacks of this type are

    #define WINSYNC_PLUGIN_POST_AD_MOD_USER_CB 20    

Called after an AD user entry has been modified.

    #define WINSYNC_PLUGIN_POST_AD_MOD_GROUP_CB 21    

Called after an AD group entry has been modified.

    #define WINSYNC_PLUGIN_POST_DS_MOD_USER_CB 22    

Called after a DS user entry has been modified.

    #define WINSYNC_PLUGIN_POST_DS_MOD_GROUP_CB 23    

Called after a DS group entry has been modified.

-   rawentry - the raw AD entry, read directly from AD - this is read only
-   ad\_entry - the "cooked" AD entry - the entry passed to the pre\_mod callback
-   ds\_entry - the entry from the ds - the DS entry passed to the pre\_mod callback
-   smods - the mods used in the modify operation
-   result - the result code from the modify operation - the plugin can change this

#### **winsync\_post\_add\_cb**

    typedef void (*winsync_post_add_cb)(void *cookie, const Slapi_Entry *rawentry,    
                                        Slapi_Entry *ad_entry, Slapi_Entry *ds_entry, int *result);    

Callback called after an attempt to add a new entry to the local directory server from AD. Called upon success or failure of the add attempt. The result code tells if the operation succeeded or not. The plugin may change the result code e.g. to force an error for an otherwise successful operation, or to ignore certain errors. The two callbacks of this type are

    #define WINSYNC_PLUGIN_POST_DS_ADD_USER_CB 24    

Called after a DS user entry has been added from AD.

    #define WINSYNC_PLUGIN_POST_DS_ADD_GROUP_CB 25    

Called after a DS group entry has been added from AD.

-   rawentry - the raw AD entry, read directly from AD - this is read only
-   ad\_entry - the "cooked" AD entry
-   ds\_entry - the entry attempted to be added to the DS
-   result - the result code from the add operation - plugin may change this

#### **winsync\_pre\_ad\_add\_cb**

    typedef void (*winsync_pre_ad_add_cb)(void *cookie, Slapi_Entry *ds_entry, Slapi_Entry *ad_entry);    

These callbacks are called when a new entry is being added to AD from the local directory server. The two callbacks of this type are

    #define WINSYNC_PLUGIN_PRE_AD_ADD_USER_CB 26    

Called before a user entry is added to AD

    #define WINSYNC_PLUGIN_PRE_AD_ADD_GROUP_CB 27    

Called before a group entry is added to AD

-   ds\_entry - the local DS entry
-   ad\_entry - the entry to be added to AD - all modifications should be made to this entry, including changing the DN if needed, since the DN of this entry will be used as the ADD target DN. This entry will already have had the default schema mapping applied

#### **winsync\_post\_ad\_add\_cb**

    typedef void (*winsync_post_ad_add_cb)(void *cookie, Slapi_Entry *ds_entry, Slapi_Entry *ad_entry, int *result);    

Callbacks called after an attempt to add a new entry to AD from the local directory server. Called upon success or failure of the add attempt. The result code tells if the operation succeeded. The plugin may change the result code e.g. to force an error for an otherwise successful operation, or to ignore certain errors. The two callbacks of this type are

    #define WINSYNC_PLUGIN_POST_AD_ADD_USER_CB 28    

Called after an attempt to add a user entry to AD.

    #define WINSYNC_PLUGIN_POST_AD_ADD_GROUP_CB 29    

Called after an attempt to add a group entry to AD.

-   ad\_entry - the AD entry
-   ds\_entry - the DS entry
-   result - the result code from the add operation - plugin may change this

#### **winsync\_post\_ad\_mod\_mods\_cb**

    typedef void (*winsync_post_ad_mod_mods_cb)(void *cookie, const Slapi_Entry *rawentry, const Slapi_DN *local_dn,    
                                                const Slapi_Entry *ds_entry, LDAPMod * const *origmods,    
                                                Slapi_DN *remote_dn, LDAPMod **modstosend, int *result);    

These callbacks are called after a mod operation has been replayed to AD. This case is different than the pre add or pre mod callbacks above because in this context, we may only have the list of modifications and the DN to which the mods were applied. If the plugin wants the modified entry, the plugin can search for it from AD. The plugin is called upon success or failure of the modify operation. The result parameter gives the ldap result code of the operation. The plugin may change the result code e.g. to force an error for an otherwise successful operation, or to ignore certain errors. The two plugins of this type are

    #define WINSYNC_PLUGIN_POST_AD_MOD_USER_MODS_CB 30    

Called after the attempt to modify a user entry in AD

    #define WINSYNC_PLUGIN_POST_AD_MOD_GROUP_MODS_CB 31    

Called after the attempt to modify a group entry in AD

-   rawentry - the raw AD entry, read directly from AD - may be NULL
-   local\_dn - the original local DN used in the modification
-   ds\_entry - the current DS entry that has the operation nsUniqueID
-   origmods - the original mod list
-   remote\_dn - the DN of the AD entry
-   modstosend - the mods sent to AD
-   result - the result code of the modify operation

<br>

### <a name="v3-api"></a>Version 3 API functions
------------------------------------------------

The major change with Version 3 was the ability to run multiple winsync plugins. In order to do this, we needed to have some way to specify the order in which the plugins are run. The core SLAPI has support for the nsslapd-pluginprecedence attribute. Unfortunately, there is no way for winsync to get access to this attribute. Winsync plugin writers are strongly encouraged to use this attribute in the plugin config entry, retrieve it in the plugin init function, store it in a static variable, and provide it in the callback.

For example, if you have your plugin configuration entry like this:

    dn: cn=my winsync plugin,cn=plugins,cn=config    
    nsslapd-pluginprecedence: 75    
    nsslapd-pluginpath: libmywinsync-plugin    
    nsslapd-plugininitfunc: my_winsync_plugin_init    
    ...    

You should do something like this in your code:

    myplugin.c:    
    ...    
    static int myprecedence = 50; /* or default value */    
    ...    
    static int my_winsync_precedence(void)    
    {    
        return myprecedence;    
    }    
    ...    
    static void *my_winsync_api_v3[] = {    
        NULL, /* reserved for api broker use, must be zero */    
        ... other functions ...,    
        my_winsync_precedence    
    };    
    ...    
    static int my_winsync_plugin_start(Slapi_PBlock *pb)    
    {    
        int rc = slapi_apib_register(WINSYNC_v3_0_GUID, my_winsync_api_v3);    
        /* handle errors */    
        return rc;    
    }    
    ...    
    int my_winsync_plugin_init(Slapi_PBlock *pb)    
    {    
        Slapi_Entry *confige = NULL;    
        if (slapi_pblock_get(pb, SLAPI_PLUGIN_CONFIG_ENTRY, &confige) && confige) {    
            myprecedence = slapi_entry_attr_get_int(confige, "nsslapd-pluginprecedence");    
            if (!myprecedence) {    
                myprecedence = 50; /* or default value */    
            }    
        }    
        /* register start function, etc. */    
    }    

Note that the precedence is called very early, even before the WINSYNC\_PLUGIN\_INIT\_CB function is called, so the value to use for the precedence callback must be initialized in the plugin init function.

Version 3 provides the following additional functions:

#### **winsync\_plugin\_precedence\_cb**

    typedef int (*winsync_plugin_precedence_cb)(void);    

These callbacks are called before the WINSYNC\_PLUGIN\_INIT\_CB functions are called, in order to establish the order of calling the winsync plugins. Therefore, this plugin is called without the cookie argument, since it is not created until the WINSYNC\_PLUGIN\_INIT\_CB function is called. The only thing this function should do is return the precedence value. The plugin is responsible for setting the value to return in the callback. It is not handled automatically as in regular SLAPI plugins with the *nsslapd-pluginprecedence* value, although it works the same way - lower precedence values are called before higher precedence values e.g. a plugin with a precedence of 25 is called before a plugin with a precedence of 50. If two plugins have the same precedence, the order is undefined.

    #define WINSYNC_PLUGIN_PRECEDENCE_CB 32    

<br>

### Using the Public API in Plug-in Code
----------------------------------------

The plug-in should be of type *preoperation*, but any plug-in type should work. In addition to the usual preop plug-in code, the plug-in will register itself with the slapi\_apib. In order to do this, it will have to create an array of callback functions to pass to the apib code to register the winsync callbacks, e.g.

    static void *test_winsync_api[] = {    
       NULL, /* reserved for api broker use, must be zero */    
       test_winsync_api_init,    
       test_winsync_dirsync_search_params_cb,    
       test_winsync_pre_ad_search_cb,    
       test_winsync_pre_ds_search_entry_cb,    
       test_winsync_pre_ds_search_all_cb,    
       test_winsync_pre_ad_mod_user_cb,    
       test_winsync_pre_ad_mod_group_cb,    
       test_winsync_pre_ds_mod_user_cb,    
       test_winsync_pre_ds_mod_group_cb,    
       test_winsync_pre_ds_add_user_cb,    
       test_winsync_pre_ds_add_group_cb,    
       test_winsync_get_new_ds_user_dn_cb,    
       test_winsync_get_new_ds_group_dn_cb,    
       test_winsync_pre_ad_mod_user_mods_cb,    
       test_winsync_pre_ad_mod_group_mods_cb,    
       test_winsync_can_add_entry_to_ad_cb,    
       test_winsync_begin_update_cb,    
       test_winsync_end_update_cb,    
       test_winsync_destroy_agmt_cb,    
       test_winsync_post_ad_mod_user_cb,    
       test_winsync_post_ad_mod_group_cb,    
       test_winsync_post_ds_mod_user_cb,    
       test_winsync_post_ds_mod_group_cb,    
       test_winsync_post_ds_add_user_cb,    
       test_winsync_post_ds_add_group_cb,    
       test_winsync_pre_ad_add_user_cb,    
       test_winsync_pre_ad_add_group_cb,    
       test_winsync_post_ad_add_user_cb,    
       test_winsync_post_ad_add_group_cb,    
       test_winsync_post_ad_mod_user_mods_cb,    
       test_winsync_post_ad_mod_group_mods_cb,    
       test_winsync_precedence    
    };    

The test\_winsync\_api array index must correspond to the \#define for that callback e.g. WINSYNC\_PLUGIN\_INIT\_CB is defined to be 1, and the test\_winsync\_api\_init function is at array index 1 above. Array index 0 is reserved and must be set to NULL. In the preop plug-in start function, the plug-in should register the winsync API with the apib:

    static int    
    test_winsync_plugin_start(Slapi_PBlock *pb)    
    {    
    ...    
        if( slapi_apib_register(WINSYNC_v3_0_GUID, test_winsync_api) ) {    
            slapi_log_error( SLAPI_LOG_FATAL, test_winsync_plugin_name,    
                             "<-- test_winsync_plugin_start -- failed to register winsync api -- end\n");    
            return -1;    
        }    
    ...    
        return 0;    
    }    

The API function types and constants are defined in the winsync-plugin.h. The plug-in should define a plug-in close function to unregister the api:

    static int    
    test_winsync_plugin_close(Slapi_PBlock *pb)    
    {    
    ...    
        slapi_apib_unregister(WINSYNC_v3_0_GUID);    
    ...    
        return 0;    
    }    

The sample code for the test winsync plugin is included in the file ldap/servers/plugins/replication/windows\_private.c in the source distribution.

